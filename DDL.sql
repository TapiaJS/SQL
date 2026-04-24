DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;


-- =================================================================
--                             MÓDULO 1 
-- =================================================================

-- Tabla 1
CREATE TABLE Sucursal (
    IdSucursal SERIAL,
    NombreSucursal VARCHAR(50),
    Calle VARCHAR(50),
    NumeroExterior INTEGER,
    NumeroInterior INTEGER,
    Colonia VARCHAR(50),
    Estado VARCHAR(30),
    Telefono VARCHAR(15)
);

-- PK
ALTER TABLE Sucursal ADD CONSTRAINT Sucursal_pk
PRIMARY KEY (IdSucursal);

-- Restricciones
ALTER TABLE Sucursal
ALTER COLUMN NombreSucursal SET NOT NULL,
ALTER COLUMN Calle SET NOT NULL,
ALTER COLUMN NumeroExterior SET NOT NULL,
ALTER COLUMN Colonia SET NOT NULL,
ALTER COLUMN Estado SET NOT NULL,
ALTER COLUMN Telefono SET NOT NULL;

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se agrega restricción a NumeroInterior CHECK es NULL o mayor a cero
ALTER TABLE Sucursal
ADD CONSTRAINT Sucursal_d1 CHECK (NumeroInterior IS NULL OR NumeroInterior > 0),
-- Se agrega restricción a NumeroExterior CHECK es mayor a cero
ADD CONSTRAINT Sucursal_d2 CHECK (NumeroExterior > 0);

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Sucursal IS 'Tabla que almacena la ubicación y contacto de las sucursales del sistema Hotline.';
COMMENT ON CONSTRAINT Sucursal_pk ON Sucursal IS 'Llave primaria: Identificador único autoincremental de la sucursal.';
COMMENT ON CONSTRAINT Sucursal_d1 ON Sucursal IS 'Validación: El número interior debe ser positivo si existe.';
COMMENT ON CONSTRAINT Sucursal_d2 ON Sucursal IS 'Validación: El número exterior debe ser estrictamente positivo.';


-- Tabla 2
CREATE TABLE Clinica (
    IdClinica SERIAL,
    NombreClinica VARCHAR(50),
    NumCuarto INTEGER,
    NumEmpleado INTEGER,
    IdSucursal INTEGER
);

-- PK
ALTER TABLE Clinica ADD CONSTRAINT Clinica_pk
PRIMARY KEY (IdClinica);

-- FK
ALTER TABLE Clinica ADD CONSTRAINT Clinica_fk
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE Clinica
ALTER COLUMN NombreClinica SET NOT NULL,
ALTER COLUMN NumCuarto SET NOT NULL,
ADD CONSTRAINT Clinica_d1 CHECK (NumCuarto > 0),
ALTER COLUMN NumEmpleado SET NOT NULL,
ALTER COLUMN IdSucursal SET NOT NULL,
ADD CONSTRAINT Clinica_u1 UNIQUE (IdSucursal);

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se elimina porque el número de empleados se calcula con funciones de agregación (DQL)
ALTER TABLE Clinica DROP COLUMN NumEmpleado;

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Clinica IS 'Tabla que representa las clínicas médicas integradas dentro de una sucursal.';
COMMENT ON CONSTRAINT Clinica_pk ON Clinica IS 'Llave primaria: Identificador de la clínica.';
COMMENT ON CONSTRAINT Clinica_fk ON Clinica IS 'Llave foránea: Vinculación obligatoria con una sucursal.';
COMMENT ON CONSTRAINT Clinica_d1 ON Clinica IS 'Validación: El número de cuarto asignado debe ser positivo.';
COMMENT ON CONSTRAINT Clinica_u1 ON Clinica IS 'Restricción: Garantiza que una sucursal solo tenga una clínica (relación 1:1).';

-- Tabla 3
CREATE TABLE Medico (
    RFC VARCHAR(13),
    Nombre VARCHAR(50),
    Paterno VARCHAR(50),
    Materno VARCHAR(50),
    Calle VARCHAR(50),
    NumeroExterior INTEGER,
    NumeroInterior INTEGER,
    Colonia VARCHAR(50),
    Estado VARCHAR(30),
    Dia VARCHAR(15),
    Entrada TIME,
    Salida TIME,
    Salario NUMERIC(10, 2),
    IdSucursal INTEGER,
    InstitucionEgreso VARCHAR(100),
    VigenciaCertificacion DATE,
    CedulaProfesional INTEGER
);

-- PK
ALTER TABLE Medico ADD CONSTRAINT Medico_pk
PRIMARY KEY (RFC);

-- FK
ALTER TABLE Medico ADD CONSTRAINT Medico_fk
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE Medico
ALTER COLUMN RFC SET NOT NULL,
ALTER COLUMN Nombre SET NOT NULL,
ALTER COLUMN Paterno SET NOT NULL,
ALTER COLUMN Materno SET NOT NULL,
ALTER COLUMN Calle SET NOT NULL,
ALTER COLUMN NumeroExterior SET NOT NULL,
ALTER COLUMN Colonia SET NOT NULL,
ALTER COLUMN Estado SET NOT NULL,
ALTER COLUMN Dia SET NOT NULL,
ALTER COLUMN Entrada SET NOT NULL,
ALTER COLUMN Salida SET NOT NULL,
ALTER COLUMN Salario SET NOT NULL,
ADD CONSTRAINT Medico_d1 CHECK (Salario > 0),
ALTER COLUMN IdSucursal SET NOT NULL,
ALTER COLUMN InstitucionEgreso SET NOT NULL,
ALTER COLUMN VigenciaCertificacion SET NOT NULL,
ALTER COLUMN CedulaProfesional SET NOT NULL,
ADD CONSTRAINT Medico_u1 UNIQUE (CedulaProfesional);

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se agrega restricción a NumeroInterior CHECK es NULL o mayor a cero
ALTER TABLE Medico
ADD CONSTRAINT Medico_d2 CHECK (NumeroInterior IS NULL OR NumeroInterior > 0),
-- Se agrega restricción a NumeroExterior CHECK es mayor a cero
ADD CONSTRAINT Medico_d3 CHECK (NumeroExterior > 0);

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Medico IS 'Tabla que almacena la información detallada del personal médico.';
COMMENT ON CONSTRAINT Medico_pk ON Medico IS 'Llave primaria: RFC del médico.';
COMMENT ON CONSTRAINT Medico_fk ON Medico IS 'Llave foránea: Sucursal de adscripción.';
COMMENT ON CONSTRAINT Medico_d1 ON Medico IS 'Validación: El salario debe ser estrictamente positivo.';
COMMENT ON CONSTRAINT Medico_u1 ON Medico IS 'Restricción: Garantiza la unicidad de la cédula profesional.';
COMMENT ON CONSTRAINT Medico_d2 ON Medico IS 'Validación: El número interior debe ser positivo si existe.';
COMMENT ON CONSTRAINT Medico_d3 ON Medico IS 'Validación: El número exterior debe ser estrictamente positivo.';


-- Tabla 4
CREATE TABLE Enfermero (
    RFC VARCHAR(13),
    Nombre VARCHAR(50),
    Paterno VARCHAR(50),
    Materno VARCHAR(50),
    Calle VARCHAR(50),
    NumeroExterior INTEGER,
    NumeroInterior INTEGER,
    Colonia VARCHAR(50),
    Estado VARCHAR(30),
    Dia VARCHAR(15),
    Entrada TIME,
    Salida TIME,
    Salario NUMERIC(10, 2),
    IdSucursal INTEGER,
    TipoProcedimientoCargo VARCHAR(100),
    CertificacionReanimacion BOOLEAN,
    CedulaProfesional INTEGER
);

-- PK
ALTER TABLE Enfermero ADD CONSTRAINT Enfermero_pk
PRIMARY KEY (RFC);

