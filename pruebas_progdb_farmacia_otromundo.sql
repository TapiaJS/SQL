-- =====================================================================
-- 1. NUEVOS DATOS PARA PROBAR TRIGGERS Y PROCEDIMIENTOS
-- =====================================================================

-- Nueva sucursal (se usará en tickets y entregas)
INSERT INTO Sucursal (IdSucursal, NombreSucursal, Calle, NumeroExterior, Colonia, Estado, Telefono)
VALUES (1001, 'Sucursal Test', 'Av. Prueba', 123, 'Centro', 'CDMX', '5551234567')
RETURNING IdSucursal; -- IdSucursal = 1001

-- Clínica asociada a esa sucursal (relación 1:1)
INSERT INTO Clinica (IdClinica, NombreClinica, NumCuarto, IdSucursal)
VALUES (1001, 'Clínica Test', 101, 1001); -- IdSucursal = 1001

-- Médico (necesario para consultas, pero no para probar triggers de ventas)
INSERT INTO Medico (RFC, Nombre, Paterno, Materno, Calle, NumeroExterior, Colonia, Estado, Dia, Entrada, Salida, Salario, IdSucursal, InstitucionEgreso, VigenciaCertificacion, CedulaProfesional, FechaNacimiento)
VALUES ('TESTRFC001', 'Juan', 'Perez', 'Gomez', 'Calle Medico', 10, 'Centro', 'CDMX', 'Lunes', '09:00', '17:00', 15000, 1001, 'UNAM', '2025-12-31', 123456789, '1980-01-01');

-- Enfermero (puede ser null en consulta, pero lo insertamos)
INSERT INTO Enfermero (RFC, Nombre, Paterno, Materno, Calle, NumeroExterior, Colonia, Estado, Dia, Entrada, Salida, Salario, IdSucursal, TipoProcedimientoCargo, CertificacionReanimacion, CedulaProfesional, FechaNacimiento)
VALUES ('TESTENF001', 'Ana', 'Lopez', 'Martinez', 'Calle Enfermero', 20, 'Centro', 'CDMX', 'Martes', '08:00', '16:00', 12000, 1001, 'Cuidados generales', true, 987654321, '1985-05-10');

-- Cliente (para tickets)
INSERT INTO Cliente (IdCliente, Nombre, Paterno, Materno, FechaNacimiento, Calle, NumeroExterior, Colonia, Estado, MetodoPago)
VALUES (1001, 'Carlos', 'Ramirez', 'Torres', '1990-03-15', 'Calle Cliente', 45, 'Del Valle', 'CDMX', 'Efectivo')
RETURNING IdCliente; -- IdCliente = 1001

-- Proveedor (para entregas de medicamentos)
INSERT INTO Proveedor (IdProveedor, RazonSocial, Calle, NumeroExterior, Colonia, Estado)
VALUES (1001, 'Laboratorios Test', 'Av. Proveedor', 500, 'Industrial', 'NL')
RETURNING IdProveedor; -- IdProveedor = 1001

-- Medicamento comercial (tipo control = 'VENTA LIBRE' para pruebas web exitosas)
INSERT INTO MedComercial (IdMedicamento, NombreComercial, FormaFarmaceutica, Concentracion, Presentacion, ViaAdministracion, Clasificacion, TipoControl, Descripcion, NombreGenerico, LabFabricante)
VALUES (1001, 'Paracetamol Test', 'Tabletas', '500 mg', 'Caja 20 tabs', 'Oral', 'Analgésico', 'VENTA LIBRE', 'Para dolor y fiebre', 'Paracetamol', 'Genérico Test')
RETURNING IdMedicamento; -- IdMedicamento = 1001

-- Medicamento comercial controlado (para probar bloqueo web)
INSERT INTO MedComercial (IdMedicamento, NombreComercial, FormaFarmaceutica, Concentracion, Presentacion, ViaAdministracion, Clasificacion, TipoControl, Descripcion, NombreGenerico, LabFabricante)
VALUES (1002, 'Amoxicilina Test', 'Cápsulas', '500 mg', 'Caja 16 caps', 'Oral', 'Antibiótico', 'ANTIBIÓTICO', 'Antibiótico de amplio espectro', 'Amoxicilina', 'Lab Control')
RETURNING IdMedicamento; -- IdMedicamento = 1002

-- Medicamento preparado (tipo control = 'VENTA LIBRE')
INSERT INTO MedPreparado (IdMedicamento, NombreComercial, FormaFarmaceutica, Concentracion, Presentacion, ViaAdministracion, Clasificacion, TipoControl, Descripcion, Categoria)
VALUES (1001, 'Jarabe Test Prep', 'Jarabe', '100 mg/5ml', 'Frasco 120ml', 'Oral', 'Antitusivo', 'VENTA LIBRE', 'Jarabe para la tos', 'Fórmula magistral')
RETURNING IdMedicamento; -- Supongamos IdMedicamento = 5001

