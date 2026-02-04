--Full Backup
BACKUP DATABASE MiLaboratorio 
TO DISK = 'C:\Backups\MiLab_Full.bak'
WITH FORMAT, MEDIANAME = 'SQLServerBackups', NAME = 'Full Backup de MiLab';
GO

--Differential
BACKUP DATABASE MiLaboratorio 
TO DISK = 'C:\Backups\MiLab_Diff.bak'
WITH DIFFERENTIAL, NAME = 'Diff Backup de MiLab';
GO

--Transaction Log
BACKUP LOG MiLaboratorio 
TO DISK = 'C:\Backups\MiLab_Log.trn'
WITH NAME = 'Log Backup de MiLab';
GO





--EJERCICIO

--PASO 1
CREATE DATABASE MiLaboratorio;
GO

USE MiLaboratorio;

CREATE TABLE Usuarios (Id INT, Nombre VARCHAR(50));
INSERT INTO Usuarios VALUES (1, 'Admin');

--PASO 2
-- HACEMOS FULL BACKUP AQUÍ 
BACKUP DATABASE MiLaboratorio 
TO DISK = 'C:\Backups\MiLab_Full.bak'
WITH FORMAT, MEDIANAME = 'SQLServerBackups', NAME = 'Full Backup de MiLab';
GO


--PASO 3
-- INSERTAMOS DATOS
INSERT INTO Usuarios VALUES (2, 'Editor');

--PASO 4
-- HACEMOS DIFFERENTIAL BACKUP AQUÍ
BACKUP DATABASE MiLaboratorio 
TO DISK = 'C:\Backups\MiLab_Diff.bak'
WITH DIFFERENTIAL, MEDIANAME = 'SQLServerBackups', NAME = 'Diff Backup de MiLab';
GO

--PASO 5
-- INSERTAMOS OTROS CAMBIOS
INSERT INTO Usuarios VALUES (3, 'Invitado');


--PASO 6
-- HACEMO BACKUP AL LOG DE TRANSACCIONES
BACKUP LOG MiLaboratorio 
TO DISK = 'C:\Backups\MiLab_Log.trn'
WITH MEDIANAME = 'SQLServerBackups', NAME = 'Log Backup de MiLab';
GO


--!Momento del desastre! Eliminar mi base de datos

DROP DATABASE MiLaboratorio;

--Comando de Inspeccion Información de mis archivos
Restore headeronly 
from disk='C:\Backups\MiLab_log.trn'

RESTORE FILELISTONLY
from disk='C:\Backups\MiLab_full.bak'

RESTORE LABELONLY 
FROM DISK = 'C:\Backups\MiLab_log.trn';
GO


-- 1. Restaurar el FULL (Obligatorio)
RESTORE DATABASE MiLaboratorio 
FROM DISK = 'C:\Backups\MiLab_Full.bak' 
WITH NORECOVERY;

-- 2. Restaurar el DIFF 
RESTORE DATABASE MiLaboratorio 
FROM DISK = 'C:\Backups\MiLab_Diff.bak' 
WITH NORECOVERY;

-- 3. Restaurar el LOG (Para llegar al final)
RESTORE DATABASE MiLaboratorio 
FROM DISK = 'C:\Backups\MiLab_Log.trn'
WITH RECOVERY; 
-- El último paso lleva RECOVERY para que la base de datos vuelva a estar en línea.



USE MiLaboratorio
GO

SELECT * FROM Usuarios