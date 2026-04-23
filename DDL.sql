DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;


-- MÓDULO 1

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
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal);

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
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal);

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
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal);

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
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal);

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
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal);

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
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal);

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
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal);

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
FOREIGN KEY (RFC) REFERENCES Medico(RFC);

-- Restricciones
ALTER TABLE Telefonos_Medico
ADD CONSTRAINT Telefonos_Medico_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');


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
FOREIGN KEY (RFC) REFERENCES Medico(RFC);

-- Restricciones
ALTER TABLE Correos_Medico
ADD CONSTRAINT Correos_Medico_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');


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
FOREIGN KEY (RFC) REFERENCES Medico(RFC);


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
FOREIGN KEY (RFC) REFERENCES Enfermero(RFC);

-- Restricciones
ALTER TABLE Telefonos_Enfermero
ADD CONSTRAINT Telefonos_Enfermero_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');


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
FOREIGN KEY (RFC) REFERENCES Enfermero(RFC);

-- Restricciones
ALTER TABLE Correos_Enfermero
ADD CONSTRAINT Correos_Enfermero_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');


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
FOREIGN KEY (RFC) REFERENCES Farmaceutico(RFC);

-- Restricciones
ALTER TABLE Telefonos_Farmaceutico
ADD CONSTRAINT Telefonos_Farmaceutico_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');


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
FOREIGN KEY (RFC) REFERENCES Farmaceutico(RFC);

-- Restricciones
ALTER TABLE Correos_Farmaceutico
ADD CONSTRAINT Correos_Farmaceutico_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');


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
FOREIGN KEY (RFC) REFERENCES Farmaceutico(RFC);


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
FOREIGN KEY (RFC) REFERENCES Cajero(RFC);

-- Restricciones
ALTER TABLE Telefonos_Cajero
ADD CONSTRAINT Telefonos_Cajero_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');


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
FOREIGN KEY (RFC) REFERENCES Cajero(RFC);

-- Restricciones
ALTER TABLE Correos_Cajero
ADD CONSTRAINT Correos_Cajero_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');


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
FOREIGN KEY (RFC) REFERENCES Aseador(RFC);

-- Restricciones
ALTER TABLE Telefonos_Aseador
ADD CONSTRAINT Telefonos_Aseador_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');


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
FOREIGN KEY (RFC) REFERENCES Aseador(RFC);

-- Restricciones
ALTER TABLE Correos_Aseador
ADD CONSTRAINT Correos_Aseador_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');


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
FOREIGN KEY (RFC) REFERENCES Cuidador(RFC);

-- Restricciones
ALTER TABLE Telefonos_Cuidador
ADD CONSTRAINT Telefonos_Cuidador_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');


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
FOREIGN KEY (RFC) REFERENCES Cuidador(RFC);

-- Restricciones
ALTER TABLE Correos_Cuidador
ADD CONSTRAINT Correos_Cuidador_v CHECK (Correo ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');


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
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal);

-- Restricciones
ALTER TABLE Horarios_Sucursal
ALTER COLUMN Apertura SET NOT NULL,
ALTER COLUMN Cierre SET NOT NULL;


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
FOREIGN KEY (IdClinica) REFERENCES Clinica(IdClinica);

-- Restricciones
ALTER TABLE Horarios_Clinica
ALTER COLUMN Apertura SET NOT NULL,
ALTER COLUMN Cierre SET NOT NULL;



-- MÓDULO 2

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
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE Elaborar ADD CONSTRAINT Elaborar_fk2
FOREIGN KEY (IdMedicamento) REFERENCES MedPreparado(IdMedicamento)
ON DELETE CASCADE ON UPDATE CASCADE;

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

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================
-- Comentario para la tabla
COMMENT ON TABLE Elaborar IS 'Tabla que registra los medicamentos preparados que son elaborados por los farmacéuticos.';

-- Comentarios para las columnas
COMMENT ON COLUMN Elaborar.RFC IS 'Identificador del farmacéutico que elaboró el medicamento.';
COMMENT ON COLUMN Elaborar.IdMedicamento IS 'Identificador del medicamento preparado.';
COMMENT ON COLUMN Elaborar.FechaElaboracion IS 'Fecha y hora en la que se elaboró el lote de medicamento.';
COMMENT ON COLUMN Elaborar.CantidadElaborada IS 'Cantidad de unidades creadas en esta elaboración.';

