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

-- Es igual a la 1 peor en este caso infla los valores por un producto cartesiano
/* * CONSULTA 10: Cálculo de gasto total de nómina por sucursal.
 * * OBJETIVO:
 * Obtener el gasto total en nómina por sucursal sumando los salarios de todos los empleados
 * (médicos, enfermeros, farmacéuticos, cajeros, aseadores y cuidadores).
 * * FUNCIONAMIENTO:
 * Se realiza un LEFT JOIN desde la tabla Sucursal hacia cada una de las tablas de empleados.
 * Luego se suman los salarios por tipo de empleado utilizando SUM() y COALESCE para evitar valores nulos.
 * Finalmente se agrupan los resultados por sucursal y se ordenan de mayor a menor gasto de nómina.
 */
SELECT 
    s.NombreSucursal,
    COALESCE(SUM(m.Salario), 0) +
    COALESCE(SUM(e.Salario), 0) +
    COALESCE(SUM(f.Salario), 0) +
    COALESCE(SUM(c.Salario), 0) +
    COALESCE(SUM(a.Salario), 0) +
    COALESCE(SUM(cu.Salario), 0) AS gasto_nomina
FROM Sucursal s
LEFT JOIN Medico m ON m.IdSucursal = s.IdSucursal
LEFT JOIN Enfermero e ON e.IdSucursal = s.IdSucursal
LEFT JOIN Farmaceutico f ON f.IdSucursal = s.IdSucursal
LEFT JOIN Cajero c ON c.IdSucursal = s.IdSucursal
LEFT JOIN Aseador a ON a.IdSucursal = s.IdSucursal
LEFT JOIN Cuidador cu ON cu.IdSucursal = s.IdSucursal
GROUP BY s.IdSucursal, s.NombreSucursal
ORDER BY gasto_nomina DESC;


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


-- solo da 31 tuplas
/* * CONSULTA 12: Sucursales por estado.
 * * OBJETIVO:
 * Conocer cuántas sucursales existen en cada estado, con el fin de analizar su distribución geográfica.
 * * FUNCIONAMIENTO:
 * Se selecciona el campo 'Estado' de la tabla 'Sucursal'.
 * COUNT(*) permite contar el número total de sucursales registradas por cada estado.
 * GROUP BY agrupa los registros por estado para poder hacer el conteo.
 * ORDER BY ordena los resultados de mayor a menor número de sucursales.
 */
SELECT 
    Estado,
    COUNT(*) AS NumeroSucursales
FROM Sucursal
GROUP BY Estado
ORDER BY NumeroSucursales DESC;


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

