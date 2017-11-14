select 
zf.no_empresa,
hm.no_empresa,
upper(dt.nom_arch ) nom_arch
, dt.id_chequera as cta_otorgante_txt
, dt.id_banco_benef as id_banco_benef_txt
, dt.id_chequera_benef cta_beneficiario_txt
, hm.id_chequera as id_banco_otorgante_movimiento
, hm.id_chequera_benef as id_banco_benef_movimiento
,hm.solicita
,u.id_usuario_seg usrSolicita
,u.nombre +' ' +u.paterno + ' '+u.materno usrSolicitaNombre
,hm.autoriza
,u2.nombre +' ' +u2.paterno + ' '+u2.materno usrAutorizaNombre
, COALESCE(cb.id_chequeraR10 ,'NO MATCH EN CATALOGO CTAS_BANCO') id_chequeraR10
, dt.beneficiario
, COALESCE(cb.id_clabe,'NO MATCH EN CATALOGO CTAS_BANCO')id_clabe
, hm.no_docto
,zf.banco_pagador
,p.equivale_persona
,p.no_persona
,p.nombre_largo
,p.razon_social
, zf.no_doc_sap
, zf.contra_rec
, zf.no_factura
, hm.fec_valor
,zf.fec_propuesta as fec_propuesta_zf
,hm.fec_propuesta as fec_propuesta_hm
, hm.id_forma_pago
, fp.desc_forma_pago
, hm.id_tipo_operacion
, tiop.desc_tipo_operacion
, hm.origen_mov
, om.desc_origen_mov
,sta.clasificacion movimiento
,sta.desc_estatus estatus_movimiento
,hm.no_folio_mov
,SUM(hm.importe) importe_movimiento
,SUM(hm.importe) importe_movimiento_original
,sum(zf.importe) importe_zf
--, count(dt.id_banco) cuenta_registros
, SUM(dt.importe) as Importe_que_Exporta_A_txt
--into lrs..fact_files_from_set
--drop table lrs..fact_files_from_set
from sethdzqa..det_arch_transfer dt
LEFT join (select * from sethdzqa..hist_movimiento  union all select * from sethdzqa..movimiento ) hm 
	ON  dt.no_folio_det  = hm.no_folio_det 
LEFT join sethdzqa..persona p 
	ON cast(hm.no_cliente as varchar(15))= cast(p.no_persona as varchar(15)) /* se agrega cast porque hay cuentas 552AM01015 */
LEFT join (
				select     no_empresa,no_persona,id_banco,id_clabe ,RIGHT(id_chequera,10)as id_chequeraR10
				from sethdzqa..ctas_banco 
				group by  no_empresa,no_persona,id_banco,id_clabe ,RIGHT(id_chequera,10)
		   ) cb  /* 26 -10-2017 se agrega porque se detecta duplicidad de  cuentas  1142437791  mismo banco, misma persona, id_chequera con o sin ceros*/
	ON   cb.no_persona=p.no_persona 
	AND  cast(hm.no_cliente as varchar(15))= cast(p.no_persona as varchar(15))
	AND  RIGHT(hm.id_chequera_benef,10) = cb.id_chequeraR10
	AND hm.id_banco_benef= cb.id_banco  /* se agrega union con banco porque en catalogo hay una cuenta repetida pero para diferente banco y la cuenta  clabe es diferente */
left join sethdzqa..zimp_fact zf 
	on hm.no_docto=zf.no_doc_sap  and zf.no_benef=p.equivale_persona
	--and hm.no_empresa	= zf.no_empresa /* 26-10-2017 12p.m. se comenta ésta liga que viene del excel el numero docto 009636233 con su atributo empresa no hace match  tabla movimiento vs zimp_fact */
left join sethdzqa..SET006 st on hm.no_empresa=st.SETEMP and st.SISCOD='CP' /*  1 p.m. 26-10-2017 Salió de la union entre zimp_fact y movimiento, ya que no unia la empresa   */
and st.SOIEMP=zf.no_empresa
left join sethdzqa..cat_forma_pago fp on hm.id_forma_pago=fp.id_forma_pago
left join sethdzqa..cat_tipo_operacion tiop on hm.id_tipo_operacion=tiop.id_tipo_operacion
left join sethdzqa..cat_origen_mov om on hm.origen_mov= om.origen_mov
left join sethdzqa..cat_estatus sta on hm.id_estatus_mov = sta.id_estatus and sta.clasificacion='MOV'
left join sethdzqa..cat_usuario u on hm.solicita=u.no_usuario
left join sethdzqa..cat_usuario u2 on u2.id_usuario_seg=hm.autoriza
WHERE 1=1
--AND dt.nom_arch = 'BC216649' 
--AND  dt.nom_arch = 'BC123713'
--and hm.no_docto='009636233' 
--AND  dt.nom_arch = 'BC131966'  
AND dt.id_banco = 12 --BANCOMER
AND dt.id_estatus_arch IN ('T','R')  /* T=Transaccion ,R=Regenerado, X=Cancelado*/
and year(dt.fec_valor)=2017
and month(dt.fec_valor)=9
AND DAY(dt.fec_valor) IN (5)
--AND cb.id_clabe is null
GROUP BY 
  dt.nom_arch 
, dt.id_chequera 
, dt.id_banco_benef
, dt.id_chequera_benef 
, dt.beneficiario
, COALESCE(cb.id_clabe,'NO MATCH EN CATALOGO CTAS_BANCO')
, hm.id_chequera_benef 
, COALESCE(cb.id_chequeraR10 ,'NO MATCH EN CATALOGO CTAS_BANCO') 
, hm.no_docto
, zf.no_doc_sap
, zf.contra_rec
, zf.no_factura
, hm.fec_valor
, hm.id_forma_pago
, fp.desc_forma_pago
, tiop.desc_tipo_operacion
, om.desc_origen_mov
, sta.clasificacion
, sta.desc_estatus
, hm.id_tipo_operacion
, hm.origen_mov
, zf.fec_fact
,hm.no_folio_mov
,hm.solicita
,hm.autoriza
, hm.id_chequera 
,zf.banco_pagador
,p.equivale_persona
,p.no_persona
,p.nombre_largo
,p.razon_social
,u.id_usuario_seg 
,u.nombre +' ' +u.paterno + ' '+u.materno
,u2.nombre +' ' +u2.paterno + ' '+u2.materno
,zf.fec_propuesta
,hm.fec_propuesta
,zf.no_empresa,
hm.no_empresa
ORDER BY cb.id_clabe

