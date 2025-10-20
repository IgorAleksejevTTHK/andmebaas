create database aleksejevSport


CREATE TABLE Sport (
SportID INT IDENTITY(1,1) PRIMARY KEY,
Nimi VARCHAR(40)
);

CREATE TABLE Medal (
MedalID INT IDENTITY(1,1) PRIMARY KEY,
MedalTyyP VARCHAR(20)
);

CREATE TABLE Sportlane (
SportlaneID INT IDENTITY(1,1) PRIMARY KEY,
Eesnimi VARCHAR(40),
Synniaeg DATE,
Riik VARCHAR(40),
Syndmus VARCHAR(20)
);

CREATE TABLE Meeskond (
MeeskondID INT IDENTITY(1,1) PRIMARY KEY,
Nimi VARCHAR(40),
Riik VARCHAR(40)
);

CREATE TABLE Kohtunik (
KohtunikID INT IDENTITY(1,1) PRIMARY KEY,
Eesnimi VARCHAR(40),
Perenimi VARCHAR(40),
SportID INT FOREIGN KEY REFERENCES Sport(SportID),
Riik VARCHAR(40)
);

CREATE TABLE Voistlus (
VoistlusID INT IDENTITY(1,1) PRIMARY KEY,
Asukoht VARCHAR(50),
Kuupaev DATE,
SportID INT FOREIGN KEY REFERENCES Sport(SportID)
);

CREATE TABLE SportlaseMeeskond (
SportlaseMeeskondID INT IDENTITY(1,1) PRIMARY KEY,
SportlaneID INT FOREIGN KEY REFERENCES Sportlane(SportlaneID),
MeeskondID INT FOREIGN KEY REFERENCES Meeskond(MeeskondID)
);

CREATE TABLE TulemusSportlane (
TulemusSportlaneID INT IDENTITY(1,1) PRIMARY KEY,
SportlaneID INT FOREIGN KEY REFERENCES Sportlane(SportlaneID),
Tulemus INT,
MedalID INT FOREIGN KEY REFERENCES Medal(MedalID),
KohtunikID INT FOREIGN KEY REFERENCES Kohtunik(KohtunikID)
);

CREATE TABLE TulemusMeeskond (
TulemusSportlaneID INT IDENTITY(1,1) PRIMARY KEY,
MeeskondID INT FOREIGN KEY REFERENCES Meeskond(MeeskondID),
Tulemus INT,
MedalID INT FOREIGN KEY REFERENCES Medal(MedalID),
KohtunikID INT FOREIGN KEY REFERENCES Kohtunik(KohtunikID)
);

CREATE TABLE Distsipliin (
DistsipliinID INT IDENTITY(1,1) PRIMARY KEY,
Nimi VARCHAR(50),
SportID INT FOREIGN KEY REFERENCES Sport(SportID)
);

CREATE TABLE Treener (
TreenerID INT IDENTITY(1,1) PRIMARY KEY,
Eesnimi VARCHAR(40),
Perenimi VARCHAR(40),
Riik VARCHAR(40),
MeeskondID INT FOREIGN KEY REFERENCES Meeskond(MeeskondID)
);

CREATE TABLE logi (
  logiID INT IDENTITY(1,1) PRIMARY KEY,
  toiming VARCHAR(20),
  andmed VARCHAR(255),
  kasutaja VARCHAR(100),
  kuupäev DATETIME DEFAULT GETDATE()
);


--insert
CREATE TRIGGER SportlaseMeeskond_Insert
ON SportlaseMeeskond
AFTER INSERT
AS
BEGIN
INSERT INTO logi (toiming, andmed, kasutaja)
SELECT 'INSERT', 'Sportlane: ' 
+ s.Eesnimi + ', Meeskond: ' + m.Nimi,
SYSTEM_USER
FROM inserted i
INNER JOIN Sportlane s ON i.SportlaneID = s.SportlaneID
INNER JOIN Meeskond m ON i.MeeskondID = m.MeeskondID;
END

--delete
CREATE TRIGGER SportlaseMeeskond_Delete
ON SportlaseMeeskond
AFTER DELETE
AS
BEGIN
INSERT INTO logi (toiming, andmed, kasutaja)
SELECT 'DELETE', 'Sportlane: '
+ s.Eesnimi + ', Meeskond: ' + m.Nimi,
SYSTEM_USER
FROM deleted d
INNER JOIN Sportlane s ON d.SportlaneID = s.SportlaneID
INNER JOIN Meeskond m ON d.MeeskondID = m.MeeskondID;
END


-- update
CREATE TRIGGER SportlaseMeeskond_Update
ON SportlaseMeeskond
AFTER UPDATE
AS
BEGIN
INSERT INTO logi (toiming, andmed, kasutaja)
SELECT 
'UPDATE',
'Old Sportlane: ' + s_old.Eesnimi + ', Old Meeskond: ' + m_old.Nimi +
'; New Sportlane: ' + s_new.Eesnimi + ', New Meeskond: ' + m_new.Nimi,
SYSTEM_USER
FROM deleted d
INNER JOIN inserted i ON d.SportlaseMeeskondID = i.SportlaseMeeskondID
INNER JOIN Sportlane s_old ON d.SportlaneID = s_old.SportlaneID
INNER JOIN Meeskond m_old ON d.MeeskondID = m_old.MeeskondID
INNER JOIN Sportlane s_new ON i.SportlaneID = s_new.SportlaneID
INNER JOIN Meeskond m_new ON i.MeeskondID = m_new.MeeskondID;
END

DENY SELECT ON OBJECT::dbo.logi TO [admin];
