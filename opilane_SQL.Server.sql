--ab loomine
Create database AleksejevBaas;

use AleksejevBaas;
CREATE TABLE opilane(
opilaneiId int primary key identity(1,1),
eesnimi varchar(25) not null,
perenimi varchar(25) not null,
synniaeg date,
stip bit,
aadress text,
keskmine_hinne decimal(2,1)
)
select * from opilane;
--andmete lisamine tabelisse
INSERT INTO opilane(
eesnimi,
perenimi,
synniaeg,
stip,
keskmine_hinne)
VALUES(
'Nikita',
'Nikita',
'2000-12-12',
1,
4.5),
(
'Eldar',
'Albia',
'2001-12-14',
1,
4.2),
(
'Dima',
'Lolka',
'2011-11-10',
1,
3.2),
(
'Bober',
'Den',
'2001-12-14',
1,
4.6)


--tabeli kustutamine
--drop table opilane;
delete from opilane where opilaneiId=2
select * from opilane;

--andmete uuendamine
UPDATE opilane SET aadress='Tallinn'
WHERE opilaneiId=7

CREATE TABLE Language
(
ID int NOT NULL PRIMARY KEY,
Code char(3) NOT NULL,
Language varchar(50) NOT NULL,
IsOfficial bit,
Percentage smallint
);
select * from Language

INSERT INTO Language(ID, Code, Language)
values (2, 'RUS', 'vene'), (3, 'ENG', 'inglise'),
(4, 'DE', 'saksa')

Create table keeleValik(
keeleValikID int primary key identity(1,1),
valikuNimetus varchar(10) not null,
opilaneiId INT,
fOREIGN KEY (opilaneiId) REFERENCES opilane(opilaneiId),
Language int,
Foreign key (Language) references Language(ID)
)
select * from keelevalik;
select * from Language;
select * from opilane;

insert into keeleValik(valikuNimetus, opilaneiId, Language)
Values ('valik A', 1, 2)

select opilane.eesnimi, Language.Language
from opilane, Language, keeleValik
where opilane.opilaneiId=keeleValik.opilaneiId
AND Language.ID=keelevalik.Language

select * from opilane, Language, keeleValik
where opilane.opilaneiId=keeleValik.opilaneiId
AND Language.ID=keelevalik.Language


Create table oppimine(
oppimineid int primary key identity(1,1),
aine varchar(10),
aasta int,
opetaja char(5),
hinne int,
opilaneiId int,
foreign key (opilaneiId) references opilane(opilaneiId)
)
insert into opilane(aine, aasta, opetaja, hinne, opilaneiId)
Values ('Ajalugu', 2007, 'Irina', 5, 1)