-- Comentarios para los constraints (restricciones)
COMMENT ON CONSTRAINT Elaborar_fk1 ON Elaborar IS 'Llave foránea hacia Farmaceutico. Restringe borrado y actualiza en cascada.';
COMMENT ON CONSTRAINT Elaborar_fk2 ON Elaborar IS 'Llave foránea hacia MedPreparado. Borra y actualiza en cascada.';
COMMENT ON CONSTRAINT Elaborar_d1 ON Elaborar IS 'Valida que la cantidad elaborada sea siempre un número positivo mayor a cero.';

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
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Contener ADD CONSTRAINT Contener_fk2
FOREIGN KEY (IdInsumo) REFERENCES Insumo(IdInsumo)
ON DELETE RESTRICT ON UPDATE CASCADE;

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
--                      BLOQUE DE COMENTARIOS 
-- =================================================================

-- Comentario para la tabla
COMMENT ON TABLE Contener IS 'Tabla que detalla los insumos que debe contener un medicamento preparado.';

-- Comentarios para las columnas
COMMENT ON COLUMN Contener.IdMedicamento IS 'Identificador del medicamento preparado.';
COMMENT ON COLUMN Contener.IdInsumo IS 'Identificador del insumo.';
COMMENT ON COLUMN Contener.CantidadRequerida IS 'Cantidad exacta del insumo que debe contener el medicamento.';

-- Comentarios para los constraints (restricciones)
COMMENT ON CONSTRAINT Contener_fk1 ON Contener IS 'Llave foránea hacia MedPreparado. Borra y actualiza en cascada.';
COMMENT ON CONSTRAINT Contener_fk2 ON Contener IS 'Llave foránea hacia Insumo. Restringe borrado si el insumo es contenido de algún medicamento y actualiza en cascada.';
COMMENT ON CONSTRAINT Contener_d1 ON Contener IS 'Valida que la cantidad requerida del insumo sea estrictamente mayor a cero.';


-- MÓDULO 3

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

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================

-- Comentario para la tabla
COMMENT ON TABLE Proveedor IS 'Tabla que almacena la información de los proveedores.';

-- Comentarios para las columnas
COMMENT ON COLUMN Proveedor.IdProveedor IS 'Identificador único y autoincrementable del proveedor.';
COMMENT ON COLUMN Proveedor.RazonSocial IS 'Nombre legal o razón social de la empresa proveedora.';
COMMENT ON COLUMN Proveedor.Calle IS 'Calle del domicilio del proveedor.';
COMMENT ON COLUMN Proveedor.NumeroExterior IS 'Número exterior del domicilio del proveedor.';
COMMENT ON COLUMN Proveedor.NumeroInterior IS 'Número interior del domicilio del proveedor (es opcional).';
COMMENT ON COLUMN Proveedor.Colonia IS 'Colonia del domicilio del proveedor.';
COMMENT ON COLUMN Proveedor.Estado IS 'Estado donde reside el proveedor.';

-- Comentarios para los constraints (restricciones y PK)
COMMENT ON CONSTRAINT Proveedor_pk ON Proveedor IS 'Llave primaria que identifica de forma única a cada proveedor.';
COMMENT ON CONSTRAINT Proveedor_d1 ON Proveedor IS 'Valida que el número exterior sea estrictamente mayor a cero.';
COMMENT ON CONSTRAINT Proveedor_d2 ON Proveedor IS 'Valida que el número interior, en caso de existir (no ser nulo), sea mayor a cero.';

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
ON DELETE CASCADE ON UPDATE CASCADE;

-- Restricciones
ALTER TABLE Telefonos_Proveedor
ADD CONSTRAINT Telefonos_Proveedor_v CHECK (Telefono ~ '^(\+[0-9]{1,3})?[0-9]{10}$');

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================

-- Comentario para la tabla
COMMENT ON TABLE Telefonos_Proveedor IS 'Tabla que almacena los números de teléfono de contacto de los proveedores.';

-- Comentarios para las columnas
COMMENT ON COLUMN Telefonos_Proveedor.IdProveedor IS 'Identificador del proveedor dueño de este número de teléfono.';
COMMENT ON COLUMN Telefonos_Proveedor.Telefono IS 'Número de teléfono de contacto del proveedor.';

