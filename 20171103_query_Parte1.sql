select 
zf.forma_pago
,fp.desc_forma_pago  
, COUNT(1)cuenta
,SUM(zf.importe)importe
--, zf.no_factura
, origen
from zimp_fact zf 
inner join cat_forma_pago fp on zf.forma_pago=fp.id_forma_pago
--where origen='AS4'
group by 
 zf.forma_pago
--,zf.no_factura
,fp.desc_forma_pago
, origen
order by 3 desc,4




no_empresa
no_doc_sap <- consecutivo de as400
no_factura en éste campo cuando vienen de AS400 se coloca el texto "TOTAL" de aquellos formas de pago diferente a Factoraje (7), si se necesita revisar el número de factura de los doctos Total es necesario regresar a la tabla detalle_pago_as400  zf.no_empresa=dp.no_empresa y  zf.no_doc_sap=no_docto
fec_valor <- fecha de pago la pone as400 de acuerdo al plazo de pago
importe <- depende de la divisa
id_divisa<- divisa original no transformada
origen <- de donde viene AS4 sie es 400
fec_propuesta <- POR LO REGULAR ES LA MISMA DE fec_valor si esta fecha es sabado o domingo esta fecha se incrementa en 1 para ser lunes, día habil