-- FK
ALTER TABLE Enfermero ADD CONSTRAINT Enfermero_fk
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE Enfermero
ALTER COLUMN RFC SET NOT NULL,
ALTER COLUMN Nombre SET NOT NULL,
ALTER COLUMN Paterno SET NOT NULL,
ALTER COLUMN Materno SET NOT NULL,
ALTER COLUMN Calle SET NOT NULL,
ALTER COLUMN NumeroExterior SET NOT NULL,
ALTER COLUMN Colonia SET NOT NULL,
ALTER COLUMN Estado SET NOT NULL,
ALTER COLUMN Dia SET NOT NULL,
ALTER COLUMN Entrada SET NOT NULL,
ALTER COLUMN Salida SET NOT NULL,
ALTER COLUMN Salario SET NOT NULL,
ADD CONSTRAINT Enfermero_d1 CHECK (Salario > 0),
ALTER COLUMN IdSucursal SET NOT NULL,
ALTER COLUMN TipoProcedimientoCargo SET NOT NULL,
ALTER COLUMN CertificacionReanimacion SET NOT NULL,
ALTER COLUMN CedulaProfesional SET NOT NULL,
ADD CONSTRAINT Enfermero_u1 UNIQUE (CedulaProfesional);

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se agrega restricción a NumeroInterior CHECK es NULL o mayor a cero
ALTER TABLE Enfermero
ADD CONSTRAINT Enfermero_d2 CHECK (NumeroInterior IS NULL OR NumeroInterior > 0),
-- Se agrega restricción a NumeroExterior CHECK es mayor a cero
ADD CONSTRAINT Enfermero_d3 CHECK (NumeroExterior > 0);

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Enfermero IS 'Tabla que registra al personal de enfermería y sus certificaciones.';
COMMENT ON CONSTRAINT Enfermero_pk ON Enfermero IS 'Llave primaria: RFC del enfermero.';
COMMENT ON CONSTRAINT Enfermero_fk ON Enfermero IS 'Llave foránea: Sucursal donde labora.';
COMMENT ON CONSTRAINT Enfermero_d1 ON Enfermero IS 'Validación: El salario debe ser positivo.';
COMMENT ON CONSTRAINT Enfermero_u1 ON Enfermero IS 'Restricción: Unicidad de la cédula profesional del enfermero.';
COMMENT ON CONSTRAINT Enfermero_d2 ON Enfermero IS 'Validación: Número interior positivo o nulo.';
COMMENT ON CONSTRAINT Enfermero_d3 ON Enfermero IS 'Validación: Número exterior estrictamente positivo.';

-- Tabla 5
CREATE TABLE Farmaceutico (
    RFC VARCHAR(13),
    Nombre VARCHAR(50),
    Paterno VARCHAR(50),
    Materno VARCHAR(50),
    Calle VARCHAR(50),
    NumeroExterior INTEGER,
    NumeroInterior INTEGER,
    Colonia VARCHAR(50),
    Estado VARCHAR(30),
    Dia VARCHAR(15),
    Entrada TIME,
    Salida TIME,
    Salario NUMERIC(10, 2),
    IdSucursal INTEGER,
    CedulaProfesional INTEGER
);

-- PK
ALTER TABLE Farmaceutico ADD CONSTRAINT Farmaceutico_pk
PRIMARY KEY (RFC);

-- FK
ALTER TABLE Farmaceutico ADD CONSTRAINT Farmaceutico_fk
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE Farmaceutico
ALTER COLUMN RFC SET NOT NULL,
ALTER COLUMN Nombre SET NOT NULL,
ALTER COLUMN Paterno SET NOT NULL,
ALTER COLUMN Materno SET NOT NULL,
ALTER COLUMN Calle SET NOT NULL,
ALTER COLUMN NumeroExterior SET NOT NULL,
ALTER COLUMN Colonia SET NOT NULL,
ALTER COLUMN Estado SET NOT NULL,
ALTER COLUMN Dia SET NOT NULL,
ALTER COLUMN Entrada SET NOT NULL,
ALTER COLUMN Salida SET NOT NULL,
ALTER COLUMN Salario SET NOT NULL,
ADD CONSTRAINT Farmaceutico_d1 CHECK (Salario > 0),
ALTER COLUMN IdSucursal SET NOT NULL,
ALTER COLUMN CedulaProfesional SET NOT NULL,
ADD CONSTRAINT Farmaceutico_u1 UNIQUE (CedulaProfesional);

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se agrega restricción a NumeroInterior CHECK es NULL o mayor a cero
ALTER TABLE Farmaceutico
ADD CONSTRAINT Farmaceutico_d2 CHECK (NumeroInterior IS NULL OR NumeroInterior > 0),
-- Se agrega restricción a NumeroExterior CHECK es mayor a cero
ADD CONSTRAINT Farmaceutico_d3 CHECK (NumeroExterior > 0);

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Farmaceutico IS 'Tabla que almacena los datos de los responsables de farmacia.';
COMMENT ON CONSTRAINT Farmaceutico_pk ON Farmaceutico IS 'Llave primaria: RFC del farmacéutico.';
COMMENT ON CONSTRAINT Farmaceutico_fk ON Farmaceutico IS 'Llave foránea: Sucursal asignada.';
COMMENT ON CONSTRAINT Farmaceutico_d1 ON Farmaceutico IS 'Validación: Salario positivo requerido.';
COMMENT ON CONSTRAINT Farmaceutico_u1 ON Farmaceutico IS 'Restricción: Unicidad de la cédula profesional.';
COMMENT ON CONSTRAINT Farmaceutico_d2 ON Farmaceutico IS 'Validación: Número interior válido.';
COMMENT ON CONSTRAINT Farmaceutico_d3 ON Farmaceutico IS 'Validación: Número exterior positivo.';


-- Tabla 6
CREATE TABLE Cajero (
    RFC VARCHAR(13),
    Nombre VARCHAR(50),
    Paterno VARCHAR(50),
    Materno VARCHAR(50),
    Calle VARCHAR(50),
    NumeroExterior INTEGER,
    NumeroInterior INTEGER,
    Colonia VARCHAR(50),
    Estado VARCHAR(30),
    Dia VARCHAR(15),
    Entrada TIME,
    Salida TIME,
    Salario NUMERIC(10, 2),
    IdSucursal INTEGER
);

-- PK
ALTER TABLE Cajero ADD CONSTRAINT Cajero_pk
PRIMARY KEY (RFC);

-- FK
ALTER TABLE Cajero ADD CONSTRAINT Cajero_fk
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE Cajero
ALTER COLUMN RFC SET NOT NULL,
ALTER COLUMN Nombre SET NOT NULL,
ALTER COLUMN Paterno SET NOT NULL,
ALTER COLUMN Materno SET NOT NULL,
ALTER COLUMN Calle SET NOT NULL,
ALTER COLUMN NumeroExterior SET NOT NULL,
ALTER COLUMN Colonia SET NOT NULL,
ALTER COLUMN Estado SET NOT NULL,
ALTER COLUMN Dia SET NOT NULL,
ALTER COLUMN Entrada SET NOT NULL,
ALTER COLUMN Salida SET NOT NULL,
ALTER COLUMN Salario SET NOT NULL,
ADD CONSTRAINT Cajero_d1 CHECK (Salario > 0),
ALTER COLUMN IdSucursal SET NOT NULL;

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se agrega restricción a NumeroInterior CHECK es NULL o mayor a cero
ALTER TABLE Cajero
ADD CONSTRAINT Cajero_d2 CHECK (NumeroInterior IS NULL OR NumeroInterior > 0),
-- Se agrega restricción a NumeroExterior CHECK es mayor a cero
ADD CONSTRAINT Cajero_d3 CHECK (NumeroExterior > 0);

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Cajero IS 'Tabla que registra al personal encargado de cobros y facturación.';
COMMENT ON CONSTRAINT Cajero_pk ON Cajero IS 'Llave primaria: RFC del cajero.';
COMMENT ON CONSTRAINT Cajero_fk ON Cajero IS 'Llave foránea: Sucursal de asignación.';
COMMENT ON CONSTRAINT Cajero_d1 ON Cajero IS 'Validación: El salario debe ser mayor a cero.';
COMMENT ON CONSTRAINT Cajero_d2 ON Cajero IS 'Validación: Número interior válido.';
COMMENT ON CONSTRAINT Cajero_d3 ON Cajero IS 'Validación: Número exterior estrictamente positivo.';

-- Tabla 7
CREATE TABLE Aseador (
    RFC VARCHAR(13),
    Nombre VARCHAR(50),
    Paterno VARCHAR(50),
    Materno VARCHAR(50),
    Calle VARCHAR(50),
    NumeroExterior INTEGER,
    NumeroInterior INTEGER,
    Colonia VARCHAR(50),
    Estado VARCHAR(30),
    Dia VARCHAR(15),
    Entrada TIME,
    Salida TIME,
    Salario NUMERIC(10, 2),
    IdSucursal INTEGER
);