-- Medicamento preparado controlado
INSERT INTO MedPreparado (IdMedicamento,NombreComercial, FormaFarmaceutica, Concentracion, Presentacion, ViaAdministracion, Clasificacion, TipoControl, Descripcion, Categoria)
VALUES (1002, 'Crema Control', 'Crema', '2%', 'Tubo 30g', 'Tópica', 'Antifúngico', 'CONTROL ESPECIAL', 'Para hongos', 'Preparado controlado')
RETURNING IdMedicamento; -- Supongamos IdMedicamento = 5002

-- =====================================================================
-- 2. CREAR STOCK PARA PRUEBAS DE DISPONIBILIDAD
-- =====================================================================

-- Entregar medicamento comercial (crear stock)
INSERT INTO EntregarMedComercial (IdProveedor, IdSucursal, IdMedicamento, FechaRecepcion, FechaCaducidad, CondicionesAlmacenamiento, CantidadRecibida, PrecioPublico, PrecioUnitario)
VALUES (1001, 1001, 1001, NOW(), '2026-12-31', 'Ambiente', 100, 50.00, 30.00); -- 100 unidades de Paracetamol

-- Entregar medicamento comercial controlado (stock para probar venta presencial)
INSERT INTO EntregarMedComercial (IdProveedor, IdSucursal, IdMedicamento, FechaRecepcion, FechaCaducidad, CondicionesAlmacenamiento, CantidadRecibida, PrecioPublico, PrecioUnitario)
VALUES (1001, 1001, 1002, NOW(), '2025-08-15', 'Fresco', 50, 120.00, 80.00); -- 50 unidades de Amoxicilina

-- Elaborar medicamento preparado (crear stock)
-- Necesitamos un farmacéutico que elabore
INSERT INTO Farmaceutico (RFC, Nombre, Paterno, Materno, Calle, NumeroExterior, Colonia, Estado, Dia, Entrada, Salida, Salario, IdSucursal, CedulaProfesional, FechaNacimiento)
VALUES ('TESTFAR001', 'Luis', 'Fernandez', 'Rios', 'Calle Farma', 30, 'Centro', 'CDMX', 'Miércoles', '10:00', '18:00', 18000, 1001, 555888777, '1978-09-20');

INSERT INTO Elaborar (RFC, IdMedicamento, FechaElaboracion, CantidadElaborada)
VALUES ('TESTFAR001', 1001, NOW(), 200); -- 200 unidades de jarabe

-- Elaborar preparado controlado
INSERT INTO Elaborar (RFC, IdMedicamento, FechaElaboracion, CantidadElaborada)
VALUES ('TESTFAR001', 1002, NOW(), 30);

-- =====================================================================
-- 3. PRUEBA DE TRIGGERS (INSERTS EN TENER...)
-- =====================================================================

-- 3.1 Venta web exitosa (medicamento VENTA LIBRE)
-- Primero crear ticket tipo 'Web'
INSERT INTO Ticket (FolioTicket, FechaPago, HoraPago, TipoVenta, IdSucursal, IdCliente, EsTicketConsulta, EsTicketMedicamento)
VALUES (1001, CURRENT_DATE, CURRENT_TIME, 'Web', 1001, 1001, FALSE, TRUE)
RETURNING FolioTicket; -- Supongamos FolioTicket = 1001

-- Insertar detalle con medicamento VENTA LIBRE (debe funcionar)
INSERT INTO TenerMedComercial (FolioTicket, IdMedicamento, CantidadComprada, PrecioUnitario)
VALUES (1001, 1001, 2, 50.00); -- Paracetamol, 2 unidades

-- 3.2 Venta web fallida (medicamento controlado) - generará EXCEPTION
-- Crear otro ticket web
INSERT INTO Ticket (FolioTicket, FechaPago, HoraPago, TipoVenta, IdSucursal, IdCliente, EsTicketConsulta, EsTicketMedicamento)
VALUES (1002, CURRENT_DATE, CURRENT_TIME, 'Web', 1001, 1001, FALSE, TRUE)
RETURNING FolioTicket; -- 1002

-- El siguiente INSERT debe fallar con mensaje: "Venta web rechazada: El medicamento ID 4002 ... requiere receta"
-- INSERT INTO TenerMedComercial (FolioTicket, IdMedicamento, CantidadComprada, PrecioUnitario)
-- VALUES (1002, 1002, 1, 120.00);  -- DESCOMENTAR PARA PROBAR EL ERROR

-- 3.3 Venta presencial de controlado (debe permitirse)
INSERT INTO Ticket (FolioTicket, FechaPago, HoraPago, TipoVenta, IdSucursal, IdCliente, EsTicketConsulta, EsTicketMedicamento)
VALUES (1003, CURRENT_DATE, CURRENT_TIME, 'Presencial', 1001, 1001, FALSE, TRUE)
RETURNING FolioTicket; -- 1003

INSERT INTO TenerMedComercial (FolioTicket, IdMedicamento, CantidadComprada, PrecioUnitario)
VALUES (1003, 1002, 1, 120.00); -- Antibiótico en venta presencial, permitido

