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
4.6),


--tabeli kustutamine
--drop table opilane;
delete from opilane where opilaneiId=2
select * from opilane;

--andmete uuendamine
UPDATE opilane SET aadress='Tallinn'
WHERE opilaneiId=3
