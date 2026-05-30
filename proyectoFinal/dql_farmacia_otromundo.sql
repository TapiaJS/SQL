-- ======================================================================================
-- PROYECTO FINAL: "Una farmacia de otro mundo" - Equipo Hotline
-- SCRIPT DE CONSULTAS
-- ======================================================================================

/* * CONSULTA 1: Reporte de nómina por tipo de Personal por Sucursal.
 * * OBJETIVO:
 * Mostrar el reporte de nómina por tipo de Personal por Sucursal para
 * poder saber el costo total de la nómina por Sucursal.
 * * FUNCIONAMIENTO:
 * Pre-agrupa y suma los salarios de cada tipo de personal de forma independiente
 * para evitar la duplicación de filas (producto cartesiano). Luego une estos subtotales
 * a la tabla 'Sucursal' usando LEFT JOIN y calcula el gran total sustituyendo los
 * vacíos con COALESCE.
 */
SELECT s.IdSucursal, s.NombreSucursal,
       COALESCE(m.TotalMedicos, 0) AS NominaMedicos,
       COALESCE(e.TotalEnfermeros, 0) AS NominaEnfermeros,
       COALESCE(f.TotalFarmaceuticos, 0) AS NominaFarmaceuticos,
       COALESCE(c.TotalCajeros, 0) AS NominaCajeros,
       COALESCE(a.TotalAseadores, 0) AS NominaAseadores,
       COALESCE(cu.TotalCuidadores, 0) AS NominaCuidadores,
       (COALESCE(m.TotalMedicos, 0) + COALESCE(e.TotalEnfermeros, 0) +
        COALESCE(f.TotalFarmaceuticos, 0) + COALESCE(c.TotalCajeros, 0) +
        COALESCE(a.TotalAseadores, 0) + COALESCE(cu.TotalCuidadores, 0)) AS NominaTotal
FROM Sucursal s
LEFT JOIN (SELECT IdSucursal, SUM(Salario) AS TotalMedicos FROM Medico GROUP BY IdSucursal) m
    ON s.IdSucursal = m.IdSucursal
LEFT JOIN (SELECT IdSucursal, SUM(Salario) AS TotalEnfermeros FROM Enfermero GROUP BY IdSucursal) e
    ON s.IdSucursal = e.IdSucursal
LEFT JOIN (SELECT IdSucursal, SUM(Salario) AS TotalFarmaceuticos FROM Farmaceutico GROUP BY IdSucursal) f
    ON s.IdSucursal = f.IdSucursal
LEFT JOIN (SELECT IdSucursal, SUM(Salario) AS TotalCajeros FROM Cajero GROUP BY IdSucursal) c
    ON s.IdSucursal = c.IdSucursal
LEFT JOIN (SELECT IdSucursal, SUM(Salario) AS TotalAseadores FROM Aseador GROUP BY IdSucursal) a
    ON s.IdSucursal = a.IdSucursal
LEFT JOIN (SELECT IdSucursal, SUM(Salario) AS TotalCuidadores FROM Cuidador GROUP BY IdSucursal) cu
    ON s.IdSucursal = cu.IdSucursal
ORDER BY NominaTotal DESC;


/* * CONSULTA 2: Médicos cuya certificación está próxima a vencer en los próximos 6 meses.
 * * OBJETIVO:
 * Lista al personal médico que necesita renovar sus certificaciones lo más pronto posible
 * (vence dentro de los próximos 6 meses).
 * * FUNCIONAMIENTO:
 * Selecciona los datos del médico y filtra las filas evaluando que la fecha de vigencia
 * de la certificación se encuentre dentro de un rango dinámico que va desde el día de hoy
 * hasta seis meses en el futuro. Finalmente, ordena los registros de forma ascendente
 * para priorizar en el reporte los vencimientos más urgentes.
 */
SELECT RFC, Nombre, Paterno, Materno, VigenciaCertificacion, IdSucursal
FROM Medico
WHERE VigenciaCertificacion BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '6 months'
ORDER BY VigenciaCertificacion ASC;


/* * CONSULTA 3: Sucursales que cuentan con una clínica.
 * * OBJETIVO:
 * Lista las sucursales que tienen una clínica, lo cual es útil para encontrar la más cercana en una emergencia.
 * * FUNCIONAMIENTO:
 * Realiza una unión interna (INNER JOIN) entre la tabla 'Sucursal' y 'Clinica' utilizando IdSucursal,
 * por lo que filtra el resultado para devolver únicamente los registros que coexisten en ambas tablas y
 * descartar cualquier sucursal sin clínica.
 */
