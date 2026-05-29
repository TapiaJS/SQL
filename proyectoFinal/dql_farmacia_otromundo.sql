-- ======================================================================================
-- PROYECTO FINAL: "Una farmacia de otro mundo" - Equipo Hotline
-- SCRIPT DE CONSULTAS
-- ======================================================================================

/* * CONSULTA 1: Reporte de nómina por tipo de Personal por Sucursal
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