-- 3.4 Prueba de stock insuficiente (para comercial)
-- Intentar comprar más de lo disponible (stock actual = 100 - 2 = 98, intentamos 150)
INSERT INTO Ticket (FolioTicket, FechaPago, HoraPago, TipoVenta, IdSucursal, IdCliente, EsTicketConsulta, EsTicketMedicamento)
VALUES (1004, CURRENT_DATE, CURRENT_TIME, 'Presencial', 1001, 1001, FALSE, TRUE)
RETURNING FolioTicket; -- 1004

-- El siguiente INSERT debe fallar: "Stock insuficiente para el medicamento comercial ID 4001. Stock actual: 98"
-- INSERT INTO TenerMedComercial (FolioTicket, IdMedicamento, CantidadComprada, PrecioUnitario)
-- VALUES (1004, 1001, 150, 50.00);  -- DESCOMENTAR PARA PROBAR ERROR

-- Compra válida con stock suficiente
INSERT INTO TenerMedComercial (FolioTicket, IdMedicamento, CantidadComprada, PrecioUnitario)
VALUES (1004, 1001, 5, 50.00); -- resta 5, nuevo stock 93

-- 3.5 Prueba de stock insuficiente para preparado
-- Crear ticket
INSERT INTO Ticket (FolioTicket, FechaPago, HoraPago, TipoVenta, IdSucursal, IdCliente, EsTicketConsulta, EsTicketMedicamento)
VALUES (1005, CURRENT_DATE, CURRENT_TIME, 'Presencial', 1001, 1001, FALSE, TRUE)
RETURNING FolioTicket; -- 1005

-- Intentar comprar más que el stock (stock actual 200, intentamos 250)
-- INSERT INTO TenerMedPreparado (FolioTicket, IdMedicamento, CantidadComprada, PrecioUnitario)
-- VALUES (1005, 1001, 250, 80.00);  -- Falla

-- Compra válida
INSERT INTO TenerMedPreparado (FolioTicket, IdMedicamento, CantidadComprada, PrecioUnitario)
VALUES (1005, 1001, 10, 80.00); -- stock restante 190

-- 3.6 Prueba de web con preparado VENTA LIBRE (debe permitir)
INSERT INTO Ticket (FolioTicket, FechaPago, HoraPago, TipoVenta, IdSucursal, IdCliente, EsTicketConsulta, EsTicketMedicamento)
VALUES (1006, CURRENT_DATE, CURRENT_TIME, 'Web', 1001, 1001, FALSE, TRUE)
RETURNING FolioTicket; -- 1006

INSERT INTO TenerMedPreparado (FolioTicket, IdMedicamento, CantidadComprada, PrecioUnitario)
VALUES (1006, 1001, 2, 80.00); -- jarabe VENTA LIBRE por web, OK

-- 3.7 Prueba de web con preparado controlado (debe fallar)
INSERT INTO Ticket (FolioTicket, FechaPago, HoraPago, TipoVenta, IdSucursal, IdCliente, EsTicketConsulta, EsTicketMedicamento)
VALUES (1007, CURRENT_DATE, CURRENT_TIME, 'Web', 1001, 1001, FALSE, TRUE)
RETURNING FolioTicket; -- 1007

-- INSERT INTO TenerMedPreparado (FolioTicket, IdMedicamento, CantidadComprada, PrecioUnitario)
-- VALUES (1007, 1002, 1, 150.00);  -- Falla por controlado

-- =====================================================================
-- 4. PRUEBAS DE CONSULTAS (para que CobrarConsulta tenga datos)
-- =====================================================================

-- Ticket para consulta médica
INSERT INTO Ticket (FolioTicket, FechaPago, HoraPago, TipoVenta, IdSucursal, IdCliente, EsTicketConsulta, EsTicketMedicamento)
VALUES (1008, CURRENT_DATE, CURRENT_TIME, 'Presencial', 1001, 1001, TRUE, FALSE)
RETURNING FolioTicket; -- 1008

-- Registrar consulta
INSERT INTO CobrarConsulta (IdConsulta, Fecha, Hora, Diagnostico, Precio, IdCliente, RFCMedico, RFCEnfermero, FolioTicket)
VALUES (1001, CURRENT_DATE, CURRENT_TIME, 'Dolor de cabeza', 350.00, 1001, 'TESTRFC001', 'TESTENF001', 1008);

-- =====================================================================
-- 5. EJECUCIÓN DE PROCEDIMIENTOS Y FUNCIÓN
-- =====================================================================

-- 5.1 Corte de caja diario (usar la fecha actual, donde insertamos tickets)
CALL sp_corte_caja_diario(CURRENT_DATE);

-- 5.2 Reporte de stock crítico con límite 20 unidades (mostrará los que están bajos)
CALL sp_reporte_stock_critico(20);

-- 5.3 Probar función de cálculo de ticket (folio 1004, por ejemplo)
SELECT * FROM fn_calcular_cuenta_ticket(1004);

-- =====================================================================
-- NOTA: Para ver realmente los errores lanzados por los triggers, 
-- se deben descomentar las líneas marcadas como "Falla" y ejecutarlas 
-- en una transacción separada. Los inserts válidos ya están activos.
-- =====================================================================