-- PK
ALTER TABLE Aseador ADD CONSTRAINT Aseador_pk
PRIMARY KEY (RFC);

-- FK
ALTER TABLE Aseador ADD CONSTRAINT Aseador_fk
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE Aseador
ALTER COLUMN RFC SET NOT NULL,
ALTER COLUMN Nombre SET NOT NULL,
ALTER COLUMN Paterno SET NOT NULL,
ALTER COLUMN Materno SET NOT NULL,
ALTER COLUMN Calle SET NOT NULL,
ALTER COLUMN NumeroExterior SET NOT NULL,
ALTER COLUMN Colonia SET NOT NULL,
ALTER COLUMN Estado SET NOT NULL,
ALTER COLUMN Dia SET NOT NULL,
ALTER COLUMN Entrada SET NOT NULL,
ALTER COLUMN Salida SET NOT NULL,
ALTER COLUMN Salario SET NOT NULL,
ADD CONSTRAINT Aseador_d1 CHECK (Salario > 0),
ALTER COLUMN IdSucursal SET NOT NULL;

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se agrega restricción a NumeroInterior CHECK es NULL o mayor a cero
ALTER TABLE Aseador
ADD CONSTRAINT Aseador_d2 CHECK (NumeroInterior IS NULL OR NumeroInterior > 0),
-- Se agrega restricción a NumeroExterior CHECK es mayor a cero
ADD CONSTRAINT Aseador_d3 CHECK (NumeroExterior > 0);

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Aseador IS 'Tabla que registra al personal encargado de la limpieza.';
COMMENT ON CONSTRAINT Aseador_pk ON Aseador IS 'Llave primaria: RFC del aseador.';
COMMENT ON CONSTRAINT Aseador_fk ON Aseador IS 'Llave foránea: Sucursal donde labora.';
COMMENT ON CONSTRAINT Aseador_d1 ON Aseador IS 'Validación: El salario debe ser positivo.';
COMMENT ON CONSTRAINT Aseador_d2 ON Aseador IS 'Validación: Número interior positivo o nulo.';
COMMENT ON CONSTRAINT Aseador_d3 ON Aseador IS 'Validación: Número exterior estrictamente positivo.';

-- Tabla 8
CREATE TABLE Cuidador (
    RFC VARCHAR(13),
    Nombre VARCHAR(50),
    Paterno VARCHAR(50),
    Materno VARCHAR(50),
    Calle VARCHAR(50),
    NumeroExterior INTEGER,
    NumeroInterior INTEGER,
    Colonia VARCHAR(50),
    Estado VARCHAR(30),
    Dia VARCHAR(15),
    Entrada TIME,
    Salida TIME,
    Salario NUMERIC(10, 2),
    IdSucursal INTEGER
);

-- PK
ALTER TABLE Cuidador ADD CONSTRAINT Cuidador_pk
PRIMARY KEY (RFC);

-- FK
ALTER TABLE Cuidador ADD CONSTRAINT Cuidador_fk
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE Cuidador
ALTER COLUMN RFC SET NOT NULL,
ALTER COLUMN Nombre SET NOT NULL,
ALTER COLUMN Paterno SET NOT NULL,
ALTER COLUMN Materno SET NOT NULL,
ALTER COLUMN Calle SET NOT NULL,
ALTER COLUMN NumeroExterior SET NOT NULL,
ALTER COLUMN Colonia SET NOT NULL,
ALTER COLUMN Estado SET NOT NULL,
ALTER COLUMN Dia SET NOT NULL,
ALTER COLUMN Entrada SET NOT NULL,
ALTER COLUMN Salida SET NOT NULL,
ALTER COLUMN Salario SET NOT NULL,
ADD CONSTRAINT Cuidador_d1 CHECK (Salario > 0),
ALTER COLUMN IdSucursal SET NOT NULL;

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se agrega restricción a NumeroInterior CHECK es NULL o mayor a cero
ALTER TABLE Cuidador
ADD CONSTRAINT Cuidador_d2 CHECK (NumeroInterior IS NULL OR NumeroInterior > 0),
-- Se agrega restricción a NumeroExterior CHECK es mayor a cero
ADD CONSTRAINT Cuidador_d3 CHECK (NumeroExterior > 0);

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Cuidador IS 'Tabla que registra al personal de asistencia o cuidadores.';
COMMENT ON CONSTRAINT Cuidador_pk ON Cuidador IS 'Llave primaria: RFC del cuidador.';
COMMENT ON CONSTRAINT Cuidador_fk ON Cuidador IS 'Llave foránea: Sucursal de adscripción.';
COMMENT ON CONSTRAINT Cuidador_d1 ON Cuidador IS 'Validación: El salario debe ser estrictamente positivo.';
COMMENT ON CONSTRAINT Cuidador_d2 ON Cuidador IS 'Validación: Número interior positivo o nulo.';
COMMENT ON CONSTRAINT Cuidador_d3 ON Cuidador IS 'Validación: Número exterior estrictamente positivo.';

-- Tabla 9
CREATE TABLE Telefonos_Medico (
    RFC VARCHAR(13),
    Telefono VARCHAR(15)
);

-- PK
ALTER TABLE Telefonos_Medico ADD CONSTRAINT Telefonos_Medico_pk
PRIMARY KEY (RFC, Telefono);

