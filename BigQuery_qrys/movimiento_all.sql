    
    select * 
from (select *,'movimiento' as tblSource from `mx-herdez-analytics.sethdzqa.movimiento` 
union all select *,'hist_movimiento' as tblSource from `mx-herdez-analytics.sethdzqa.hist_movimiento` 
union all select *,'hist_solicitud' as tblSource from `mx-herdez-analytics.sethdzqa.hist_solicitud` ) m 