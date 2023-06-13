
-- 1)
-- Obtener la lista de camionetas en stock cuya cilindrada sea de almenos 2000 cc
-- y su modelo reciba mas servicios de postventa que el promedio.

SET search_path TO grupo10;

-- vista materializada de vehiculos en stock
-- crear vista de vehiculos no comprados (su VIN no esta en la tabla de compra)
CREATE MATERIALIZED VIEW vehiculos_en_stock AS (
    SELECT *
    FROM vehiculo
    WHERE vehiculo.vin NOT IN (SELECT compra.vehiculo_vin FROM compra)
);

-- realizar consulta 1
WITH subquery AS (
    SELECT AVG(cuenta) AS promedio
    FROM (
        SELECT COUNT(*) AS cuenta
        FROM (SELECT compra_codigo FROM serviciopostventa) AS S
        JOIN (SELECT codigo, vehiculo_vin FROM compra) AS C
        ON S.compra_codigo = C.codigo
        JOIN (SELECT vin, modelo_id FROM vehiculo) AS V
        ON C.vehiculo_vin = V.vin
        GROUP BY modelo_id
    ) S
)
SELECT *
FROM vehiculos_en_stock AS V
JOIN (SELECT codigo, cilindrada FROM motor) AS M
ON V.motor_codigo = M.codigo
WHERE M.cilindrada >= 2000
AND V.modelo_id IN (
    SELECT modelo_id
    FROM (SELECT compra_codigo FROM serviciopostventa) AS S
        JOIN (SELECT codigo, vehiculo_vin FROM compra) AS C
        ON S.compra_codigo = C.codigo
        JOIN (SELECT vin, modelo_id FROM vehiculo) AS V
        ON C.vehiculo_vin = V.vin
        GROUP BY modelo_id
    HAVING COUNT(*) > (SELECT promedio FROM subquery)
);


-- 2)
-- Obtener las inspecciones realizadas a los vehiculos comprados por clientes
-- que han comprado 2 vehiculos de la misma marca.

SET search_path TO grupo10;

-- subconsulta: obtener el vin de los vehiculos comprados por clientes que han comprado 2 vehiculos de la misma marca

SELECT CL.dni, V.modelo_id
FROM cliente AS CL
JOIN (SELECT cliente_dni, vehiculo_vin FROM compra) AS CO
ON CL.dni = CO.cliente_dni
JOIN (SELECT vin, modelo_id FROM vehiculo) AS V
ON CO.vehiculo_vin = V.vin
GROUP BY CL.dni, V.modelo_id
HAVING COUNT(*) = 2;


-- 3)
-- datos completos de la empresa cuyo representante realizo un suministro y
-- dicho auto fue inspeccionado por el mecanico con el salario mas alto

SELECT ruc, razonsocial 
FROM empresa 
JOIN (SELECT empresa_ruc AS em_ruc 
        FROM representante 
        JOIN (SELECT representante_dni
                FROM suministro 
                JOIN (SELECT suministro_codigo
                        FROM vehiculo 
                        JOIN (SELECT vehiculo_vin
                                FROM inspeccion 
                                JOIN (SELECT inspeccion_nro
                                        FROM m_inspecciona
                                        WHERE mecanico_dni
                                        IN (SELECT dni AS dni_max
                                            FROM mecanico
                                            WHERE salario =
                                                    (SELECT MAX(salario)
                                                        FROM mecanico))) s_max
                                ON (inspeccion.nro = s_max.inspeccion_nro) ) vin_maxs
                        ON (vehiculo.vin = vin_maxs.vehiculo_vin)) sum_cod
                ON (suministro.codigo = sum_cod.suministro_codigo)) rep
        ON (representante.dni = rep.representante_dni)) emp_ruc_max
ON (empresa.ruc = emp_ruc_max.em_ruc);
