select 
  zf.forma_pago
, fp.desc_forma_pago
,zf.no_benef 
,zf.no_prov_as400
, COUNT(1)cuenta
, SUM(zf.importe)importe_zf
, SUM(dp.importe) importe_dp
, zf.origen
from zimp_fact zf 
left  join cat_forma_pago fp on zf.forma_pago=fp.id_forma_pago
left join detalle_pago_as400 dp on zf.no_doc_sap=dp.no_doc_sap
where 1=1
and zf.origen='AS4'
and zf.forma_pago=6
group by 
  zf.forma_pago
, fp.desc_forma_pago
, zf.origen
,zf.no_benef
,zf.no_prov_as400

order by 3 desc

select top 10 *  from zimp_fact zf





--no_empresa
--no_doc_sap <- consecutivo de as400
--no_factura en éste campo cuando vienen de AS400 se coloca el texto "TOTAL" de aquellos formas de pago diferente a Factoraje (7), si se necesita revisar el número de factura de los doctos Total es necesario regresar a la tabla detalle_pago_as400  zf.no_empresa=dp.no_empresa y  zf.no_doc_sap=no_docto
--fec_valor <- fecha de pago la pone as400 de acuerdo al plazo de pago
--importe <- depende de la divisa
--id_divisa<- divisa original no transformada
--origen <- de donde viene AS4 sie es 400
--fec_propuesta <- POR LO REGULAR ES LA MISMA DE fec_valor si esta fecha es sabado o domingo esta fecha se incrementa en 1 para ser lunes, día habil



--select * from zimp_fact where no_doc_sap='009170268'
--select * from  detalle_pago_as400  where no_doc_sap= '009170268'

--select no_doc_sap, count(1) f
--from detalle_pago_as400 
--group by no_doc_sap
--having count(1)=1


