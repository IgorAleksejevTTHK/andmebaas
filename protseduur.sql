--sql salvestatud protseduur - funktsioon, mis käivitab serveris mitu SQL tegevust jarjest
--kasutame SQL server


Create database protseduurAleksejev;
use protseduurAleksejev;
create table linn(
LinnId int primary key identity(1,1),
LinnNimi varchar(30),
rahvaArv int);
select * from linn;
insert into linn(LinnNimi, rahvaArv)
Values ('Kohtla-Jarve', 25000)
--- protseduuri loomine
-- protseduur mis lisab uus linn ja kohe näitab tabelis

create procedure lisaLinn
@lnimi varchar(30),
@rArv int
AS
BEGIN

INSERT INTO linn(LinnNimi, rahvaArv)
values (@lnimi, @rArv)
select * from linn;

END;

--protseduuri kutse
exec lisaLinn @lnimi='Tartu', @rArv=1256
--kirje kustutamine
delete from Linn WHERE linnID=6
--protseduur, mis justutuab linn id järgi


Create procedure kustutaLinn
@deleteId int

as 

begin

select * from linn;
delete from Linn WHERE linnID=@deleteId;
select * from linn;

end

--KUTSE
exec kustutaLinn 4;
--proceduri kustutamine
drop procedure kustutaLinn;

--protseduur mis otsib linn esimese tähte järgi
create procedure linnaotsing
@taht char(1)
AS
BEGIN
SELECT * FROM linn
where LinnNimi like @taht + '%';
--& - kõik teised tahed
END;

--kutse
exec linnaotsing T;
