-- CREATE DATABASE AUTOLAND;
-- \c autoland

DROP SCHEMA IF EXISTS grupo10 CASCADE;
CREATE SCHEMA grupo10;

SET search_path TO grupo10;

CREATE TABLE mecanico (
    dni varchar(8) PRIMARY KEY,
    nombres varchar(50) NOT NULL,
    apellidos varchar(50) NOT NULL,
    RUC varchar(11) NOT NULL UNIQUE,
    salario numeric(10,2) NOT NULL
);

CREATE TABLE asesor (
    dni varchar(8) PRIMARY KEY,
    nombres varchar(50) NOT NULL,
    apellidos varchar(50) NOT NULL,
    RUC varchar(11) NOT NULL UNIQUE,
    salario numeric(10,2) NOT NULL
);

CREATE TABLE cliente (
    dni varchar(8) PRIMARY KEY,
    nombres varchar(50) NOT NULL,
    apellidos varchar(50) NOT NULL
);

CREATE TABLE empresa (
    RUC varchar(11) PRIMARY KEY,
    razonsocial varchar(50) NOT NULL UNIQUE
);

CREATE TABLE representante (
    dni varchar(8) PRIMARY KEY,
    nombres varchar(50) NOT NULL,
    apellidos varchar(50) NOT NULL,
    empresa_RUC varchar(11) NOT NULL REFERENCES empresa(RUC)
);

CREATE TABLE modelo (
    id int PRIMARY KEY,
    marca varchar(50) NOT NULL,
    nombre varchar(50) NOT NULL,
    anio int NOT NULL,
    preciosugerido numeric(10,2) NOT NULL,
    categoria varchar(10) NOT NULL
);

CREATE TABLE motor (
    codigo varchar(20) PRIMARY KEY,
    marca varchar(20) NOT NULL,
    combustible varchar(20) NOT NULL,
    cilindros int NOT NULL,
    cilindrada int NOT NULL,
    potencia int NOT NULL
);

CREATE TABLE vehiculo (
    vin varchar(17) PRIMARY KEY,
    color varchar(20) NOT NULL,
    preciocompra numeric(10,2) NOT NULL,
    precioventa numeric(10,2) NOT NULL,
    kilometraje int NOT NULL,
    transmision varchar(10) NOT NULL,
    motor_codigo varchar(20) NOT NULL REFERENCES motor(codigo),
    modelo_id int NOT NULL REFERENCES modelo(id)
);

CREATE TABLE compra (
    codigo int PRIMARY KEY,
    fecha date NOT NULL,
    cliente_dni varchar(8) NOT NULL REFERENCES cliente(dni),
    vehiculo_vin varchar(17) NOT NULL REFERENCES vehiculo(vin),
    asesor_dni varchar(8) NOT NULL REFERENCES asesor(dni)
);

CREATE TABLE suministro (
    codigo int PRIMARY KEY,
    fecha date NOT NULL,
    representante_dni varchar(8) NOT NULL REFERENCES representante(dni)
);

CREATE TABLE serviciopostventa (
    compra_codigo int NOT NULL REFERENCES compra(codigo),
    orden int NOT NULL,
    fechainicio date NOT NULL,
    fechafin date NOT NULL,
    costo numeric(10,2) NOT NULL,
    tipo varchar(15) NOT NULL,
    PRIMARY KEY (compra_codigo, orden)
);

CREATE TABLE inspeccion (
    nro int PRIMARY KEY,
    fecha date NOT NULL,
    vehiculo_vin varchar(17) NOT NULL REFERENCES vehiculo(vin)
);

CREATE TABLE m_inspecciona (
    mecanico_dni varchar(8) NOT NULL REFERENCES mecanico(dni),
    inspeccion_nro int NOT NULL REFERENCES inspeccion(nro),
    PRIMARY KEY (mecanico_dni, inspeccion_nro)
);

CREATE TABLE m_trabaja (
    mecanico_dni varchar(8) NOT NULL REFERENCES mecanico(dni),
    compra_codigo int NOT NULL,
    serviciopostventa_orden int NOT NULL,
    fecha date NOT NULL,
    preciomaterial numeric(10,2) NOT NULL,
    PRIMARY KEY (mecanico_dni, compra_codigo, serviciopostventa_orden),
    FOREIGN KEY (compra_codigo, serviciopostventa_orden) REFERENCES serviciopostventa(compra_codigo, orden)
);


