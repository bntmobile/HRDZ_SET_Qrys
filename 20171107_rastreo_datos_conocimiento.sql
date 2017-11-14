DECLARE @no_doc_sap as varchar(25)
DECLARE @cve_control as varchar(25)
SET @no_doc_sap='009624109' ---  forma de pago Transferencia
            
zimp_fact
SELECT * FROM ZIMP_FACT where no_doc_sap=@no_doc_sap
--select * from ( SELECT * FROM MOVIMIENTO where no_docto=@no_doc_sap and id_estatus_mov='K' UNION ALL SELECT * FROM hist_MOVIMIENTO where no_docto=@no_doc_sap and id_estatus_mov='K' )c
select @cve_control= cve_control from  (SELECT cve_control FROM MOVIMIENTO where no_docto=@no_doc_sap and id_estatus_mov='K' UNION ALL  SELECT cve_control FROM hist_MOVIMIENTO where no_docto=@no_doc_sap and id_estatus_mov='K')x

select * from seleccion_automatica_grupo where cve_control=@cve_control
select fec_valor,grupo_pago,id_tipo_operacion, id_forma_pago,id_tipo_movto,* from ( SELECT * FROM MOVIMIENTO where no_docto=@no_doc_sap and id_estatus_mov='K' UNION ALL SELECT * FROM hist_MOVIMIENTO where no_docto=@no_doc_sap and id_estatus_mov='K' )c
where cve_control=@cve_control



select fec_valor,grupo_pago,id_tipo_operacion, id_forma_pago,*
from movimiento with (nolock)
where 1=1
and grupo_pago ='5797749'
order by 3

select fec_valor,grupo_pago,id_tipo_operacion, id_forma_pago,*
from movimiento with (nolock)
where 1=1
and grupo_pago ='0' 
--and id_tipo_operacion=3000
and no_folio_mov ='2762915'
order by 3

print 'El valor de no_doc_sap es:-> ' +@no_doc_sap
print 'El valor para cve_control es_ -> '+@cve_control

