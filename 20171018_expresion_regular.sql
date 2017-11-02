--99999999999999999999
select 
cast(id_chequera as numeric(25,0))
,

  id_chequera
from ctas_banco
where id_chequera NOT like '%[A-Z]%'
order by id_chequera


SELECT * from ctas_banco where id_chequera NOT like '%[A-Z]%' OR id_chequera NOT like '%[a-z]%'

SELECT * 
from sethdzqa..ctas_banco 
where id_chequera  like '%[A-Z]%' 
OR id_chequera  like '%[a-z]%'
or  id_chequera  like '%[,.-_]%'
or  id_chequera  like '%[Ò—]%'