SELECT s.*
FROM Sucursal s
INNER JOIN Clinica c ON s.IdSucursal = c.IdSucursal;


/* * CONSULTA 4: Enfermeros con certificación de reanimación, su horario y el IdSucursal de la Sucursal donde trabaja.
 * * OBJETIVO:
 * Lista el personal capacitado para urgencias (CertificacionReanimacion = TRUE) y muestra sus horas de entrada y salida junto con el IdSucursal
 * de la Sucursal donde trabaja.
 * * FUNCIONAMIENTO:
 * Realiza un INNER JOIN entre la tabla 'Enfermero' y 'Sucursal' para asociar a cada empleado con la Sucursal donde trabaja.
 * Posteriormente, filtra los registros para conservar únicamente al personal que cuenta con la certificación de reanimación
 * y presenta los resultados ordenados por sucursal y hora de entrada, facilitando la identificación de la cobertura de emergencias por turnos.
 */
SELECT e.RFC, e.Nombre, e.Paterno, e.Dia, e.Entrada, e.Salida, s.IdSucursal
FROM Enfermero e
INNER JOIN Sucursal s ON e.IdSucursal = s.IdSucursal
WHERE e.CertificacionReanimacion = TRUE
ORDER BY s.IdSucursal, e.Entrada;


/* * CONSULTA 5: Medicamentos comerciales que están próximos a caducar y el NombreSucursal de la Sucursal donde se ubican.
 * * OBJETIVO:
 * Lista los medicamentos comerciales cuya fecha de caducidad esté dentro de los próximos 180 días para gestionar su salida o reemplazo.
 * * FUNCIONAMIENTO:
 * Realiza un INNER JOIN entre la tabla 'EntregarMedComercial' y la tabla 'Sucursal' para identificar la ubicación física del
 * inventario.
 * Aplica un filtro de rango (BETWEEN) para aislar los productos que expiran entre el día de hoy y los siguientes 180 días, ordenando el reporte
 * de forma ascendente por la fecha de caducidad para priorizar los lotes más críticos.
 */
SELECT e.IdMedicamento, s.NombreSucursal, e.FechaCaducidad, e.CantidadRecibida, e.CondicionesAlmacenamiento
FROM EntregarMedComercial e
INNER JOIN Sucursal s ON e.IdSucursal = s.IdSucursal
WHERE e.FechaCaducidad BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '180 days'
ORDER BY e.FechaCaducidad ASC;


/* * CONSULTA 6: Medicamentos comerciales ya caducados y el NombreSucursal de la Sucursal donde se encuentran.
 * * OBJETIVO:
 * Lista los medicamentos comerciales que ya han vencido para coordinar su retiro inmediato de los estantes de las sucursales.
 * * FUNCIONAMIENTO:
 * Realiza un INNER JOIN entre la tabla 'EntregarMedComercial' y la tabla 'Sucursal' para identificar la ubicación física del
 * inventario.
 * Aplica un filtro para aislar únicamente aquellos productos cuya fecha de caducidad sea estrictamente menor a la fecha actual y ordena
 * los resultados de manera descendente, mostrando en primer lugar el inventario que ha expirado más recientemente.
 */
SELECT e.IdMedicamento, s.NombreSucursal, e.FechaCaducidad, e.CantidadRecibida, e.CondicionesAlmacenamiento
FROM EntregarMedComercial e
INNER JOIN Sucursal s ON e.IdSucursal = s.IdSucursal
WHERE e.FechaCaducidad < CURRENT_DATE
ORDER BY e.FechaCaducidad DESC;


/* * CONSULTA 7: Margen de ganancia bruta por Medicamento Comercial.
 * * OBJETIVO:
 * Muestra el margen de ganancia bruta por Medicamento Comercial restando el PrecioUnitario (costo de proveedor) al PrecioPublico.
 * * FUNCIONAMIENTO:
 * Realiza un INNER JOIN entre la tabla 'EntregarMedComercial' y la tabla 'MedComercial' para asociar cada registro con el nombre
 * del producto en el catálogo. Utiliza la cláusula DISTINCT para aislar las diferentes combinaciones de precios, calcula la ganancia
 * bruta restando el costo al precio de venta, y obtiene el porcentaje de margen dividiendo dicha ganancia entre el costo del proveedor,
 * y multiplicando por 100 para terminar aplicando ROUND que limita el resultado a dos decimales.
 */