-- FK
ALTER TABLE Telefonos_Medico ADD CONSTRAINT Telefonos_Medico_fk
FOREIGN KEY (RFC) REFERENCES Medico(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Telefonos_Medico
ADD CONSTRAINT Telefonos_Medico_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Telefonos_Medico IS 'Atributo multivaluado que almacena los teléfonos de los médicos.';
COMMENT ON CONSTRAINT Telefonos_Medico_pk ON Telefonos_Medico IS 'Llave primaria compuesta (RFC y teléfono).';
COMMENT ON CONSTRAINT Telefonos_Medico_fk ON Telefonos_Medico IS 'Llave foránea: Vinculación con la tabla Medico.';
COMMENT ON CONSTRAINT Telefonos_Medico_v ON Telefonos_Medico IS 'Validación: Formato de número telefónico (10 dígitos, opcionalmente con código de país).';


-- Tabla 10
CREATE TABLE Correos_Medico (
    RFC VARCHAR(13),
    Correo VARCHAR(50)
);

-- PK
ALTER TABLE Correos_Medico ADD CONSTRAINT Correos_Medico_pk
PRIMARY KEY (RFC, Correo);

-- FK
ALTER TABLE Correos_Medico ADD CONSTRAINT Correos_Medico_fk
FOREIGN KEY (RFC) REFERENCES Medico(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Correos_Medico
ADD CONSTRAINT Correos_Medico_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Correos_Medico IS 'Atributo multivaluado que almacena los correos electrónicos de los médicos.';
COMMENT ON CONSTRAINT Correos_Medico_pk ON Correos_Medico IS 'Llave primaria compuesta (RFC y correo).';
COMMENT ON CONSTRAINT Correos_Medico_fk ON Correos_Medico IS 'Llave foránea: Vinculación con la tabla Medico.';
COMMENT ON CONSTRAINT Correos_Medico_v ON Correos_Medico IS 'Validación: Formato de correo electrónico.';


-- Tabla 11
CREATE TABLE Especialidades (
    RFC VARCHAR(13),
    Especialidad VARCHAR(50)
);

-- PK
ALTER TABLE Especialidades ADD CONSTRAINT Especialidades_pk
PRIMARY KEY (RFC, Especialidad);

-- FK
ALTER TABLE Especialidades ADD CONSTRAINT Especialidades_fk
FOREIGN KEY (RFC) REFERENCES Medico(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Especialidades IS 'Atributo multivaluado que registra las especialidades médicas.';
COMMENT ON CONSTRAINT Especialidades_pk ON Especialidades IS 'Llave primaria compuesta (RFC y especialidad).';
COMMENT ON CONSTRAINT Especialidades_fk ON Especialidades IS 'Llave foránea: Vinculación con la tabla Medico.';


-- Tabla 12
CREATE TABLE Telefonos_Enfermero (
    RFC VARCHAR(13),
    Telefono VARCHAR(15)
);

-- PK
ALTER TABLE Telefonos_Enfermero ADD CONSTRAINT Telefonos_Enfermero_pk
PRIMARY KEY (RFC, Telefono);

-- FK
ALTER TABLE Telefonos_Enfermero ADD CONSTRAINT Telefonos_Enfermero_fk
FOREIGN KEY (RFC) REFERENCES Enfermero(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Telefonos_Enfermero
ADD CONSTRAINT Telefonos_Enfermero_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Telefonos_Enfermero IS 'Atributo multivaluado: Teléfonos de contacto de enfermeros.';
COMMENT ON CONSTRAINT Telefonos_Enfermero_pk ON Telefonos_Enfermero IS 'Llave primaria compuesta (RFC y Telefono).';
COMMENT ON CONSTRAINT Telefonos_Enfermero_fk ON Telefonos_Enfermero Is 'Llave foránea: Vinculación con la tabla Enfermero.';
COMMENT ON CONSTRAINT Telefonos_Enfermero_v ON Telefonos_Enfermero IS 'Validación: Formato de número telefónico (10 dígitos, opcionalmente con código de país).';

-- Tabla 13
CREATE TABLE Correos_Enfermero (
    RFC VARCHAR(13),
    Correo VARCHAR(50)
);

-- PK
ALTER TABLE Correos_Enfermero ADD CONSTRAINT Correos_Enfermero_pk
PRIMARY KEY (RFC, Correo);

-- FK
ALTER TABLE Correos_Enfermero ADD CONSTRAINT Correos_Enfermero_fk
FOREIGN KEY (RFC) REFERENCES Enfermero(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Correos_Enfermero
ADD CONSTRAINT Correos_Enfermero_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Correos_Enfermero IS 'Atributo multivaluado: Correos electrónicos de enfermeros.';
COMMENT ON CONSTRAINT Correos_Enfermero_pk ON Correos_Enfermero IS 'Lllave primaria compuesta (RFC y Correo).';
COMMENT ON CONSTRAINT Correos_Enfermero_fk ON Correos_Enfermero IS 'Llave foránea: Vinculación con la tabla Enfermero.';
COMMENT ON CONSTRAINT Correos_Enfermero_v ON Correos_Enfermero IS 'Validación: Formato de correo electrónico.';


-- Tabla 14
CREATE TABLE Telefonos_Farmaceutico (
    RFC VARCHAR(13),
    Telefono VARCHAR(15)
);

-- PK
ALTER TABLE Telefonos_Farmaceutico ADD CONSTRAINT Telefonos_Farmaceutico_pk
PRIMARY KEY (RFC, Telefono);

-- FK
ALTER TABLE Telefonos_Farmaceutico ADD CONSTRAINT Telefonos_Farmaceutico_fk
FOREIGN KEY (RFC) REFERENCES Farmaceutico(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Telefonos_Farmaceutico
ADD CONSTRAINT Telefonos_Farmaceutico_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Telefonos_Farmaceutico IS 'Atributo multivaluado: Teléfonos de farmacéuticos.';
COMMENT ON CONSTRAINT Telefonos_Farmaceutico_pk ON Telefonos_Farmaceutico IS 'Llave primaria compuesta (RFC y Telefono).';
COMMENT ON CONSTRAINT Telefonos_Farmaceutico_fk ON Telefonos_Farmaceutico IS 'Llave foránea: Vinculación con la tabla Farmaceutico.';
COMMENT ON CONSTRAINT Telefonos_Farmaceutico_v ON Telefonos_Farmaceutico IS 'Validación: Formato de número telefónico (10 dígitos, opcionalmente con código de país).';

-- Tabla 15
CREATE TABLE Correos_Farmaceutico (
    RFC VARCHAR(13),
    Correo VARCHAR(50)
);

-- PK
ALTER TABLE Correos_Farmaceutico ADD CONSTRAINT Correos_Farmaceutico_pk
PRIMARY KEY (RFC, Correo);

-- FK
ALTER TABLE Correos_Farmaceutico ADD CONSTRAINT Correos_Farmaceutico_fk
FOREIGN KEY (RFC) REFERENCES Farmaceutico(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Correos_Farmaceutico
ADD CONSTRAINT Correos_Farmaceutico_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Correos_Farmaceutico IS 'Atributo multivaluado: Correos de farmacéuticos.';
COMMENT ON CONSTRAINT Correos_Farmaceutico_pk ON Correos_Farmaceutico IS 'Llave primaria compuesta (RFC y Correo).';
COMMENT ON CONSTRAINT Correos_Farmaceutico_fk ON Correos_Farmaceutico IS 'Llave foránea: Vinculación con la tabla Farmaceutico.';
COMMENT ON CONSTRAINT Correos_Farmaceutico_v ON Correos_Farmaceutico IS 'Validación: Formato de correo electrónico.';

-- Tabla 16
CREATE TABLE Especialidades_Preparacion (
    RFC VARCHAR(13),
    EspecialidadPreparacion VARCHAR(50)
);

-- PK
ALTER TABLE Especialidades_Preparacion ADD CONSTRAINT Especialidades_Preparacion_pk
PRIMARY KEY (RFC, EspecialidadPreparacion);

-- FK
ALTER TABLE Especialidades_Preparacion ADD CONSTRAINT Especialidades_Preparacion_fk
FOREIGN KEY (RFC) REFERENCES Farmaceutico(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Especialidades_Preparacion IS 'Atributo multivaluado: Especialidades en fórmulas magistrales.';
COMMENT ON CONSTRAINT Especialidades_Preparacion_pk ON Especialidades_Preparacion IS 'Llave primaria compuesta (RFC y EspecialidadPreparacion).';
COMMENT ON CONSTRAINT Especialidades_Preparacion_fk ON Especialidades_Preparacion IS 'Llave foránea: Vinculación con la tabla Farmaceutico.';


-- Tabla 17
CREATE TABLE Telefonos_Cajero (
    RFC VARCHAR(13),
    Telefono VARCHAR(15)
);

-- PK
ALTER TABLE Telefonos_Cajero ADD CONSTRAINT Telefonos_Cajero_pk
PRIMARY KEY (RFC, Telefono);

-- FK
ALTER TABLE Telefonos_Cajero ADD CONSTRAINT Telefonos_Cajero_fk
FOREIGN KEY (RFC) REFERENCES Cajero(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Telefonos_Cajero
ADD CONSTRAINT Telefonos_Cajero_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Telefonos_Cajero IS 'Atributo multivaluado: Teléfonos de cajeros.';
COMMENT ON CONSTRAINT Telefonos_Cajero_pk ON Telefonos_Cajero IS 'Llave primaria compuesta (RFC y Telefono).';
COMMENT ON CONSTRAINT Telefonos_Cajero_fk ON Telefonos_Cajero IS 'Llave foránea: Vinculación con la tabla Cajero.';
COMMENT ON CONSTRAINT Telefonos_Cajero_v ON Telefonos_Cajero IS 'Validación: Formato de número telefónico (10 dígitos, opcionalmente con código de país)..';

-- Tabla 18
CREATE TABLE Correos_Cajero (
    RFC VARCHAR(13),
    Correo VARCHAR(50)
);

-- PK
ALTER TABLE Correos_Cajero ADD CONSTRAINT Correos_Cajero_pk
PRIMARY KEY (RFC, Correo);

-- FK
ALTER TABLE Correos_Cajero ADD CONSTRAINT Correos_Cajero_fk
FOREIGN KEY (RFC) REFERENCES Cajero(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Correos_Cajero
ADD CONSTRAINT Correos_Cajero_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Correos_Cajero IS 'Atributo multivaluado: Correos de cajeros.';
COMMENT ON CONSTRAINT Correos_Cajero_pk ON Correos_Cajero IS 'Llave primaria compuesta (RFC y Correo).';
COMMENT ON CONSTRAINT Correos_Cajero_fk ON Correos_Cajero IS 'Llave foránea: Vinculación con la tabla Cajero.';
COMMENT ON CONSTRAINT Correos_Cajero_v ON Correos_Cajero IS 'Validación: Formato de correo electrónico.';

-- Tabla 19
CREATE TABLE Telefonos_Aseador (
    RFC VARCHAR(13),
    Telefono VARCHAR(15)
);

-- PK
ALTER TABLE Telefonos_Aseador ADD CONSTRAINT Telefonos_Aseador_pk
PRIMARY KEY (RFC, Telefono);

-- FK
ALTER TABLE Telefonos_Aseador ADD CONSTRAINT Telefonos_Aseador_fk
FOREIGN KEY (RFC) REFERENCES Aseador(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Telefonos_Aseador
ADD CONSTRAINT Telefonos_Aseador_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Telefonos_Aseador IS 'Atributo multivaluado: Teléfonos de aseadores.';
COMMENT ON CONSTRAINT Telefonos_Aseador_pk ON Telefonos_Aseador IS 'Llave primaria compuesta (RFC y Telefono).';
COMMENT ON CONSTRAINT Telefonos_Aseador_fk ON Telefonos_Aseador IS 'Llave foránea: Vinculación con la tabla Aseador.';
COMMENT ON CONSTRAINT Telefonos_Aseador_v ON Telefonos_Aseador IS 'Validación: Formato de número telefónico (10 dígitos, opcionalmente con código de país).';

-- Tabla 20
CREATE TABLE Correos_Aseador (
    RFC VARCHAR(13),
    Correo VARCHAR(50)
);

-- PK
ALTER TABLE Correos_Aseador ADD CONSTRAINT Correos_Aseador_pk
PRIMARY KEY (RFC, Correo);

-- FK
ALTER TABLE Correos_Aseador ADD CONSTRAINT Correos_Aseador_fk
FOREIGN KEY (RFC) REFERENCES Aseador(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Correos_Aseador
ADD CONSTRAINT Correos_Aseador_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Correos_Aseador IS 'Atributo multivaluado: Correos de aseadores.';
COMMENT ON CONSTRAINT Correos_Aseador_pk ON Correos_Aseador IS 'Llave primaria compuesta (RFC y Correo).';
COMMENT ON CONSTRAINT Correos_Aseador_fk ON Correos_Aseador IS 'Llave foránea: Vinculación con la tabla Aseador.';
COMMENT ON CONSTRAINT Correos_Aseador_v ON Correos_Aseador IS 'Validación: Formato de correo electrónico.';

-- Tabla 21
CREATE TABLE Telefonos_Cuidador (
    RFC VARCHAR(13),
    Telefono VARCHAR(15)
);

-- PK
ALTER TABLE Telefonos_Cuidador ADD CONSTRAINT Telefonos_Cuidador_pk
PRIMARY KEY (RFC, Telefono);

-- FK
ALTER TABLE Telefonos_Cuidador ADD CONSTRAINT Telefonos_Cuidador_fk
FOREIGN KEY (RFC) REFERENCES Cuidador(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Telefonos_Cuidador
ADD CONSTRAINT Telefonos_Cuidador_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Telefonos_Cuidador IS 'Atributo multivaluado: Teléfonos de cuidadores.';
COMMENT ON CONSTRAINT Telefonos_Cuidador_pk ON Telefonos_Cuidador IS 'Llave primaria compuesta (RFC y Telefono).';
COMMENT ON CONSTRAINT Telefonos_Cuidador_fk ON Telefonos_Cuidador IS 'Llave foránea: Vinculación con la tabla Cuidador.';
COMMENT ON CONSTRAINT Telefonos_Cuidador_v ON Telefonos_Cuidador IS 'Validación: Formato de número telefónico (10 dígitos, opcionalmente con código de país).';

-- Tabla 22
CREATE TABLE Correos_Cuidador (
    RFC VARCHAR(13),
    Correo VARCHAR(50)
);

-- PK
ALTER TABLE Correos_Cuidador ADD CONSTRAINT Correos_Cuidador_pk
PRIMARY KEY (RFC, Correo);

-- FK
ALTER TABLE Correos_Cuidador ADD CONSTRAINT Correos_Cuidador_fk
FOREIGN KEY (RFC) REFERENCES Cuidador(RFC)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Correos_Cuidador
ADD CONSTRAINT Correos_Cuidador_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Correos_Cuidador IS 'Atributo multivaluado: Correos de cuidadores.';
COMMENT ON CONSTRAINT Correos_Cuidador_pk ON Correos_Cuidador IS 'Llave primaria compuesta (RFC y Correo).';
COMMENT ON CONSTRAINT Correos_Cuidador_fk ON Correos_Cuidador IS 'Llave foránea: Vinculación con la tabla Cuidador.';
COMMENT ON CONSTRAINT Correos_Cuidador_v ON Correos_Cuidador IS 'Validación: Formato de correo electrónico.';


-- Tabla 23
CREATE TABLE Horarios_Sucursal (
    IdSucursal INTEGER,
    Dia VARCHAR(15),
    Apertura TIME,
    Cierre TIME
);

-- PK
ALTER TABLE Horarios_Sucursal ADD CONSTRAINT Horarios_Sucursal_pk
PRIMARY KEY (IdSucursal, Dia);

-- FK
ALTER TABLE Horarios_Sucursal ADD CONSTRAINT Horarios_Sucursal_fk
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Horarios_Sucursal
ALTER COLUMN Apertura SET NOT NULL,
ALTER COLUMN Cierre SET NOT NULL;

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Horarios_Sucursal IS 'Tabla que define los horarios de apertura y cierre de las sucursales.';
COMMENT ON CONSTRAINT Horarios_Sucursal_pk ON Horarios_Sucursal IS 'Llave primaria compuesta (IdSucursal y día).';
COMMENT ON CONSTRAINT Horarios_Sucursal_fk ON Horarios_Sucursal IS 'Llave foránea: Vinculación con la sucursal.';


-- Tabla 24
CREATE TABLE Horarios_Clinica (
    IdClinica INTEGER,
    Dia VARCHAR(15),
    Apertura TIME,
    Cierre TIME
);

-- PK
ALTER TABLE Horarios_Clinica ADD CONSTRAINT Horarios_Clinica_pk
PRIMARY KEY (IdClinica, Dia);

-- FK
ALTER TABLE Horarios_Clinica ADD CONSTRAINT Horarios_Clinica_fk
FOREIGN KEY (IdClinica) REFERENCES Clinica(IdClinica)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Horarios_Clinica
ALTER COLUMN Apertura SET NOT NULL,
ALTER COLUMN Cierre SET NOT NULL;

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
COMMENT ON TABLE Horarios_Clinica IS 'Tabla que define los horarios de servicio de las clínicas.';
COMMENT ON CONSTRAINT Horarios_Clinica_pk ON Horarios_Clinica IS 'Llave primaria compuesta (IdClinica y día).';
COMMENT ON CONSTRAINT Horarios_Clinica_fk ON Horarios_Clinica IS 'Llave foránea: Vinculación con la clínica.';


-- =================================================================
--                             MÓDULO 2 
-- =================================================================

-- Tabla 1
CREATE TABLE MedComercial (
    IdMedicamento SERIAL,
    NombreComercial VARCHAR(50),
    FormaFarmaceutica VARCHAR(20),
    Concentracion VARCHAR(20),
    Presentacion VARCHAR(50),
    ViaAdministracion VARCHAR(20),
    Clasificacion VARCHAR (20),
    TipoControl VARCHAR (20),
    Descripcion TEXT,
    NombreGenerico VARCHAR(50),
    LabFabricante VARCHAR(50)
);

-- PK
ALTER TABLE MedComercial ADD CONSTRAINT MedComercial_pk
PRIMARY KEY (IdMedicamento);

-- Restricciones
ALTER TABLE MedComercial
ALTER COLUMN NombreComercial SET NOT NULL,
ALTER COLUMN FormaFarmaceutica SET NOT NULL,
ALTER COLUMN Concentracion SET NOT NULL,
ALTER COLUMN Presentacion SET NOT NULL,
ALTER COLUMN ViaAdministracion SET NOT NULL,
ALTER COLUMN Clasificacion SET NOT NULL,
ALTER COLUMN TipoControl SET NOT NULL,
ALTER COLUMN Descripcion SET NOT NULL,
ALTER COLUMN NombreGenerico SET NOT NULL,
ALTER COLUMN LabFabricante SET NOT NULL;


-- Tabla 2
CREATE TABLE MedPreparado (
    IdMedicamento SERIAL,
    NombreComercial VARCHAR(50),
    FormaFarmaceutica VARCHAR(20),
    Concentracion VARCHAR(20),
    Presentacion VARCHAR(50),
    ViaAdministracion VARCHAR(20),
    Clasificacion VARCHAR (20),
    TipoControl VARCHAR (20),
    Descripcion TEXT,
    Categoria VARCHAR(50)
);

-- PK
ALTER TABLE MedPreparado ADD CONSTRAINT MedPreparado_pk
PRIMARY KEY (IdMedicamento);

-- Restricciones
ALTER TABLE MedPreparado
ALTER COLUMN NombreComercial SET NOT NULL,
ALTER COLUMN FormaFarmaceutica SET NOT NULL,
ALTER COLUMN Concentracion SET NOT NULL,
ALTER COLUMN Presentacion SET NOT NULL,
ALTER COLUMN ViaAdministracion SET NOT NULL,
ALTER COLUMN Clasificacion SET NOT NULL,
ALTER COLUMN TipoControl SET NOT NULL,
ALTER COLUMN Descripcion SET NOT NULL,


ALTER COLUMN Categoria SET NOT NULL;


-- Tabla 3
CREATE TABLE Insumo (
    IdInsumo SERIAL,
    NombreCientifico VARCHAR(50),
    NombreComercial VARCHAR(50),
    Tipo VARCHAR(20),
    FormaFisica VARCHAR(20),
    Potencia VARCHAR(20),
    Grado VARCHAR(20),
    Riesgo VARCHAR(20),
    EsEsteril BOOLEAN,
    Temperatura VARCHAR(20),
    Sensibilidad VARCHAR(20),
    Observaciones TEXT
);

-- PK
ALTER TABLE Insumo ADD CONSTRAINT Insumo_pk
PRIMARY KEY (IdInsumo);

-- Restricciones
ALTER TABLE Insumo
ALTER COLUMN NombreCientifico SET NOT NULL,
ALTER COLUMN NombreComercial SET NOT NULL,
ALTER COLUMN Tipo SET NOT NULL,
ALTER COLUMN FormaFisica SET NOT NULL,
ALTER COLUMN Potencia SET NOT NULL,
ALTER COLUMN Grado SET NOT NULL,
ALTER COLUMN Riesgo SET NOT NULL,
ALTER COLUMN EsEsteril SET NOT NULL,
ALTER COLUMN Temperatura SET NOT NULL,
ALTER COLUMN Sensibilidad SET NOT NULL,
ALTER COLUMN Observaciones SET NOT NULL;


-- Tabla 4
CREATE TABLE Elaborar (
    RFC VARCHAR(13),
    IdMedicamento INTEGER,
    FechaElaboracion TIMESTAMP,
    CantidadElaborada INTEGER
);

-- PK
ALTER TABLE Elaborar ADD CONSTRAINT Elaborar_pk
PRIMARY KEY (RFC, IdMedicamento);

-- FK
ALTER TABLE Elaborar ADD CONSTRAINT Elaborar_fk1
FOREIGN KEY (RFC) REFERENCES Farmaceutico(RFC)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE Elaborar ADD CONSTRAINT Elaborar_fk2
FOREIGN KEY (IdMedicamento) REFERENCES MedPreparado(IdMedicamento)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE Elaborar
ALTER COLUMN FechaElaboracion SET NOT NULL,
ALTER COLUMN CantidadElaborada SET NOT NULL,
ADD CONSTRAINT Elaborar_d1 CHECK (CantidadElaborada > 0);

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se elimina la PK Elaborar_pk
ALTER TABLE Elaborar 
DROP CONSTRAINT Elaborar_pk;


-- Tabla 5
CREATE TABLE Contener (
    IdMedicamento INTEGER,
    IdInsumo INTEGER,
    CantidadRequerida NUMERIC(10, 4)
);

-- PK
ALTER TABLE Contener ADD CONSTRAINT Contener_pk
PRIMARY KEY (IdMedicamento, IdInsumo);

-- FK
ALTER TABLE Contener ADD CONSTRAINT Contener_fk1
FOREIGN KEY (IdMedicamento) REFERENCES MedPreparado(IdMedicamento)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE Contener ADD CONSTRAINT Contener_fk2
FOREIGN KEY (IdInsumo) REFERENCES Insumo(IdInsumo)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE Contener
ALTER COLUMN CantidadRequerida SET NOT NULL,
ADD CONSTRAINT Contener_d1 CHECK (CantidadRequerida > 0);

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se elimina la PK Conetener_pk
ALTER TABLE Contener 
DROP CONSTRAINT Contener_pk;


-- =================================================================
--                             MÓDULO 3 
-- =================================================================

-- Tabla 1
CREATE TABLE Proveedor (
    IdProveedor SERIAL,
    RazonSocial VARCHAR(30),
    Calle VARCHAR(50), 
    NumeroExterior INTEGER, 
    NumeroInterior INTEGER,
    Colonia VARCHAR(50),
    Estado VARCHAR(30)
);

-- PK
ALTER TABLE Proveedor ADD CONSTRAINT Proveedor_pk
PRIMARY KEY (IdProveedor);

-- Restricciones
ALTER TABLE Proveedor
ALTER COLUMN RazonSocial SET NOT NULL,
ALTER COLUMN Calle SET NOT NULL,
ALTER COLUMN NumeroExterior SET NOT NULL,
ADD CONSTRAINT Proveedor_d1 CHECK (NumeroExterior > 0),
ALTER COLUMN Colonia SET NOT NULL,
ALTER COLUMN Estado SET NOT NULL;

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se agrega restricción a NumeroInterior CHECK es NULL o mayor a cero
ALTER TABLE Proveedor
ADD CONSTRAINT Proveedor_d2 CHECK (NumeroInterior IS NULL OR NumeroInterior > 0);


-- Tabla 2
CREATE TABLE Telefonos_Proveedor (
    IdProveedor INTEGER,
    Telefono VARCHAR(15)
);

-- PK
ALTER TABLE Telefonos_Proveedor ADD CONSTRAINT Telefonos_Proveedor_pk 
PRIMARY KEY (IdProveedor, Telefono);

-- FK
ALTER TABLE Telefonos_Proveedor ADD CONSTRAINT Telefonos_Proveedor_fk 
FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Telefonos_Proveedor
ADD CONSTRAINT Telefonos_Proveedor_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');


-- Tabla 3
CREATE TABLE EntregarMedComercial (
    IdProveedor INTEGER,
    IdSucursal INTEGER,
    IdMedicamento INTEGER,
    FechaRecepcion TIMESTAMP,
    FechaCaducidad DATE,
    CondicionesAlmacenamiento VARCHAR(100),
    CantidadRecibida INTEGER,
    PrecioPublico NUMERIC(10, 2),
    PrecioUnitario NUMERIC(10, 2)
);

-- PK
ALTER TABLE EntregarMedComercial ADD CONSTRAINT EntregarMedComercial_pk 
PRIMARY KEY (IdProveedor, IdSucursal, IdMedicamento);

-- FK
ALTER TABLE EntregarMedComercial ADD CONSTRAINT EntregarMedComercial_fk1 
FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE EntregarMedComercial ADD CONSTRAINT EntregarMedComercial_fk2 
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE EntregarMedComercial ADD CONSTRAINT EntregarMedComercial_fk3 
FOREIGN KEY (IdMedicamento) REFERENCES MedComercial(IdMedicamento)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE EntregarMedComercial
ALTER COLUMN FechaRecepcion SET NOT NULL,
ALTER COLUMN FechaCaducidad SET NOT NULL,
ALTER COLUMN CondicionesAlmacenamiento SET NOT NULL,
ALTER COLUMN CantidadRecibida SET NOT NULL,
ADD CONSTRAINT EntregarMedComercial_d1 CHECK (CantidadRecibida > 0),
ALTER COLUMN PrecioPublico SET NOT NULL,
ADD CONSTRAINT EntregarMedComercial_d2 CHECK (PrecioPublico >= 0),
ALTER COLUMN PrecioUnitario SET NOT NULL,
ADD CONSTRAINT EntregarMedComercial_d3 CHECK (PrecioUnitario >= 0);

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se elimina la PK EntregarMedComercial_pk
ALTER TABLE EntregarMedComercial 
DROP CONSTRAINT EntregarMedComercial_pk;


-- Tabla 4
CREATE TABLE EntregarInsumo (
    IdProveedor INTEGER,
    IdSucursal INTEGER,
    IdInsumo INTEGER,
    FechaRecepcion TIMESTAMP,
    FechaCaducidad DATE,
    CondicionesAlmacenamiento VARCHAR(100),
    CantidadRecibida INTEGER,
    PrecioPublico NUMERIC(10, 2),
    PrecioUnitario NUMERIC(10, 2)
);

-- PK
ALTER TABLE EntregarInsumo ADD CONSTRAINT EntregarInsumo_pk 
PRIMARY KEY (IdProveedor, IdSucursal, IdInsumo);

-- FK
ALTER TABLE EntregarInsumo ADD CONSTRAINT EntregarInsumo_fk1 
FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE EntregarInsumo ADD CONSTRAINT EntregarInsumo_fk2 
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE EntregarInsumo ADD CONSTRAINT EntregarInsumo_fk3 
FOREIGN KEY (IdInsumo) REFERENCES Insumo(IdInsumo)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE EntregarInsumo
ALTER COLUMN FechaRecepcion SET NOT NULL,
ALTER COLUMN FechaCaducidad SET NOT NULL,
ALTER COLUMN CondicionesAlmacenamiento SET NOT NULL,
ALTER COLUMN CantidadRecibida SET NOT NULL,
ADD CONSTRAINT EntregarInsumo_d1 CHECK (CantidadRecibida > 0),
ALTER COLUMN PrecioPublico SET NOT NULL,
ADD CONSTRAINT EntregarInsumo_d2 CHECK (PrecioPublico >= 0),
ALTER COLUMN PrecioUnitario SET NOT NULL,
ADD CONSTRAINT EntregarInsumo_d3 CHECK (PrecioUnitario >= 0);

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se elimina la PK EntregarInsumo_pk
ALTER TABLE EntregarInsumo 
DROP CONSTRAINT EntregarInsumo_pk;


-- =================================================================
--                             MÓDULO 5 
-- =================================================================

-- Tabla 1
CREATE TABLE Cliente(
    IdCliente SERIAL,
    Nombre VARCHAR(50),
    Paterno VARCHAR(50),
    Materno VARCHAR(50),
    FechaNacimiento DATE,
    Calle VARCHAR(50),
    NumeroExterior INTEGER,
    NumeroInterior INTEGER,
    Colonia VARCHAR(50),
    Estado VARCHAR(50),
    MetodoPago VARCHAR(20)
);

-- PK
ALTER TABLE Cliente ADD CONSTRAINT Cliente_pk
PRIMARY KEY (IdCliente);

-- Restricciones
ALTER TABLE Cliente
ALTER COLUMN Nombre SET NOT NULL,
ALTER COLUMN Paterno SET NOT NULL,
ALTER COLUMN FechaNacimiento SET NOT NULL,
ADD CONSTRAINT Cliente_d1 CHECK (FechaNacimiento <= CURRENT_DATE),
ALTER COLUMN Calle SET NOT NULL,
ALTER COLUMN NumeroExterior SET NOT NULL,
ADD CONSTRAINT Cliente_d2 CHECK (NumeroExterior > 0),
ALTER COLUMN Colonia SET NOT NULL,
ALTER COLUMN Estado SET NOT NULL,
ALTER COLUMN MetodoPago SET NOT NULL,
ADD CONSTRAINT Cliente_d3 CHECK (MetodoPago IN ('Tarjeta', 'Efectivo'));

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se agrega restricción a Materno NOT NULL
ALTER TABLE Cliente
ALTER COLUMN Materno SET NOT NULL,
-- Se agrega restricción a NumeroInterior CHECK es NULL o mayor a cero
ADD CONSTRAINT Cliente_d4 CHECK (NumeroInterior IS NULL OR NumeroInterior > 0);


-- Tabla 2
CREATE TABLE ClienteOnline(
    IdCliente INTEGER,
    NombreUsuario VARCHAR(20),
    Contraseña VARCHAR(255),
    NumeroTarjeta VARCHAR(16),
    FechaVencimiento VARCHAR(5)
);

-- PK
ALTER TABLE ClienteOnline ADD CONSTRAINT ClienteOnline_pk
PRIMARY KEY (IdCliente);

-- FK
ALTER TABLE ClienteOnline ADD CONSTRAINT ClienteOnline_fk
FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE ClienteOnline
ALTER COLUMN NombreUsuario SET NOT NULL,
ADD CONSTRAINT Clienteonline_u1 UNIQUE (NombreUsuario),
ALTER COLUMN Contraseña SET NOT NULL,
ALTER COLUMN NumeroTarjeta SET NOT NULL,
ALTER COLUMN FechaVencimiento SET NOT NULL;


-- Tabla 3
CREATE TABLE Ticket(
    FolioTicket SERIAL,
    FechaPago DATE,
    HoraPago TIME,
    TipoVenta VARCHAR(20),
    PrecioBruto NUMERIC(10,2),
    PrecioNeto NUMERIC(10,2),
    IdSucursal INTEGER,
    IdCliente INTEGER
);

-- PK
ALTER TABLE Ticket ADD CONSTRAINT Ticket_pk
PRIMARY KEY (FolioTicket);

-- FK
ALTER TABLE Ticket ADD CONSTRAINT Ticket_fk1
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE Ticket ADD CONSTRAINT Ticket_fk2
FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE Ticket
ALTER COLUMN FechaPago SET NOT NULL,
ALTER COLUMN HoraPago SET NOT NULL,
ALTER COLUMN TipoVenta SET NOT NULL,
ADD CONSTRAINT Ticket_d1 CHECK (TipoVenta IN ('Presencial', 'Web')),
ALTER COLUMN PrecioBruto SET NOT NULL,
ADD CONSTRAINT Ticket_d2 CHECK (PrecioBruto >= 0),
ALTER COLUMN PrecioNeto SET NOT NULL,
ADD CONSTRAINT Ticket_d3 CHECK (PrecioNeto >= 0),
ALTER COLUMN IdCliente SET NOT NULL,
ALTER COLUMN IdSucursal SET NOT NULL;

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se eliminan porque el precio bruto y el precio neto se deben calcular mediante consultas DQL
ALTER TABLE Ticket 
    DROP COLUMN PrecioBruto,
    DROP COLUMN PrecioNeto;


-- Tabla 4
CREATE TABLE Telefonos_Cliente (
    IdCliente INTEGER,
    Telefono VARCHAR(15)
);

-- PK
ALTER TABLE Telefonos_Cliente ADD CONSTRAINT Telefonos_Cliente_pk
PRIMARY KEY (IdCliente, Telefono);

-- FK
ALTER TABLE Telefonos_Cliente ADD CONSTRAINT Telefonos_Cliente_fk
FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Telefonos_Cliente
ADD CONSTRAINT Telefonos_Cliente_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');


-- Tabla 5
CREATE TABLE Correos_Cliente (
    IdCliente INTEGER,
    Correo VARCHAR(15)
);

-- PK
ALTER TABLE Correos_Cliente ADD CONSTRAINT Correos_Cliente_pk
PRIMARY KEY (IdCliente, Correo);

-- FK
ALTER TABLE Correos_Cliente ADD CONSTRAINT Correos_Cliente_fk
FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Correos_Cliente
ADD CONSTRAINT Correos_Cliente_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');


-- Tabla 6
CREATE TABLE TenerMedComercial(
    FolioTicket INTEGER,
    IdMedicamento INTEGER,
    CantidadComprada INTEGER,
    PrecioUnitario NUMERIC(10,2)
);

-- PK
ALTER TABLE TenerMedComercial ADD CONSTRAINT TenerMedComercial_pk
PRIMARY KEY (FolioTicket, IdMedicamento);

-- FK
ALTER TABLE TenerMedComercial ADD CONSTRAINT TenerMedComercial_fk1
FOREIGN KEY (FolioTicket) REFERENCES Ticket(FolioTicket)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE TenerMedComercial ADD CONSTRAINT TenerMedComercial_fk2
FOREIGN KEY (IdMedicamento) REFERENCES MedComercial(IdMedicamento)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE TenerMedComercial
ALTER COLUMN CantidadComprada SET NOT NULL,
ADD CONSTRAINT TenerMedComercial_d1 CHECK (CantidadComprada > 0),
ALTER COLUMN PrecioUnitario SET NOT NULL,
ADD CONSTRAINT TenerMedComercial_d2 CHECK (PrecioUnitario >= 0);

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se elimina la PK EntregarInsumo_pk
ALTER TABLE TenerMedComercial
DROP CONSTRAINT TenerMedComercial_pk;


-- Tabla 7
CREATE TABLE TenerMedPreparado(
    FolioTicket INTEGER,
    IdMedicamento INTEGER,
    CantidadComprada INTEGER,
    PrecioUnitario NUMERIC(10,2)
);

-- PK
ALTER TABLE TenerMedPreparado ADD CONSTRAINT TenerMedPreparado_pk
PRIMARY KEY (FolioTicket, IdMedicamento);

-- FK
ALTER TABLE TenerMedPreparado ADD CONSTRAINT TenerMedPreparado_fk1
FOREIGN KEY (FolioTicket) REFERENCES Ticket(FolioTicket)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE TenerMedPreparado ADD CONSTRAINT TenerMedPreparado_fk2
FOREIGN KEY (IdMedicamento) REFERENCES MedPreparado(IdMedicamento)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE TenerMedPreparado
ALTER COLUMN CantidadComprada SET NOT NULL,
ADD CONSTRAINT TenerMedPreparado_d1 CHECK (CantidadComprada > 0),
ALTER COLUMN PrecioUnitario SET NOT NULL,
ADD CONSTRAINT TenerMedPreparado_d2 CHECK (PrecioUnitario >= 0);

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se elimina la PK TenerMedPreparado_pk
ALTER TABLE TenerMedPreparado 
DROP CONSTRAINT TenerMedPreparado_pk;


-- =================================================================
--                             MÓDULO 4 
-- =================================================================

-- Tabla 1
CREATE TABLE Consulta(
    IdConsulta SERIAL,
    Fecha DATE,
    Hora TIME,
    Diagnostico TEXT,
    Precio NUMERIC(10,2),
    IdCliente INTEGER,
    RFCMedico VARCHAR(13),
    RFCEnfermero VARCHAR(13),
    FolioTicket INTEGER
);

-- PK
ALTER TABLE Consulta ADD CONSTRAINT Consulta_pk
PRIMARY KEY (IdConsulta);

-- FK
ALTER TABLE Consulta ADD CONSTRAINT Consulta_fk1
FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE Consulta ADD CONSTRAINT Consulta_fk2
FOREIGN KEY (RFCMedico) REFERENCES Medico(RFC)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE Consulta ADD CONSTRAINT Consulta_fk3
FOREIGN KEY (RFCEnfermero) REFERENCES Enfermero(RFC)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE Consulta ADD CONSTRAINT Consulta_fk4
FOREIGN KEY (FolioTicket) REFERENCES Ticket(FolioTicket)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE Consulta
ALTER COLUMN Fecha SET NOT NULL,
ALTER COLUMN Hora SET NOT NULL,
ALTER COLUMN RFCMedico SET NOT NULL,
ALTER COLUMN Precio SET NOT NULL,
ALTER COLUMN Diagnostico SET NOT NULL,
ADD CONSTRAINT Consulta_d1 CHECK (Precio >= 0),
ALTER COLUMN FolioTicket SET NOT NULL,
ADD CONSTRAINT Consulta_u2 UNIQUE (FolioTicket);


-- Tabla 2
CREATE TABLE Receta(
    IdConsulta INTEGER,
    NumeroReceta INTEGER,
    PesoPaciente NUMERIC(5,2),
    TallaPaciente NUMERIC(5,2),
    Consultorio INTEGER,
    Turno VARCHAR(50)
);

-- PK
ALTER TABLE Receta ADD CONSTRAINT Receta_pk
PRIMARY KEY (IdConsulta, NumeroReceta);

-- FK
ALTER TABLE Receta ADD CONSTRAINT Receta_fk
FOREIGN KEY (IdConsulta) REFERENCES Consulta(IdConsulta)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Receta
ALTER COLUMN PesoPaciente SET NOT NULL,
ADD CONSTRAINT Receta_d1 CHECK (PesoPaciente > 0),
ALTER COLUMN TallaPaciente SET NOT NULL,
ADD CONSTRAINT Receta_d2 CHECK (TallaPaciente > 0),
ALTER COLUMN Consultorio SET NOT NULL,
ADD CONSTRAINT Receta_d3 CHECK (Consultorio > 0),
ALTER COLUMN Turno SET NOT NULL,
ADD CONSTRAINT Receta_d4 CHECK (Turno IN ('Matutino', 'Vespertino'));


-- Tabla 3
CREATE TABLE Alergias_Reportadas(
    IdConsulta INTEGER,
    NumeroReceta INTEGER,
    AlergiasReportadas TEXT
);

-- PK
ALTER TABLE Alergias_Reportadas ADD CONSTRAINT Alergias_Reportadas_pk
PRIMARY KEY (IdConsulta, NumeroReceta, AlergiasReportadas);

-- FK
ALTER TABLE Alergias_Reportadas ADD CONSTRAINT Alergias_Reportadas_fk
FOREIGN KEY (IdConsulta, NumeroReceta) REFERENCES Receta(IdConsulta, NumeroReceta)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Restricciones
ALTER TABLE Alergias_Reportadas
ALTER COLUMN AlergiasReportadas SET DEFAULT 'Ninguna conocida';


-- Tabla 4
CREATE TABLE PreescribirMedComercial(
    IdConsulta INTEGER,
    NumeroReceta INTEGER,
    IdMedicamento INTEGER,
    DosisPrescrita VARCHAR(50),
    Frecuencia VARCHAR(50),
    ViaAdministracionIndicada VARCHAR(50),
    Duracion VARCHAR(50)
);

-- PK
ALTER TABLE PreescribirMedComercial ADD CONSTRAINT PreescribirMedComercial_pk
PRIMARY KEY (IdConsulta, NumeroReceta, IdMedicamento);

-- FK
ALTER TABLE PreescribirMedComercial ADD CONSTRAINT PreescribirMedComercial_fk1
FOREIGN KEY (IdConsulta, NumeroReceta) REFERENCES Receta(IdConsulta, NumeroReceta)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE PreescribirMedComercial ADD CONSTRAINT PreescribirMedComercial_fk2
FOREIGN KEY (IdMedicamento) REFERENCES MedComercial(IdMedicamento)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- Restricciones
ALTER TABLE PreescribirMedComercial
ALTER COLUMN DosisPrescrita SET NOT NULL,
ALTER COLUMN Frecuencia SET NOT NULL,
ALTER COLUMN Duracion SET NOT NULL;


--Tabla 5
CREATE TABLE PreescribirMedPreparado(
    IdConsulta INTEGER,
    NumeroReceta INTEGER,
    IdMedicamento INTEGER,
    DosisPrescrita VARCHAR(50),
    Frecuencia VARCHAR(50),
    ViaAdministracionIndicada VARCHAR(50),
    Duracion VARCHAR(50)
);

-- PK
ALTER TABLE PreescribirMedPreparado ADD CONSTRAINT PreescribirMedPreparado_pk
PRIMARY KEY (IdConsulta, NumeroReceta, IdMedicamento);

-- FK
ALTER TABLE PreescribirMedPreparado ADD CONSTRAINT PreescribirMedPreparado_fk1
FOREIGN KEY (IdConsulta, NumeroReceta) REFERENCES Receta(IdConsulta, NumeroReceta)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE PreescribirMedPreparado ADD CONSTRAINT PreescribirMedPreparado_fk2
FOREIGN KEY (IdMedicamento) REFERENCES MedComercial(IdMedicamento);

-- Restricciones
ALTER TABLE PreescribirMedPreparado
ALTER COLUMN DosisPrescrita SET NOT NULL,
ALTER COLUMN Frecuencia SET NOT NULL,
ALTER COLUMN Duracion SET NOT NULL;

-- =================================================================
--                      BLOQUE DE CORRECCIONES 
-- =================================================================
-- Se renombran para mantener congruencia estricta con el Modelo Relacional
ALTER TABLE PreescribirMedComercial RENAME TO PrescribirMedComercial;
ALTER TABLE PreescribirMedPreparado RENAME TO PrescribirMedPreparado;

-- Se agrega restricción NOT NULL para ViaAdministracionIndicada
ALTER TABLE PrescribirMedComercial
ALTER COLUMN ViaAdministracionIndicada SET NOT NULL;
ALTER TABLE PrescribirMedPreparado
ALTER COLUMN ViaAdministracionIndicada SET NOT NULL;

-- Se elimina la PK EntregarInsumo_pk
ALTER TABLE PrescribirMedComercial 
DROP CONSTRAINT PreescribirMedComercial_pk;
ALTER TABLE PrescribirMedPreparado 
DROP CONSTRAINT PreescribirMedPreparado_pk;

ALTER TABLE PrescribirMedPreparado 
-- Se elimina la FK PreescribirMedPreparado_fk2
DROP CONSTRAINT PreescribirMedPreparado_fk2,
-- Se añade la fk con la referencia corregida PreescribirMedPreparado_fk2
ADD CONSTRAINT PreescribirMedPreparado_fk2 FOREIGN KEY (IdMedicamento) REFERENCES MedPreparado(IdMedicamento)
ON UPDATE CASCADE ON DELETE RESTRICT;

