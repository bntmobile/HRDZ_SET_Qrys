
SELECT  
 sa.cve_control
, sa.id_grupo_flujo
, sa.cupo_total - sa.cupo_automatico as propuesto
, m.no_docto
, m.importe
, m.origen_mov
, cupo_total
, c.desc_grupo_cupo
, sa.fecha_pago
, sa.id_grupo
, f.desc_grupo_flujo
, coalesce(sa.concepto,'') as concepto
, sa.usuario_uno
, sa.usuario_dos
,sa.usuario_tres
  , f.nivel_autorizacion
 , sa.id_division, 
       ( SELECT count(*) 
         FROM movimiento m 
         WHERE m.id_estatus_mov = 'L' 
             AND m.id_tipo_movto = 'E' 
             AND m.id_tipo_operacion between 3800 and 3899 
             AND m.cve_control = sa.cve_control 
       ) as NumIntercos, 
       ( SELECT sum(m.importe) 
         FROM movimiento m 
         WHERE m.id_estatus_mov = 'L' 
             AND m.id_tipo_movto = 'E' 
             AND m.id_tipo_operacion between 3800 and 3899 
             AND m.cve_control = sa.cve_control 
       ) as TotalIntercos
       ,sa.motivo_rechazo
       ,sa.habilitado
       ,sa.usuario_rev_final 
  FROM seleccion_automatica_grupo sa
  , cat_grupo_cupo c
  , cat_grupo_flujo f 
  , (select * from movimiento union all select * from hist_movimiento) m
  WHERE sa.id_grupo *= c.id_grupo_cupo 
  AND sa.id_grupo_flujo *= f.id_grupo_flujo 
  AND sa.id_grupo_flujo in 
       ( SELECT id_grupo_flujo 
         FROM grupo_empresa 
         WHERE no_empresa in 
             ( SELECT no_empresa 
               FROM usuario_empresa 
               WHERE no_usuario = 261 ) )
 AND sa.fecha_pago between '01/11/2016' AND '09/11/2017'
 AND sa.cve_control not like 'MAN%'
 AND coalesce(sa.usuario_uno,0) <>0 
 AND coalesce(sa.usuario_dos,0)<> 0 
 AND coalesce(sa.usuario_tres,0)<> 0 
 and (
sa.concepto like '%-MN-%' or sa.concepto like '%-DLS-%' or sa.concepto like '%-EUR-%'  or (sa.concepto not like '%-MN-%' and  sa.concepto not like '%-DLS-%' and sa.concepto not like '%-EUR-%' AND sa.concepto NOT like '%SET:%')  )
and sa.cve_control=m.cve_control
and m.id_tipo_operacion=3200
and m.id_forma_pago=3
and m.id_estatus_mov in ('K','T')
order by sa.cve_control,desc_grupo_flujo,cupo_total asc
 
 
 --select * from (select * from movimiento union all select * from hist_movimiento) m
 --where  cve_control ='MA100011120161001'


 
 


 