SELECT DISTINCT e.IdMedicamento, m.NombreComercial, e.PrecioUnitario AS CostoProveedor, e.PrecioPublico AS PrecioVenta,
       (e.PrecioPublico - e.PrecioUnitario) AS GananciaBrutaUnitaria,
       ROUND(((e.PrecioPublico - e.PrecioUnitario) / e.PrecioUnitario) * 100, 2) AS PorcentajeMargen
FROM EntregarMedComercial e
INNER JOIN MedComercial m ON e.IdMedicamento = m.IdMedicamento;


/* * CONSULTA 8: Sucursales con mayor recepción de medicamentos comerciales.
 * * OBJETIVO:
 * Mostrar qué sucursales reciben la mayor cantidad de medicamentos
 * comerciales para analizar la distribución de inventario.
 * * FUNCIONAMIENTO:
 * La consulta une 'Sucursal' con 'EntregarMedComercial'
 * usando IdSucursal. Después suma las cantidades recibidas
 * por sucursal y ordena de mayor a menor.
 */
SELECT s.IdSucursal,
       s.NombreSucursal,
       SUM(emc.CantidadRecibida) AS TotalRecibido
FROM Sucursal s
JOIN EntregarMedComercial emc
    ON s.IdSucursal = emc.IdSucursal
GROUP BY s.IdSucursal, s.NombreSucursal
ORDER BY TotalRecibido DESC; 


/* * CONSULTA 9: Total de personal en sucursales con clínica.
 * * OBJETIVO:
 * Mostrar cuántos empleados trabajan en las sucursales
 * que cuentan con clínica para analizar su capacidad operativa.
 * * FUNCIONAMIENTO:
 * La consulta primero obtiene únicamente las sucursales que
 * tienen clínica mediante un INNER JOIN entre 'Sucursal'
 * y 'Clinica'.
 *
 * Después, para evitar duplicar registros al unir muchas tablas
 * de personal al mismo tiempo, se realizan subconsultas
 * independientes para cada tipo de empleado
 * (Médico, Enfermero, Farmacéutico, Cajero, Aseador y Cuidador).
 *
 * Cada subconsulta agrupa por sucursal y cuenta el número
 * de trabajadores existentes.
 *
 * Finalmente, todos los resultados se unen con LEFT JOIN
 * sobre la tabla 'Sucursal' y se suman usando COALESCE
 * para reemplazar valores NULL por cero en caso de que
 * una sucursal no tenga cierto tipo de personal.
 */
SELECT s.IdSucursal,
       s.NombreSucursal,

       COALESCE(m.TotalMedicos, 0) AS Medicos,
       COALESCE(e.TotalEnfermeros, 0) AS Enfermeros,
       COALESCE(f.TotalFarmaceuticos, 0) AS Farmaceuticos,
       COALESCE(c.TotalCajeros, 0) AS Cajeros,
       COALESCE(a.TotalAseadores, 0) AS Aseadores,
       COALESCE(cu.TotalCuidadores, 0) AS Cuidadores,

       (
           COALESCE(m.TotalMedicos, 0) +
           COALESCE(e.TotalEnfermeros, 0) +
           COALESCE(f.TotalFarmaceuticos, 0) +
           COALESCE(c.TotalCajeros, 0) +
           COALESCE(a.TotalAseadores, 0) +
           COALESCE(cu.TotalCuidadores, 0)
       ) AS TotalPersonal

FROM Sucursal s

INNER JOIN Clinica cl
    ON s.IdSucursal = cl.IdSucursal

LEFT JOIN (
    SELECT IdSucursal, COUNT(*) AS TotalMedicos
    FROM Medico
    GROUP BY IdSucursal
) m
    ON s.IdSucursal = m.IdSucursal

LEFT JOIN (
    SELECT IdSucursal, COUNT(*) AS TotalEnfermeros
    FROM Enfermero
    GROUP BY IdSucursal
) e
    ON s.IdSucursal = e.IdSucursal

LEFT JOIN (
    SELECT IdSucursal, COUNT(*) AS TotalFarmaceuticos
    FROM Farmaceutico
    GROUP BY IdSucursal
) f
    ON s.IdSucursal = f.IdSucursal

