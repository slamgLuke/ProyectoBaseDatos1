
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

