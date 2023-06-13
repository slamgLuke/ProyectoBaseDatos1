-- CREATE DATABASE AUTOLAND;
-- \c autoland

DROP SCHEMA IF EXISTS grupo10 CASCADE;
CREATE SCHEMA grupo10;

SET search_path TO grupo10;

-- 3fn
-- dni -> n,a,s,ruc
-- ruc -> n,a,s,dni
-- dni y ruc son llaves candidatas
CREATE TABLE mecanico (
    dni varchar(8) PRIMARY KEY,
    nombres varchar(50) NOT NULL,
    apellidos varchar(50) NOT NULL,
    RUC varchar(11) NOT NULL UNIQUE,
    salario numeric(10,2) NOT NULL
);

-- 3fn
-- dni -> n,a,s
-- ruc -> n,a,s
-- dni y ruc son llaves candidatas
CREATE TABLE asesor (
    dni varchar(8) PRIMARY KEY,
    nombres varchar(50) NOT NULL,
    apellidos varchar(50) NOT NULL,
    RUC varchar(11) NOT NULL UNIQUE,
    salario numeric(10,2) NOT NULL
);

-- 3fn
-- dni -> n,a
CREATE TABLE cliente (
    dni varchar(8) PRIMARY KEY,
    nombres varchar(50) NOT NULL,
    apellidos varchar(50) NOT NULL
);

-- 3fn
--  ruc -> rs
CREATE TABLE empresa (
    ruc varchar(11) PRIMARY KEY,
    razonsocial varchar(50) NOT NULL UNIQUE
);

-- 3fn
-- dni -> n,a,s,ruc
CREATE TABLE representante (
    dni varchar(8) PRIMARY KEY,
    nombres varchar(50) NOT NULL,
    apellidos varchar(50) NOT NULL,
    empresa_RUC varchar(11) NOT NULL REFERENCES empresa(RUC)
);

-- 3fn
-- id -> m,n,a,p,c
-- m,n,a -> id,p,c
-- m,n,a e id son llaves candidatas
CREATE TABLE modelo (
    id int PRIMARY KEY,
    marca varchar(20) NOT NULL,
    nombre varchar(20) NOT NULL,
    anio int NOT NULL,
    preciosugerido numeric(10,2) NOT NULL,
    categoria varchar(10) NOT NULL
);

-- 3fn
CREATE TABLE motor (
    codigo varchar(20) PRIMARY KEY,
    marca varchar(20) NOT NULL,
    combustible varchar(20) NOT NULL,
    cilindros int NOT NULL,
    cilindrada int NOT NULL,
    potencia int NOT NULL
);

-- 3fn 
CREATE TABLE vehiculo (
    vin varchar(17) PRIMARY KEY,
    color varchar(20) NOT NULL,
    preciocompra numeric(10,2) NOT NULL,
    precioventa numeric(10,2) NOT NULL,
    kilometraje int NOT NULL,
    transmision varchar(10) NOT NULL,
    motor_codigo varchar(20) NOT NULL REFERENCES motor(codigo),
    modelo_id int NOT NULL REFERENCES modelo(id),
    suministro_codigo int NOT NULL REFERENCES suministro(codigo)
);

-- 3fn
-- codigo -> f,cdni,vvin,adni
-- vehiculo_vin -> f,cdni,vvin,adni
-- vehiculo_vin y codigo son llaves candidatas
CREATE TABLE compra (
    codigo int PRIMARY KEY,
    fecha date NOT NULL,
    cliente_dni varchar(8) NOT NULL REFERENCES cliente(dni),
    vehiculo_vin varchar(17) NOT NULL REFERENCES vehiculo(vin),
    asesor_dni varchar(8) NOT NULL REFERENCES asesor(dni)
);

-- 3fn
-- codigo -> f, rdni
CREATE TABLE suministro (
    codigo int PRIMARY KEY,
    fecha date NOT NULL,
    representante_dni varchar(8) NOT NULL REFERENCES representante(dni)
);

-- 3fn
-- ccodigo, orden -> fi,ff,c,t
CREATE TABLE serviciopostventa (
    compra_codigo int NOT NULL REFERENCES compra(codigo),
    orden int NOT NULL,
    fechainicio date NOT NULL,
    fechafin date NOT NULL,
    costo numeric(10,2) NOT NULL,
    tipo varchar(15) NOT NULL,
    PRIMARY KEY (compra_codigo, orden)
);

-- 3fn
-- nro -> f,vvin
CREATE TABLE inspeccion (
    nro int PRIMARY KEY,
    fecha date NOT NULL,
    vehiculo_vin varchar(17) NOT NULL REFERENCES vehiculo(vin)
);

-- 3fn
CREATE TABLE m_inspecciona (
    mecanico_dni varchar(8) NOT NULL REFERENCES mecanico(dni),
    inspeccion_nro int NOT NULL REFERENCES inspeccion(nro),
    PRIMARY KEY (mecanico_dni, inspeccion_nro)
);

-- 3fn
-- mdni, ccodigo, sorden -> f, p
CREATE TABLE m_trabaja (
    mecanico_dni varchar(8) NOT NULL REFERENCES mecanico(dni),
    compra_codigo int NOT NULL,
    serviciopostventa_orden int NOT NULL,
    fecha date NOT NULL,
    preciomaterial numeric(10,2) NOT NULL,
    PRIMARY KEY (mecanico_dni, compra_codigo, serviciopostventa_orden),
    FOREIGN KEY (compra_codigo, serviciopostventa_orden) REFERENCES serviciopostventa(compra_codigo, orden)
);


