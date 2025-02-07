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

--TAVELI UUENDAMINE rahvaarv kasvab 10 % võrra
update linn set rahvaArv=rahvaArv*1.1
select * from linn;
update linn set rahvaArv=rahvaArv*1.1
where LinnId=2;

create procedure rahvaArvuUendus
@linnId int,
@koef decimal(2,1)
as
begin
update linn set rahvaArv=rahvaArv*@koef
where LinnId=@LinnId;
select * from linn;
end;

exec rahvaArvuUendus 1, 1.2;
select * from linn;
drop procedure rahvaArvuUendus;

------------------------------------------------------------------------------------------------------------------
Kasutama XAMPP / localhost
------------------------------------------------------------------------------------------------------------------
create procedure veeruLisaKustuta
@valik varchar(20),
@veerunimi varchar(20),
@tyyp varchar(20) =null


as
begin
declare @sqltegevus as varchar(max)
set @sqltegevus=case
when @valik='add' then concat('ALTER TABLE linn add ',   @veerunimi, ' ', @tyyp)
when @valik='drop' then concat('ALTER TABLE linn DROP COLUMN ',   @veerunimi)
end;
print @sqltegevus;
begin
EXEC (@sqltegevus);
end
end;

--kutse
EXEC veeruLisaKustuta @valik='add', @veerunimi='test3', @tyyp='int';
select * from linn;

EXEC veeruLisaKustuta @valik='drop', @veerunimi='test3';
select * from linn;


create procedure veeruLisaKustutaTabelis
@valik varchar(20),
@tabelinimi varchar(20),
@veerunimi varchar(20),
@tyyp varchar(20) =null


as
begin
declare @sqltegevus as varchar(max)
set @sqltegevus=case
when @valik='add' then concat(' ALTER TABLE ', @tabelinimi, ' add ' ,  @veerunimi, ' ', @tyyp)
when @valik='drop' then concat(' ALTER TABLE ', @tabelinimi, ' drop column', @veerunimi)
end;
print @sqltegevus;
begin
EXEC (@sqltegevus);
end
end;

--kutse
EXEC veeruLisaKustutaTabelis @valik='add', @tabelinimi='linn', @veerunimi='test3', @tyyp='int';
select * from linn;

EXEC veeruLisaKustutaTabelis @valik='drop', @tabelinimi='linn', @veerunimi='test3';
select * from linn;

--protseduur tingimusega
create procedure rahvaHinnang
@piir int


as
begin
select linnNimi, rahvaArv, iif(rahvaarv<@piir, 'väike linn', 'suur linn') as Hinnang
from linn;


end;
drop procedure rahvaHinnang;
exec rahvaHinnang 2000;

--agregaat funktsioonid: sum(), AVG(),min(),max(),count()

create procedure kokkuRahvaarv

as
begin
select sum(rahvaArv) AS 'kokku rahvaArv', avg(rahvaArv) as 'keskmine rahvaArv', count(*) as 'linnade arv'
from linn;
end;
