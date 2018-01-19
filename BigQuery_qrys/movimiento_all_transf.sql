select * 
from (select *,'movimiento' as tblSource from `mx-herdez-analytics.sethdzqa.movimiento` 
union all select *,'hist_movimiento' as tblSource from `mx-herdez-analytics.sethdzqa.hist_movimiento` 
union all select *,'hist_solicitud' as tblSource from `mx-herdez-analytics.sethdzqa.hist_solicitud` ) m 
where 1=1
--and  EXTRACT(YEAR FROM  m.fec_valor)>=2016
--and m.id_forma_pago in (3,7)
and m.id_forma_pago in (3)
--and m.origen_mov in ('AS4','CVT')-- se agrega al filtro CVT - compra venta de transfer 14:34 p.m. de detectó que el movimiento 3200
--and m.origen_mov in ('AS4','CVT','COU')