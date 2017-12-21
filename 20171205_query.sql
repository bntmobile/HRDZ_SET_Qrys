select   
  m.id_banco_ant
, m.id_chequera_ant 
from 
(select * from movimiento union all select * from hist_movimiento)m
where 1=1
and m.id_forma_pago=3
and m.id_banco_ant is null
group by   m.id_banco_ant
, m.id_chequera_ant 


select COUNT(m.1)
 --m.*, year(m.fec_valor)anio, month(m.fec_valor) mes
from 
(select * from movimiento union all select * from hist_movimiento)m
inner join seleccion_automatica_grupo sag on m.cve_control=sag.cve_control
where 1=1
and m.id_forma_pago=3
and year(m.fec_valor) in (2016,2017)
and m.id_banco_ant is null


select COUNT(1)
from 
(select * from movimiento union all select * from hist_movimiento)m
inner join seleccion_automatica_grupo sag on m.cve_control=sag.cve_control
where 1=1
and m.id_forma_pago=3
and year(m.fec_valor) in (2016,2017)


--151,144



select m.id_estatus_mov,e.desc_estatus, COUNT(1)
from 
(select * from movimiento union all select * from hist_movimiento)m
inner join seleccion_automatica_grupo sag on m.cve_control=sag.cve_control
inner join cat_estatus e on m.id_estatus_mov=e.id_estatus and e.clasificacion='MOV'
where 1=1
and m.id_forma_pago=3
and year(m.fec_valor) in (2016,2017)
group by m.id_estatus_mov,e.desc_estatus
