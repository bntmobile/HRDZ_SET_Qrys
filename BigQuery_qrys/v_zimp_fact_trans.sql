select  * 
from  `mx-herdez-analytics.sethdzqa.zimp_fact` 
WHERE forma_pago=3 and estatus='I'
and EXTRACT(YEAR FROM  PARSE_DATE('%d/%m/%Y',  fec_valor))>=2016