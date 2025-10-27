use raamataleksejev

CREATE TABLE Autor (
AutorID INT IDENTITY(1,1) PRIMARY KEY,
AutorNimi NVARCHAR(100),
Riik NVARCHAR(50)
);

CREATE TABLE Raamat (
RaamatID INT IDENTITY(1,1) PRIMARY KEY,
Pealkiri NVARCHAR(200),
AutorID INT FOREIGN KEY REFERENCES Autor(AutorID),
Lehek�lgedeArv INT
);

CREATE TABLE Laenutus (
LaenutusID INT IDENTITY(1,1) PRIMARY KEY,
RaamatID INT FOREIGN KEY REFERENCES Raamat(RaamatID),
LaenutajaNimi NVARCHAR(100),
LaenutuseKuup�ev DATE
);
CREATE TABLE logi (
LogiID INT IDENTITY(1,1) PRIMARY KEY,
Kasutaja NVARCHAR(50),
Kuupaev DATETIME DEFAULT GETDATE(),
Tegevus NVARCHAR(50),
Andmed NVARCHAR(MAX)
);


GRANT SELECT, INSERT ON Autor TO opilaneNimi;
GRANT SELECT, INSERT ON Raamat TO opilaneNimi;
GRANT SELECT, INSERT ON Laenutus TO opilaneNimi;

CREATE TRIGGER trg_Raamat_Delete
ON Raamat
AFTER DELETE
AS
BEGIN
INSERT INTO logi (Kasutaja, Tegevus, Andmed)
SELECT SYSTEM_USER, 'DELETE', CONCAT('Kustutatud raamat ID=', d.RaamatID, ', Pealkiri=', d.Pealkiri)
FROM deleted d;
END;

CREATE TRIGGER Raamat_Insert
ON Raamat
AFTER INSERT
AS
BEGIN
INSERT INTO logi (Kasutaja, Tegevus, Andmed)
SELECT SYSTEM_USER, 'INSERT', CONCAT('Lisatud raamat: ', i.Pealkiri, ', AutorID=', i.AutorID)
FROM inserted i;
END;

CREATE TRIGGER Autor_Log
ON Autor
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

INSERT INTO logi (Tegevus, Andmed)
SELECT 'INSERT', 
CONCAT('AutorID=', i.AutorID, ', AutorNimi=', i.AutorNimi, ', Riik=', i.Riik)
FROM inserted i;


INSERT INTO logi (Tegevus, Andmed)
SELECT 'UPDATE', 
CONCAT('VanaAutorID=', d.AutorID, ', VanaNimi=', d.AutorNimi, 
' | UusNimi=', i.AutorNimi, ', Riik=', i.Riik)
FROM deleted d
JOIN inserted i ON d.AutorID = i.AutorID;

 
INSERT INTO logi (Tegevus, Andmed)
SELECT 'DELETE', 
CONCAT('Kustutatud AutorID=', d.AutorID, ', Nimi=', d.AutorNimi)
FROM deleted d;
END;


CREATE TRIGGER Raamat_Log
ON Raamat
AFTER INSERT, DELETE
AS
BEGIN

    INSERT INTO logi (Kasutaja, Kuupaev, Tegevus, Andmed)
    SELECT 
        SYSTEM_USER,        
        GETDATE(),            
        'INSERT', 
        CONCAT('RaamatID=', i.RaamatID, 
               ', Pealkiri=', i.Pealkiri, 
               ', Autor=', a.AutorNimi)
    FROM inserted i
    JOIN Autor a ON i.AutorID = a.AutorID;


    INSERT INTO logi (Kasutaja, Kuupaev, Tegevus, Andmed)
    SELECT 
        SYSTEM_USER,
        GETDATE(),
        'DELETE', 
        CONCAT('Kustutatud RaamatID=', d.RaamatID, 
               ', Pealkiri=', d.Pealkiri,
               ', Autor=', a.AutorNimi)
    FROM deleted d
    JOIN Autor a ON d.AutorID = a.AutorID;
END;

drop trigger raamat_log

select * from autor

CREATE TRIGGER _Laenutus_Log
ON Laenutus
AFTER INSERT, UPDATE, DELETE
AS
BEGIN


INSERT INTO logi (Tegevus, Andmed)
SELECT 'INSERT', 
CONCAT('LaenutusID=', i.LaenetusID, ', RaamatID=', i.RaamatID, 
', Laenutaja=', i.LaenutajaNimi, ', Kuup�ev=', i.LaenutuseKuup�ev)
FROM inserted i;

INSERT INTO logi (Tegevus, Andmed)
SELECT 'UPDATE', 
CONCAT('VanaRaamatID=', d.RaamatID, ', UusRaamatID=', i.RaamatID,
', Laenutaja=', i.LaenutajaNimi)
FROM deleted d
JOIN inserted i ON d.LaenetusID = i.LaenetusID;

INSERT INTO logi (Tegevus, Andmed)
SELECT 'DELETE',,
CONCAT('Kustutatud LaenutusID=', d.LaenetusID, ', RaamatID=', d.RaamatID,
', Laenutaja=', d.LaenutajaNimi)
    FROM deleted d;
END;

DENY UPDATE, DELETE ON Autor TO opilaneNimi;
DENY UPDATE, DELETE ON Raamat TO opilaneNimi;
DENY UPDATE, DELETE ON Laenutus TO opilaneNimi;
DENY CREATE TABLE TO opilaneNimi;


CREATE PROCEDURE RaamatudAutoriJargi
    @AutorNimi NVARCHAR(100)
AS
BEGIN
SELECT r.RaamatID, r.Pealkiri, r.Lehek�lgedeArv
FROM Raamat r
JOIN Autor a ON r.AutorID = a.AutorID
WHERE a.AutorNimi = @AutorNimi;
END;

EXEC RaamatudAutoriJargi @AutorNimi = 'George Orwell';

insert into raamat(Pealkiri,Lehek�lgedeArv,AutorID)
values(1955, 222, 2)

select * from autor

delete from autor
where AutorID=6

BEGIN TRANSACTION;


SAVE TRAN savepoint;

INSERT INTO Raamat (Pealkiri,Lehek�lgedeArv) VALUES ('P�lev lipp', 290);


ROLLBACK TRAN savepoint;

COMMIT TRAN;

select * from raamat

--vaade �hendab kolm tabelit ja kuvab kiiresti, kes millist raamatut laenas ja kes on selle autor
--see on kasulik n�iteks raamatukogut��tajale, kes tahab n�ha k�ik lihtsalt ja kiiresti
CREATE VIEW Vaade_Laenutused AS
SELECT l.LaenetusID, l.LaenutuseKuup�ev,
l.LaenutajaNimi, r.Pealkiri, a.AutorNimi
FROM Laenutus l
JOIN Raamat r ON l.RaamatID = r.RaamatID
JOIN Autor a ON r.AutorID = a.AutorID;

select * from vaade_Laenutus

select * from logi