-- Comentarios para los constraints (restricciones, PK y FK)
COMMENT ON CONSTRAINT Telefonos_Proveedor_pk ON Telefonos_Proveedor IS 'Llave primaria compuesta. Garantiza que un mismo proveedor no tenga el mismo número de teléfono registrado más de una vez.';
COMMENT ON CONSTRAINT Telefonos_Proveedor_fk ON Telefonos_Proveedor IS 'Llave foránea hacia Proveedor. Si el proveedor se elimina, sus teléfonos se borran automáticamente en cascada.';
COMMENT ON CONSTRAINT Telefonos_Proveedor_v ON Telefonos_Proveedor IS 'Valida que el número de teléfono tenga 10 dígitos numéricos exactos, permitiendo de forma opcional el código de país al inicio (ej. +52).';


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
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE EntregarMedComercial ADD CONSTRAINT EntregarMedComercial_fk2 
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE EntregarMedComercial ADD CONSTRAINT EntregarMedComercial_fk3 
FOREIGN KEY (IdMedicamento) REFERENCES MedComercial(IdMedicamento)
ON DELETE RESTRICT ON UPDATE CASCADE;

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

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================

-- Comentario para la tabla
COMMENT ON TABLE EntregarMedComercial IS 'Tabla  que registra el historial de recepciones de medicamentos comerciales enviados por los proveedores a las sucursales.';

-- Comentarios para las columnas
COMMENT ON COLUMN EntregarMedComercial.IdProveedor IS 'Identificador del proveedor que entrega la mercancía.';
COMMENT ON COLUMN EntregarMedComercial.IdSucursal IS 'Identificador de la sucursal física que recibe el medicamento.';
COMMENT ON COLUMN EntregarMedComercial.IdMedicamento IS 'Identificador del medicamento comercial ingresado.';
COMMENT ON COLUMN EntregarMedComercial.FechaRecepcion IS 'Fecha y hora exacta en la que se dio entrada al medicamento en la sucursal.';
COMMENT ON COLUMN EntregarMedComercial.FechaCaducidad IS 'Fecha de caducidad del lote de medicamento recibido.';
COMMENT ON COLUMN EntregarMedComercial.CondicionesAlmacenamiento IS 'Instrucciones específicas para el resguardo de este lote.';
COMMENT ON COLUMN EntregarMedComercial.CantidadRecibida IS 'Número de unidades físicas ingresadas al inventario en esta entrega.';
COMMENT ON COLUMN EntregarMedComercial.PrecioPublico IS 'Precio de venta al público fijado para este lote.';
COMMENT ON COLUMN EntregarMedComercial.PrecioUnitario IS 'Costo real al que se le compró cada unidad al proveedor.';

-- Comentarios para los constraints (restricciones y FKs)
COMMENT ON CONSTRAINT EntregarMedComercial_fk1 ON EntregarMedComercial IS 'Llave foránea hacia Proveedor. Restringe borrado para proteger historial de compras y actualiza en cascada.';
COMMENT ON CONSTRAINT EntregarMedComercial_fk2 ON EntregarMedComercial IS 'Llave foránea hacia Sucursal. Restringe borrado para proteger historial y actualiza en cascada.';
COMMENT ON CONSTRAINT EntregarMedComercial_fk3 ON EntregarMedComercial IS 'Llave foránea hacia MedComercial. Restringe borrado para proteger historial y actualiza en cascada.';
COMMENT ON CONSTRAINT EntregarMedComercial_d1 ON EntregarMedComercial IS 'Valida que la cantidad recibida al inventario sea estrictamente mayor a cero.';
COMMENT ON CONSTRAINT EntregarMedComercial_d2 ON EntregarMedComercial IS 'Valida que el precio al público no sea un valor negativo.';
COMMENT ON CONSTRAINT EntregarMedComercial_d3 ON EntregarMedComercial IS 'Valida que el precio unitario de compra no sea un valor negativo.';


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
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE EntregarInsumo ADD CONSTRAINT EntregarInsumo_fk2 
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE EntregarInsumo ADD CONSTRAINT EntregarInsumo_fk3 
FOREIGN KEY (IdInsumo) REFERENCES Insumo(IdInsumo)
ON DELETE RESTRICT ON UPDATE CASCADE;

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
--                      BLOQUE DE COMENTARIOS 
-- =================================================================

-- Comentario para la tabla
COMMENT ON TABLE EntregarInsumo IS 'Tabla que registra el historial de recepciones de insumos entregadas por proveedores a las sucursales.';

