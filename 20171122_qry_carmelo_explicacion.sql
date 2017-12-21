select id_forma_pago,id_chequera_benef,id_chequera_ant ,*
from movimiento  
where  1=1
and year(fec_valor) =2017
and id_chequera_benef<>id_chequera_ant


select no_persona,id_banco,id_chequera,id_clabe ,id_divisa
from ctas_banco where no_persona in (
		select no_persona 
		from persona 
		where equivale_persona in (
		'0028635',
		'69463',
		'51768',
		'28359'
		)
	)


/*

ZIMP_FACT

*/
SELECT * FROM zimp_fact  
WHERE no_doc_sap IN (
					SELECT no_docto
					FROM movimiento 
					WHERE no_folio_det IN (
								select no_folio_det from BITACORA_ACT_CHEQUERA  
								WHERE 1=1
								AND  YEAR(fec_modif) IN (2015,2016,2017) 
								AND no_folio_det<>0
					)
	)



/*

MOVIMIENTO

*/

SELECT id_forma_pago,no_docto,id_chequera_benef,id_chequera_ant,id_banco_benef,id_banco_ant,* FROM movimiento 
WHERE no_folio_det IN (
			select no_folio_det from BITACORA_ACT_CHEQUERA  
			WHERE 1=1
			AND  YEAR(fec_modif) IN (2015,2016,2017) 
			AND no_folio_det<>0
)
ORDER BY no_folio_det



/*

BITACORA_ACT_CHEQUERA

*/
select  * 
from BITACORA_ACT_CHEQUERA   
WHERE no_folio_det IN (
			  SELECT no_folio_det 
			  FROM movimiento 
				WHERE no_folio_det IN (
						select no_folio_det from BITACORA_ACT_CHEQUERA  
						WHERE 1=1
						AND  YEAR(fec_modif) IN (2015,2016,2017) 
						AND no_folio_det<>0
						)

)
ORDER BY no_folio_det



select  distinct  id_estatus_trasp from movto_banca_diario

SELECT b_gen_conta,fec_exportacion,* 
FROM movimiento 
WHERE b_gen_conta='S'--
AND fec_exportacion is null -- SIN FECHA DE EXPORTACIÓN
AND id_tipo_operacion=3200 -- AGRUPADORAS
and id_estatus_mov='T'-- NO CONFIRMADAS

SELECT * FROM cat_estatus 
WHERE clasificacion='CON'


SELECT  DISTINCT b_gen_conta
FROM movimiento 


select top 10 * from zexp_fact

select * from movto_banca_diario


select TOP 2 * from movto_banca_e where secuencia=4993518
select  top 2 * from concilia_banco where secuencia=4993518
select  top 2 * from cruce_concilia  where year(fec_alta)=2017 and month(fec_alta) in (5,6,7,8,9,10) and grupo=1746378


select no_docto,id_estatus_mov,cve_control,origen_mov,fec_valor ,* from movimiento where no_folio_det in ( 4967911,4158846)
union all
select  no_docto,id_estatus_mov,cve_control , origen_mov, fec_valor,* from hist_movimiento where no_folio_det in ( 4967911,4158846)


select * from zimp_fact where no_doc_sap in 
(
'517987',
'937174'
)


select * from cat_tipo_operacion where id_tipo_operacion in (3100,3101)
select * from cat_cve_operacion where id_cve_operacion=24


-----------------------------------------------



select * from 
(select * from movimiento
				union all
				select * from hist_movimiento
				) m_all
where 1=1
and  id_estatus_mov='K'
and id_forma_pago=3
and no_folio_det in (5784481, 5212861)
and no_folio_det in ( 
select  no_folio_1 from cruce_concilia  where year(fec_alta)=2017 and month(fec_alta)= 10
)

--select * from movimiento where no_folio_det=5212861

--5784481

select  *from cruce_concilia  where year(fec_alta)=2017 and month(fec_alta) in (10) and no_folio_1=5784481

--select  *from cruce_concilia  where year(fec_alta)=2017 and month(fec_alta) in (10) and no_folio_2=5784481


select  * from movto_banca_e where secuencia=5212861
select  top 2 * from concilia_banco where secuencia=5212861
select  top 2 * from cruce_concilia  where year(fec_alta)=2017 and month(fec_alta) in (5,6,7,8,9,10) and grupo=1746378


select * from  
(select * from movimiento union all select * from hist_movimiento) m
left join cruce_concilia cc on cc.no_folio_1 = m.no_folio_det
left join concilia_banco cbco on cbco.secuencia=cc.no_folio_2
left join movto_banca_e mbe on cbco.secuencia=mbe.secuencia
left join zexp_fact zef on m.no_docto=zef.no_doc_sap
left join zimp_fact zif on m.no_docto=zif.no_doc_sap
where 1=1
AND m.id_estatus_mov='K'
AND m. id_forma_pago=3
and year(m.fec_valor)=2017
and m.origen_mov='AS4'
--AND m.no_folio_det=5784481
and m.cve_control='MA134271020171001'


select top 10  * from zexp_fact