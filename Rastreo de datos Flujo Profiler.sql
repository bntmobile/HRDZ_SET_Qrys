SELECT sa.cve_control, sa.id_grupo_flujo, sa.cupo_total - sa.cupo_automatico as propuesto, 
       cupo_total, c.desc_grupo_cupo, sa.fecha_propuesta, sa.id_grupo, f.desc_grupo_flujo, 
       coalesce(sa.concepto,'') as concepto, sa.usuario_uno, sa.usuario_dos, 
       sa.usuario_tres, f.nivel_autorizacion, sa.id_division, 
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
       ) as TotalIntercos,sa.motivo_rechazo,sa.habilitado,sa.usuario_rev_final 
  FROM seleccion_automatica_grupo sa, cat_grupo_cupo c, cat_grupo_flujo f 
  WHERE sa.id_grupo *= c.id_grupo_cupo 
  AND sa.id_grupo_flujo *= f.id_grupo_flujo 
   AND sa.id_grupo_flujo in 
       ( SELECT id_grupo_flujo 
         FROM grupo_empresa 
         WHERE no_empresa in 
             ( SELECT no_empresa 
               FROM usuario_empresa 
               WHERE no_usuario = 261 ) )
 AND sa.fecha_propuesta between '09/11/2017' AND '09/11/2017'
 AND sa.cve_control not like 'MAN%'
 AND coalesce(sa.usuario_uno,0) <> 0 
 AND coalesce(sa.usuario_dos,0) <> 0 
 and (
concepto like '%-MN-%' or concepto like 'SET:%' and  (select distinct(m.id_divisa) from movimiento m where sa.cve_control=m.cve_control )='MN' or concepto like 'SET:%' and  (select distinct(m.id_divisa) from movimiento m where sa.cve_control=m.cve_control )<>'MN' or concepto like '%-DLS-%' or concepto like '%-EUR-%'  or (concepto not like '%-MN-%' and  concepto not like '%-DLS-%' and concepto not like '%-EUR-%' AND concepto NOT like '%SET:%')  )
 AND sa.cve_control IN(
 select distinct m.cve_control
 from movimiento m, grupo_empresa ge
 where m.id_estatus_mov in('N','C','T', 'L')
 AND m.id_tipo_operacion in(3000,3801)
 and coalesce(m.cve_control,'') <> ''
 and m.no_empresa = ge.no_empresa
 and m.id_caja in(SELECT id_caja FROM caja_usuario
                       Where no_usuario = 261)
 )
 UNION ALL 
 SELECT sa.cve_control, sa.id_grupo_flujo, sa.cupo_total - sa.cupo_automatico as propuesto, 
       cupo_total, c.desc_grupo_cupo, sa.fecha_propuesta, sa.id_grupo, f.desc_grupo_flujo, 
       coalesce(sa.concepto,'') as concepto, sa.usuario_uno, sa.usuario_dos, 
       sa.usuario_tres, f.nivel_autorizacion, sa.id_division, 
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
       ) as TotalIntercos,sa.motivo_rechazo,sa.habilitado,sa.usuario_rev_final 
  FROM seleccion_automatica_grupo sa, cat_grupo_cupo c, cat_grupo_flujo f 
 WHERE sa.id_grupo *= c.id_grupo_cupo 
   AND sa.id_grupo_flujo *= f.id_grupo_flujo 
   AND sa.id_grupo_flujo in 
       ( SELECT id_grupo_flujo 
         FROM grupo_empresa 
         WHERE no_empresa in 
             ( SELECT no_empresa 
               FROM usuario_empresa 
               WHERE no_usuario = 261 ) )
 AND sa.cve_control not like 'MAN%'
 AND coalesce(sa.usuario_uno,0) <> 0 
 AND coalesce(sa.usuario_dos,0) <> 0 
 and (
concepto like '%-MN-%' or concepto like 'SET:%' and  (select distinct(m.id_divisa) from movimiento m where sa.cve_control=m.cve_control )='MN' or concepto like 'SET:%' and  (select distinct(m.id_divisa) from movimiento m where sa.cve_control=m.cve_control )<>'MN' or concepto like '%-DLS-%' or concepto like '%-EUR-%'  or (concepto not like '%-MN-%' and  concepto not like '%-DLS-%' and concepto not like '%-EUR-%' AND concepto NOT like '%SET:%')  )
 AND sa.cve_control IN(
 select distinct m.cve_control
 from movimiento m, grupo_empresa ge
 where m.id_estatus_mov in('N','C','T','L')
 AND m.id_tipo_operacion in(3000,3801)
 and coalesce(m.cve_control,'') <> ''
 and m.no_empresa = ge.no_empresa
 and m.fec_propuesta < '09/11/2017'
 and m.id_caja in(SELECT id_caja FROM caja_usuario
                       Where no_usuario = 261)
 )

declare @cve_control varchar(50)
set @cve_control='MA7071120171001' 

select * from seleccion_automatica_grupo  where cve_control=@cve_control

 SELECT *
  FROM movimiento m LEFT JOIN cat_estatus e ON (m.id_estatus_mov = e.id_estatus ) 
 WHERE m.id_tipo_movto = 'E' --EGRESOS
     AND ( m.origen_mov <> 'INV' or m.origen_mov is null )
    -- AND m.id_estatus_mov in ('N','C','F','L','V') 
     AND m.id_forma_pago in (1, 3, 5, 6, 9,8) 
     AND e.clasificacion = 'MOV' 
     --AND m.no_folio_det in ( SELECT mm.folio_ref  FROM movimiento mm  WHERE mm.folio_ref = m.no_folio_det ) 
     AND m.cve_control = @cve_control
     and m.no_empresa in (select no_empresa from grupo_empresa  where id_grupo_flujo = 1001)
     
     
select * from zimp_fact zf where zf.no_doc_sap in (select no_docto from movimiento m  where  m.cve_control =@cve_control )
     
select equivale_persona,* from persona where equivale_persona in ('38268','00294','04668','59714')
 
 