-- Comentarios para las columnas
COMMENT ON COLUMN EntregarInsumo.IdProveedor IS 'Identificador del proveedor que entrega el insumo.';
COMMENT ON COLUMN EntregarInsumo.IdSucursal IS 'Identificador de la sucursal física que recibe el insumo.';
COMMENT ON COLUMN EntregarInsumo.IdInsumo IS 'Identificador del insumo o materia prima ingresada.';
COMMENT ON COLUMN EntregarInsumo.FechaRecepcion IS 'Fecha y hora exacta en la que se dio entrada al insumo en la sucursal.';
COMMENT ON COLUMN EntregarInsumo.FechaCaducidad IS 'Fecha de caducidad del lote de insumo recibido.';
COMMENT ON COLUMN EntregarInsumo.CondicionesAlmacenamiento IS 'Instrucciones específicas para el resguardo seguro del lote.';
COMMENT ON COLUMN EntregarInsumo.CantidadRecibida IS 'Número de unidades físicas ingresadas al inventario en esta entrega.';
COMMENT ON COLUMN EntregarInsumo.PrecioPublico IS 'Precio de venta al público fijado para el insumo (en caso de aplicar venta directa).';
COMMENT ON COLUMN EntregarInsumo.PrecioUnitario IS 'Costo real al que se compró cada unidad del insumo al proveedor.';

-- Comentarios para los constraints (restricciones y FKs)
COMMENT ON CONSTRAINT EntregarInsumo_fk1 ON EntregarInsumo IS 'Llave foránea hacia Proveedor. Restringe borrado para mantener auditoría de compras y actualiza en cascada.';
COMMENT ON CONSTRAINT EntregarInsumo_fk2 ON EntregarInsumo IS 'Llave foránea hacia Sucursal. Restringe borrado y actualiza en cascada.';
COMMENT ON CONSTRAINT EntregarInsumo_fk3 ON EntregarInsumo IS 'Llave foránea hacia Insumo. Restringe borrado y actualiza en cascada.';
COMMENT ON CONSTRAINT EntregarInsumo_d1 ON EntregarInsumo IS 'Valida que la cantidad de insumos recibida sea estrictamente mayor a cero.';
COMMENT ON CONSTRAINT EntregarInsumo_d2 ON EntregarInsumo IS 'Valida que el precio al público no sea negativo.';
COMMENT ON CONSTRAINT EntregarInsumo_d3 ON EntregarInsumo IS 'Valida que el precio unitario de compra no sea negativo.';


-- MÓDULO 5

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

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================

-- Comentario para la tabla
COMMENT ON TABLE Cliente IS 'Tabla que almacena la información personal, dirección y preferencias de pago de los clientes.';

-- Comentarios para las columnas
COMMENT ON COLUMN Cliente.IdCliente IS 'Identificador único y autoincrementable del cliente.';
COMMENT ON COLUMN Cliente.Nombre IS 'Nombre(s) del cliente.';
COMMENT ON COLUMN Cliente.Paterno IS 'Apellido paterno del cliente.';
COMMENT ON COLUMN Cliente.Materno IS 'Apellido materno del cliente.';
COMMENT ON COLUMN Cliente.FechaNacimiento IS 'Fecha de nacimiento del cliente para cálculo de edad.';
COMMENT ON COLUMN Cliente.Calle IS 'Calle del domicilio del cliente.';
COMMENT ON COLUMN Cliente.NumeroExterior IS 'Número exterior del domicilio del cliente.';
COMMENT ON COLUMN Cliente.NumeroInterior IS 'Número interior del domicilio del cliente (es opcional).';
COMMENT ON COLUMN Cliente.Colonia IS 'Colonia del domicilio del cliente.';
COMMENT ON COLUMN Cliente.Estado IS 'Estado donde reside el cliente.';
COMMENT ON COLUMN Cliente.MetodoPago IS 'Método de pago preferido o registrado del cliente (Efectivo o Tarjeta).';

-- Comentarios para los constraints (restricciones y PK)
COMMENT ON CONSTRAINT Cliente_pk ON Cliente IS 'Llave primaria que identifica de forma única a cada cliente.';
COMMENT ON CONSTRAINT Cliente_d1 ON Cliente IS 'Valida que la fecha de nacimiento no sea una fecha en el futuro.';
COMMENT ON CONSTRAINT Cliente_d2 ON Cliente IS 'Valida que el número exterior sea estrictamente mayor a cero.';
COMMENT ON CONSTRAINT Cliente_d3 ON Cliente IS 'Valida que el método de pago sea exclusivamente Tarjeta o Efectivo.';
COMMENT ON CONSTRAINT Cliente_d4 ON Cliente IS 'Valida que el número interior, si se proporciona (no es nulo), sea mayor a cero.';


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
ON DELETE CASCADE ON UPDATE CASCADE;

