select 
 id_chequera
,id_banco
,id_forma_pago
,importe
,importe_original
,id_divisa
,id_divisa_original
,id_banco_benef
,id_chequera_benef
,usuario_modif
,no_cliente
,id_banco_ant
,id_chequera_ant
,origen_mov_ant
,no_cliente_ant
from movimiento
where 1=1
and id_forma_pago=3
and id_estatus_mov in ('T','K')
--and id_chequera_benef=id_chequera_ant
--and id_divisa<>id_divisa_original

--17818

-- 11 registros donde la moneda
