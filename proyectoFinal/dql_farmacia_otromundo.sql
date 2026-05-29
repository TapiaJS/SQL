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
