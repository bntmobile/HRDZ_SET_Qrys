select forma_pago,  fec_venc_docto ,fec_valor, secuencia
from zimp_fact WHERE fec_valor like '%2017'
and forma_pago in (7,6)
group by forma_pago,  fec_venc_docto ,fec_valor, secuencia
order by 2


select forma_pago,  no_factura
from zimp_fact WHERE fec_valor like '%2017'
and forma_pago  in (1,3,5,6,8)
AND origen='AS4'
group by forma_pago, no_factura
order by 2

select * 
from zimp_fact WHERE fec_valor like '%2017'
and forma_pago  in (1,3,5,6,8)
AND origen='AS4'
and causa_rech ='RECHAZO ENVIADO AL AS400'
and no_doc_sap='009559658' 

select top 10 * from zexp_fact where no_doc_sap='009559658' 
select * from zimp_fact WHERE no_benef  ='06619' 
select * from zexp_fact where no_persona ='06619'
select * from persona where equivale_persona ='06619'  
select * from movimiento where no_cliente in (select no_persona from persona where equivale_persona ='06619' )
select * from hist_movimiento where no_cliente in (select no_persona from persona where equivale_persona ='06619' )     
  

select * from movimiento where no_docto in (select no_doc_sap from zimp_fact WHERE no_benef  ='06619' )

select * from movimiento where no_docto='009559658' 
select * from hist_movimiento where no_docto='009559658' 



SELECT 
zf.no_empresa as no_empresa_zf,
s6.SETEMP no_empresa_s6,
s6.SOIEMP as no_empresa_s6_,
s6.SISCOD,
hm.no_empresa as no_empresa_hm,
zf.*,
hm.* 
FROM zimp_fact zf
INNER JOIN (select * from movimiento union all select * from hist_movimiento) hm  
		ON      zf.no_doc_sap=hm.no_docto
INNER JOIN seleccion_automatica_grupo  sag 
		ON      hm.cve_control=sag.cve_control 
			and zf.no_doc_sap=hm.no_docto
INNER JOIN SET006 s6 
		ON		s6.SETEMP=zf.no_empresa 
		and		s6.SOIEMP=hm.no_empresa 
		and		s6.SISCOD='CP'
WHERE 1=1
--AND zf.estatus='R'
AND year(convert(date,zf.fec_valor,103))=2017 --AND convert(date,zf.fec_valor,103)='2017-10-02'
--AND month(convert(date,zf.fec_valor,103))=10
AND zf.forma_pago  IN (1,3,5,6,8)
AND zf.origen='AS4'
order by hm.id_forma_pago









