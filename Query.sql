-- i. Clientes cuyo nombre empiece con la letra R.
SELECT * FROM Cliente 
WHERE Nombre LIKE 'R%';

-- ii. Medicamentos que hayan caducado después del 20 de abril del 2026 pero antes del 07 de mayo del 2026.
-- Medicamentos comerciales caducados
SELECT 
    mc.NombreComercial, 
    emc.FechaCaducidad
FROM EntregarMedComercial emc
JOIN MedComercial mc ON emc.IdMedicamento = mc.IdMedicamento
WHERE emc.FechaCaducidad > '2026-04-20' 
  AND emc.FechaCaducidad < '2026-05-07';

--Medicamentos preparados caducados por los insumos caducaron en esa fecha
SELECT DISTINCT mp.* FROM MedPreparado mp
JOIN Contener c ON mp.IdMedicamento = c.IdMedicamento
JOIN EntregarInsumo ei ON c.IdInsumo = ei.IdInsumo
WHERE ei.FechaCaducidad > '2026-04-20' 
  AND ei.FechaCaducidad < '2026-05-07';

-- iii. Farmacéuticos que hayan nacido en el mes de noviembre.
SELECT * FROM Farmaceutico 
WHERE EXTRACT(MONTH FROM FechaNacimiento) = 11;

--iv. Medicamentos cuya forma física sea gel y vía de administración sea oral.
-- Para los Medicamentos Comerciales
SELECT * FROM MedComercial 
WHERE FormaFarmaceutica = 'Gel' AND ViaAdministracion = 'Oral';

-- Para las Fórmulas Magistrales (Medicamentos Preparados)
SELECT * FROM MedPreparado 
WHERE FormaFarmaceutica = 'Gel' AND ViaAdministracion = 'Oral';

-- v. Todos los proveedores registrados en la base de datos. 
SELECT * FROM Proveedor;