LEFT JOIN (
    SELECT IdSucursal, COUNT(*) AS TotalCajeros
    FROM Cajero
    GROUP BY IdSucursal
) c
    ON s.IdSucursal = c.IdSucursal

LEFT JOIN (
    SELECT IdSucursal, COUNT(*) AS TotalAseadores
    FROM Aseador
    GROUP BY IdSucursal
) a
    ON s.IdSucursal = a.IdSucursal

LEFT JOIN (
    SELECT IdSucursal, COUNT(*) AS TotalCuidadores
    FROM Cuidador
    GROUP BY IdSucursal
) cu
    ON s.IdSucursal = cu.IdSucursal

ORDER BY TotalPersonal DESC;


/* * CONSULTA 10: Historial de compras por cliente diferenciando medicamentos comerciales vs preparados.
 * * OBJETIVO:
 * Generar un informe comercial y financiero detallado por cada cliente de la organización para analizar
 * el volumen de unidades adquiridas y el capital invertido en medicamentos comerciales frente a fórmulas preparadas.
 * * FUNCIONAMIENTO:
 * Vincula de forma interna las tablas 'Cliente', 'Ticket' y 'Sucursal' para segmentar geográficamente la actividad del usuario.
 * Incorpora operaciones LEFT JOIN hacia las tablas de transacciones específicas 'TenerMedComercial' y 'TenerMedPreparado' para
 * evitar exclusiones de filas. Emplea funciones de agregación (SUM) combinadas con estructuras COALESCE para consolidar de manera
 * aislada los conteos de piezas y montos económicos monetarios, agrupando los registros por el identificador único del cliente
 * y ordenando el listado final de forma descendente en función del gasto total efectuado.
 */
SELECT
cc.IdCliente,
cc.Nombre || ' ' || cc.Paterno || ' ' || cc.Materno AS NombreCompleto,
s.Estado AS EstadoSucursal,
COALESCE(SUM(tmc.CantidadComprada), 0) AS TotalUnidadesComerciales,
COALESCE(SUM(tmc.CantidadComprada * tmc.PrecioUnitario), 0) AS TotalGastoComercial,
COALESCE(SUM(tmp.CantidadComprada), 0) AS TotalUnidadesPreparadas,
COALESCE(SUM(tmp.CantidadComprada * tmp.PrecioUnitario), 0) AS TotalGastoPreparado,
COALESCE(SUM(tmc.CantidadComprada * tmc.PrecioUnitario), 0) +
COALESCE(SUM(tmp.CantidadComprada * tmp.PrecioUnitario), 0) AS GastoTotal
FROM Cliente cc
JOIN Ticket t ON cc.IdCliente = t.IdCliente
JOIN Sucursal s ON t.IdSucursal = s.IdSucursal
LEFT JOIN TenerMedComercial tmc ON t.FolioTicket = tmc.FolioTicket
LEFT JOIN TenerMedPreparado tmp ON t.FolioTicket = tmp.FolioTicket
GROUP BY cc.IdCliente, NombreCompleto, s.Estado
ORDER BY GastoTotal DESC;


/* * CONSULTA 11: Medicamentos preparados más elaborados en la farmacia.
 * * OBJETIVO:
 * Identificar cuáles medicamentos preparados se han elaborado con mayor frecuencia y en mayor cantidad total,
 * con el fin de analizar la demanda de producción de fórmulas magistrales.
 * * FUNCIONAMIENTO:
 * Se realiza un JOIN entre la tabla 'MedPreparado' y 'Elaborar' para relacionar cada fórmula con sus registros de producción.
 * COUNT(e.IdMedicamento) permite calcular cuántas veces ha sido elaborado cada medicamento.
 * SUM(e.CantidadElaborada) obtiene el total de unidades producidas por medicamento.
 * Finalmente, los resultados se agrupan por medicamento y se ordenan de mayor a menor producción total.
 */
SELECT 
    m.NombreComercial,
    COUNT(e.IdMedicamento) AS veces_elaborado,
    SUM(e.CantidadElaborada) AS total_producido
FROM MedPreparado m
JOIN Elaborar e ON m.IdMedicamento = e.IdMedicamento
GROUP BY m.IdMedicamento, m.NombreComercial
ORDER BY total_producido DESC;