-- Restricciones
ALTER TABLE ClienteOnline
ALTER COLUMN NombreUsuario SET NOT NULL,
ADD CONSTRAINT Clienteonline_u1 UNIQUE (NombreUsuario),
ALTER COLUMN Contraseña SET NOT NULL,
ALTER COLUMN NumeroTarjeta SET NOT NULL,
ALTER COLUMN FechaVencimiento SET NOT NULL;

-- =================================================================
--                      BLOQUE DE COMENTARIOS 
-- =================================================================

-- Comentario para la tabla
COMMENT ON TABLE ClienteOnline IS 'Tabla que almacena las credenciales de acceso y datos de pago específicos para los clientes que utilizan la plataforma en línea.';

-- Comentarios para las columnas
COMMENT ON COLUMN ClienteOnline.IdCliente IS 'Identificador del cliente. Funciona como llave primaria y a la vez como llave foránea hacia la tabla Cliente.';
COMMENT ON COLUMN ClienteOnline.NombreUsuario IS 'Nombre de usuario único para el inicio de sesión en la plataforma.';
COMMENT ON COLUMN ClienteOnline.Contraseña IS 'Contraseña cifrada (hash) del usuario para el acceso al sistema.';
COMMENT ON COLUMN ClienteOnline.NumeroTarjeta IS 'Número de la tarjeta bancaria a 16 dígitos para realizar compras en línea.';
COMMENT ON COLUMN ClienteOnline.FechaVencimiento IS 'Fecha de vencimiento de la tarjeta en formato MM/AA.';

-- Comentarios para los constraints (restricciones, PK y FK)
COMMENT ON CONSTRAINT ClienteOnline_pk ON ClienteOnline IS 'Llave primaria que identifica al cliente en línea (heredada de Cliente).';
COMMENT ON CONSTRAINT ClienteOnline_fk ON ClienteOnline IS 'Llave foránea hacia Cliente. Borra y actualiza en cascada el perfil en línea si el cliente base es modificado o eliminado.';
COMMENT ON CONSTRAINT Clienteonline_u1 ON ClienteOnline IS 'Garantiza que no existan dos clientes en línea compartiendo el mismo nombre de usuario.';


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
FOREIGN KEY (IdSucursal) REFERENCES Sucursal(IdSucursal);

ALTER TABLE Ticket ADD CONSTRAINT Ticket_fk2
FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente);

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
FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente);

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
FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente);

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
FOREIGN KEY (FolioTicket) REFERENCES Ticket(FolioTicket);

ALTER TABLE TenerMedComercial ADD CONSTRAINT TenerMedComercial_fk2
FOREIGN KEY (IdMedicamento) REFERENCES MedComercial(IdMedicamento);

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
FOREIGN KEY (FolioTicket) REFERENCES Ticket(FolioTicket);

ALTER TABLE TenerMedPreparado ADD CONSTRAINT TenerMedPreparado_fk2
FOREIGN KEY (IdMedicamento) REFERENCES MedPreparado(IdMedicamento);

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

-- MÓDULO 4

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
FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente);

ALTER TABLE Consulta ADD CONSTRAINT Consulta_fk2
FOREIGN KEY (RFCMedico) REFERENCES Medico(RFC);

ALTER TABLE Consulta ADD CONSTRAINT Consulta_fk3
FOREIGN KEY (RFCEnfermero) REFERENCES Enfermero(RFC);

ALTER TABLE Consulta ADD CONSTRAINT Consulta_fk4
FOREIGN KEY (FolioTicket) REFERENCES Ticket(FolioTicket);

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
FOREIGN KEY (IdConsulta) REFERENCES Consulta(IdConsulta);

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
FOREIGN KEY (IdConsulta, NumeroReceta) REFERENCES Receta(IdConsulta, NumeroReceta);

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
FOREIGN KEY (IdConsulta, NumeroReceta) REFERENCES Receta(IdConsulta, NumeroReceta);

ALTER TABLE PreescribirMedComercial ADD CONSTRAINT PreescribirMedComercial_fk2
FOREIGN KEY (IdMedicamento) REFERENCES MedComercial(IdMedicamento);

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
FOREIGN KEY (IdConsulta, NumeroReceta) REFERENCES Receta(IdConsulta, NumeroReceta);

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
ADD CONSTRAINT PreescribirMedPreparado_fk2 FOREIGN KEY (IdMedicamento) REFERENCES MedPreparado(IdMedicamento);

