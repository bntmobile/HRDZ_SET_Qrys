select 
  zf.no_doc_sap as no_doc_zf
, zf.no_factura as no_fact_zf
, zf.no_benef
, zf.no_empresa no_empresa_zf
, hm.no_docto as no_doc_hm
, hm.no_factura
, hm.no_empresa as no_empresa_hm
, hm.id_estatus_mov  -- 31-10-2017 K,T = PAGADO Cuando es una transferencia// pero cuando es un cheque R= reimpresion, i = Impreso
, case  when hm.id_forma_pago=3  and  hm.id_estatus_mov in ('K','T')  then 'PAGADO'
		when hm.id_forma_pago=1  and  hm.id_estatus_mov in ('R','I')  then 'PAGADO'
		ELSE 'REVISAR'
END  as estatus 
, om.desc_origen_mov
, cvop.desc_cve_operacion
, tp.desc_tipo_operacion 
, fp.desc_forma_pago
, st.desc_estatus
, s6.SOIEMP as mepeo_empresa_movimiento_empresa_zf_s6
, hm.no_cliente
, p.no_persona no_persona_p
, p.razon_social
, p.equivale_persona
, dt.nom_arch
, sum(zf.importe) as importe_zf
, sum(hm.importe) as importe_hm
,sum(dt.importe) as importetxt
from sethdzqa..zimp_fact zf  
left join (select * from sethdzqa..hist_movimiento  union all select * from sethdzqa..movimiento ) hm  
				on      zf.no_doc_sap=hm.no_docto 
					--and zf.no_factura=hm.no_factura // NO SE DEBE COLOCAR
left  join persona p on p.no_persona=hm.no_cliente
left join SET006 s6 on s6.SISCOD='CP' and hm.no_empresa=s6.SETEMP AND S6.SOIEMP=zf.no_empresa  -- CASO PELICUAR CON HM.NO_EMPRESA=33 NO HACE MATCH EN EL CATALOGO
left join (
				select     no_empresa,no_persona,id_banco,id_clabe ,RIGHT(id_chequera,10)as id_chequeraR10
				from sethdzqa..ctas_banco 
				group by  no_empresa,no_persona,id_banco,id_clabe ,RIGHT(id_chequera,10)
		   ) cb  ON   cb.no_persona=p.no_persona 
	AND  cast(hm.no_cliente as varchar(15))= cast(p.no_persona as varchar(15))
	AND  RIGHT(hm.id_chequera_benef,10) = cb.id_chequeraR10
	AND hm.id_banco_benef= cb.id_banco
left join sethdzqa..cat_forma_pago fp on hm.id_forma_pago=fp.id_forma_pago 
left join sethdzqa..cat_estatus st on hm.id_estatus_mov=st.id_estatus and st.clasificacion='MOV' -- TABLA MOVIMIENTOS
left join sethdzqa..cat_tipo_operacion tp on hm.id_tipo_operacion=tp.id_tipo_operacion
left join sethdzqa..cat_origen_mov om on hm.origen_mov=om.origen_mov
left join sethdzqa..cat_cve_operacion cvop on hm.id_cve_operacion= cvop.id_cve_operacion
left join det_arch_transfer dt on dt.no_folio_det=hm.no_folio_det
where 1=1
and hm.id_forma_pago in (1,3)
and year(hm.fec_valor)=2017
group by zf.no_doc_sap 
 ,zf.no_factura 
, zf.no_benef
, hm.no_docto 
, hm.no_factura
, hm.no_cliente
, p.no_persona 
, p.razon_social
, p.equivale_persona
, dt.nom_arch
, zf.no_empresa 
, hm.no_empresa 
, s6.SOIEMP
, s6.SETEMP
,st.desc_estatus
, fp.desc_forma_pago
,tp.desc_tipo_operacion 
,om.desc_origen_mov
,cvop.desc_cve_operacion
,hm.id_estatus_mov  -- 31-10-2017 K,T = PAGADO Cuando es una transferencia// pero cuando es un cheque R= reimpresion, i = Impreso
, case  when hm.id_forma_pago=3  and  hm.id_estatus_mov in ('K','T')  then 'PAGADO'
		when hm.id_forma_pago=1  and  hm.id_estatus_mov in ('R','I')  then 'PAGADO'
		ELSE 'REVISAR'
END 





SELECT COUNT(1) 
FROM (select * from sethdzqa..hist_movimiento  union all select * from sethdzqa..movimiento ) hm  
--WHERE  hm.id_forma_pago in (1,3)and year(hm.fec_valor)=2017
2579418
SELECT COUNT(1) FROM zimp_fact
2579418


select hm.no_empresa
,hm.id_forma_pago
, fp.desc_forma_pago
, YEAR(hm.fec_valor)fec_valor
,hm.id_estatus_mov  -- 31-10-2017 K,T = PAGADO Cuando es una transferencia// pero cuando es un cheque R= reimpresion, i = Impreso
, case  when hm.id_forma_pago=3  and  hm.id_estatus_mov in ('K','t')  then 'PAGADO'
		when hm.id_forma_pago=1  and  hm.id_estatus_mov in ('R','I')  then 'PAGADO'
		ELSE 'REVISAR'
END  as estatus 
,st.desc_estatus
,tp.desc_tipo_operacion 
,hm.origen_mov
,hm.no_docto
,om.desc_origen_mov
,cvop.desc_cve_operacion
,count( hm.id_chequera)cuenta
 from 
 sethdzqa..zimp_fact zf 	
left join (select * from sethdzqa..hist_movimiento  union all select * from sethdzqa..movimiento ) hm   on  zf.no_doc_sap=hm.no_docto 
left join sethdzqa..cat_forma_pago fp on hm.id_forma_pago=fp.id_forma_pago 
left join sethdzqa..cat_estatus st on hm.id_estatus_mov=st.id_estatus and st.clasificacion='MOV' -- TABLA MOVIMIENTOS
left join sethdzqa..cat_tipo_operacion tp on hm.id_tipo_operacion=tp.id_tipo_operacion
left join sethdzqa..cat_origen_mov om on hm.origen_mov=om.origen_mov
left join sethdzqa..cat_cve_operacion cvop on hm.id_cve_operacion= cvop.id_cve_operacion
where   hm.no_folio_det in (  2660913,2660952,2660960)
group by hm.id_forma_pago, fp.desc_forma_pago,YEAR(hm.fec_valor),st.desc_estatus,tp.desc_tipo_operacion,hm.origen_mov,om.desc_origen_mov
,cvop.desc_cve_operacion
,hm.no_empresa
,hm.no_docto
,hm.id_estatus_mov
, case  when hm.id_forma_pago=3  and  hm.id_estatus_mov in ('K','t')  then 'PAGADO'
		when hm.id_forma_pago=1  and  hm.id_estatus_mov in ('R','I')  then 'PAGADO'
		ELSE 'REVISAR'
END
order by 3