/* * CONSULTA 12: Todas las recepciones de inventario con proveedor, sucursal y fechas.
 * * OBJETIVO:
 * Generar una bitácora logística unificada e individualizada que documente cronológicamente el ingreso físico
 * de productos a los almacenes de la empresa, diferenciando medicamentos comerciales de insumos médicos.
 * * FUNCIONAMIENTO:
 * Emplea el operador de conjuntos UNION ALL para consolidar de forma lineal dos subconsultas transaccionales de abastecimiento.
 * Ambos bloques realizan operaciones JOIN con las tablas maestras 'Proveedor' y 'Sucursal' para mapear el origen y destino del lote.
 * El primer segmento se enlaza a 'EntregarMedComercial' y 'MedComercial' para detallar los fármacos de patente; mientras que el
 * segundo segmento se acopla a 'EntregarInsumo' y 'Insumo' para registrar los materiales médicos. Calcula dinámicamente el costo
 * total multiplicando la cantidad por el precio unitario y aplica un ordenamiento descendente basado en la fecha de recepción.
 */
SELECT
'Medicamento Comercial' AS TipoProducto,
p.RazonSocial AS Proveedor,
s.NombreSucursal,
s.Estado AS EstadoSucursal,
emc.FechaRecepcion,
mc.NombreComercial AS Producto,
mc.Presentacion,
emc.CantidadRecibida,
emc.PrecioUnitario,
(emc.CantidadRecibida * emc.PrecioUnitario) AS CostoTotalLote,
emc.FechaCaducidad,
emc.CondicionesAlmacenamiento
FROM EntregarMedComercial emc
JOIN Proveedor p ON emc.IdProveedor = p.IdProveedor
JOIN Sucursal s ON emc.IdSucursal = s.IdSucursal
JOIN MedComercial mc ON emc.IdMedicamento = mc.IdMedicamento

UNION ALL

SELECT
'Insumo' AS TipoProducto,
p.RazonSocial AS Proveedor,
s.NombreSucursal,
s.Estado,
ei.FechaRecepcion,
i.NombreComercial AS Producto,
i.FormaFisica AS Presentacion,
ei.CantidadRecibida,
ei.PrecioUnitario,
(ei.CantidadRecibida * ei.PrecioUnitario) AS CostoTotalLote,
ei.FechaCaducidad,
ei.CondicionesAlmacenamiento
FROM EntregarInsumo ei
JOIN Proveedor p ON ei.IdProveedor = p.IdProveedor
JOIN Sucursal s ON ei.IdSucursal = s.IdSucursal
JOIN Insumo i ON ei.IdInsumo = i.IdInsumo

ORDER BY FechaRecepcion DESC, NombreSucursal;


/* * CONSULTA 13: Total de compras realizadas a cada proveedor.
 * * OBJETIVO:
 * Obtener el total de productos (medicamentos comerciales e insumos)
 * que cada proveedor ha suministrado a la farmacia, con el fin de analizar
 * cuáles proveedores tienen mayor participación en el abastecimiento.
 * * FUNCIONAMIENTO:
 * Se realiza un LEFT JOIN entre la tabla 'Proveedor' y las tablas
 * 'EntregarMedComercial' y 'EntregarInsumo' para incluir a todos los proveedores,
 * incluso aquellos que no han realizado entregas.
 *
 * SUM(CantidadRecibida) permite calcular el total de unidades entregadas
 * por cada proveedor en ambas categorías.
 *
 * COALESCE se utiliza para evitar valores NULL cuando un proveedor no tiene registros
 * en alguna de las tablas de entrega.
 *
 * Finalmente, los resultados se agrupan por proveedor y se ordenan de mayor a menor
 * según el total de compras realizadas.
 */
SELECT p.IdProveedor,
       p.RazonSocial,
       COALESCE(SUM(emc.CantidadRecibida), 0) +
       COALESCE(SUM(ei.CantidadRecibida), 0) AS TotalCompras
FROM Proveedor p
LEFT JOIN EntregarMedComercial emc
    ON p.IdProveedor = emc.IdProveedor
LEFT JOIN EntregarInsumo ei
    ON p.IdProveedor = ei.IdProveedor
GROUP BY p.IdProveedor, p.RazonSocial
ORDER BY TotalCompras DESC;


/* *CONSULTA 14: 50 Farmacéuticos con mayor producción de medicamentos preparados.
 * *OBJETIVO:
 * Determinar qué farmacéuticos han producido la mayor cantidad de fórmulas magistrales,
 * sumando todas las unidades elaboradas en la farmacia.
 * * FUNCIONAMIENTO:
 * Se utiliza la tabla 'Elaborar' donde se registran las producciones de medicamentos preparados.
 * Se realiza un JOIN con la tabla 'Farmaceutico' a través del campo RFC,
 * para poder obtener el nombre del farmacéutico asociado a cada producción.
 *
 * SUM(e.CantidadElaborada) permite calcular el total de unidades producidas por cada farmacéutico.
 *
 * Los resultados se agrupan por el nombre del farmacéutico para consolidar su producción total.
 *
 * Finalmente, ORDER BY total_producido DESC ordena de mayor a menor producción,
 * y LIMIT 50 para devolver únicamente a los 50 farmacéuticos con mayor producción.
 */
SELECT 
    f.Nombre,
    SUM(e.CantidadElaborada) AS total_producido
FROM Elaborar e
JOIN Farmaceutico f 
    ON e.RFC = f.RFC
GROUP BY f.Nombre
ORDER BY total_producido DESC
LIMIT 50;


/* * CONSULTA 15: Listado detallado de todas las prescripciones (comerciales y preparadas) por consulta.
 * * OBJETIVO:
 * Generar un informe clínico unificado e individualizado que desglose el universo de medicamentos prescritos
 * (tanto de catálogo comercial como fórmulas magistrales preparadas) asociados a cada folio de consulta médica.
 * * FUNCIONAMIENTO:
 * Emplea el operador de conjuntos UNION ALL para unificar de forma lineal dos subconsultas transaccionales de detalle.
 * Ambas secciones interconectan las tablas 'CobrarConsulta', 'Receta', 'Cliente' y 'Medico' a través de operaciones JOIN.
 * La primera mitad se acopla a 'PrescribirMedComercial' y 'MedComercial' para extraer los fármacos de patente; mientras
 * que la segunda mitad se enlaza a 'PrescribirMedPreparado' y 'MedPreparado' para catalogar los compuestos personalizados,
 * aplicando restricciones de nulidad (IS NOT NULL) para aislar registros válidos y ordenando cronológicamente el reporte final.
 */
 SELECT
cc.Fecha,
cc.Hora,
cli.Nombre || ' ' || cli.Paterno || ' ' || cli.Materno AS Paciente,
m.Nombre || ' ' || m.Paterno || ' ' || m.Materno AS Medico,
r.NumeroReceta,
r.Consultorio,
r.Turno,
'Comercial' AS TipoMedicamento,
mc.NombreComercial AS Medicamento,
pc.DosisPrescrita,
pc.Frecuencia,
pc.ViaAdministracionIndicada,
pc.Duracion,
cc.Diagnostico
FROM CobrarConsulta cc
JOIN Receta r ON cc.IdConsulta = r.IdConsulta
JOIN Cliente cli ON cc.IdCliente = cli.IdCliente
JOIN Medico m ON cc.RFCMedico = m.RFC
LEFT JOIN PrescribirMedComercial pc ON r.IdConsulta = pc.IdConsulta AND r.NumeroReceta = pc.NumeroReceta
LEFT JOIN MedComercial mc ON pc.IdMedicamento = mc.IdMedicamento
WHERE pc.IdMedicamento IS NOT NULL

UNION ALL

SELECT
cc.Fecha,
cc.Hora,
cli.Nombre || ' ' || cli.Paterno || ' ' || cli.Materno,
m.Nombre || ' ' || m.Paterno || ' ' || m.Materno,
r.NumeroReceta,
r.Consultorio,
r.Turno,
'Preparado' AS TipoMedicamento,
mp.NombreComercial AS Medicamento,
pp.DosisPrescrita,
pp.Frecuencia,
pp.ViaAdministracionIndicada,
pp.Duracion,
cc.Diagnostico
FROM CobrarConsulta cc
JOIN Receta r ON cc.IdConsulta = r.IdConsulta
JOIN Cliente cli ON cc.IdCliente = cli.IdCliente
JOIN Medico m ON cc.RFCMedico = m.RFC
LEFT JOIN PrescribirMedPreparado pp ON r.IdConsulta = pp.IdConsulta AND r.NumeroReceta = pp.NumeroReceta
LEFT JOIN MedPreparado mp ON pp.IdMedicamento = mp.IdMedicamento
WHERE pp.IdMedicamento IS NOT NULL

ORDER BY Fecha, Hora, NumeroReceta;

