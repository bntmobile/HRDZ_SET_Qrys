  WITH pg AS (
  SELECT
    a.no_folio_det,
    a.no_docto,
    a.id_estatus_mov,
    b.nom_arch,
    b.id_estatus_arch,
    b.id_chequera_benef,
    b.id_banco_benef
  FROM
    `mx-herdez-analytics.sethdzqa.TransfPagosR3200` a
  INNER JOIN
    `mx-herdez-analytics.sethdzqa.det_arch_transfer` b
  ON
    a.no_folio_det=b.no_folio_det
  WHERE
    id_estatus_mov IN ('K','T','X')
  GROUP BY
    a.no_folio_det,
    a.id_estatus_mov,
    b.nom_arch,
    b.id_chequera_benef,
    b.id_banco_benef,
    b.id_estatus_arch,
    a.no_docto)
SELECT
  FORMAT_DATE( "%d/%m/%Y",    extract(date    FROM      pp.fec_valor)) AS FechaPropuestaPago,
  FORMAT_DATE( "%d/%m/%Y",    extract(date    FROM      pad.fec_valor)) AS fecha_pagoDet,
  FORMAT_DATE( "%d/%m/%Y",    extract(date    FROM      pa.fec_valor)) AS FechaPago,
  pp.no_docto,
  sag.cve_control,
  sag.fecha_propuesta,
  sag.concepto,
  sag.usuario_uno as Firma1,
  sag.usuario_dos as Firma2,
  sag.usuario_tres as Firma3,
   concat( u1.nombre ,' ',u1.paterno ,' ',u1.materno )as PersonaFirma1,
   concat( u2.nombre ,' ',u2.paterno ,' ',u2.materno )as PersonaFirma2,
  concat( u3.nombre ,' ',u3.paterno ,' ',u3.materno ) as PersonaFirma3,
  pp.id_banco AS id_banco_prop_otorgante,
  pp.id_chequera AS id_chequera_prop_otorgante,
  pp.id_banco_benef AS id_banco_prop_benef,
  ban_o.desc_banco AS desc_banco_prop_otorgante,
  ban_b.desc_banco AS desc_banco_prop_benef,
  pp.id_chequera_benef AS id_chequera_pop_benef,

  pa.id_banco_benef AS id_banco_benef_pago,
  pa.id_chequera_benef AS id_chequera_benef_pago,
  ban_o_pad.desc_banco AS desc_banco_otorgante_pago,
  ban_b_pad.desc_banco AS desc_banco_beneficiario_pago,
  pad.id_estatus_mov estatus_pago_detalle,
  CASE     WHEN pg.no_folio_det= pad.folio_ref AND pg.no_docto=pad.no_docto THEN pg.id_estatus_mov     ELSE pa.id_estatus_mov   END estatus_p,
  
  ce_prop.desc_estatus as estatus_prop,
  ce_pad.desc_estatus as estatus_PagoDet,
  ce_pa.desc_estatus as estatus_Pago,

  
  fp_pp.desc_forma_pago as FormaPagoProp,
  fp_pad.desc_forma_pago as FormaPagoPagpDet,
  fp_pa.desc_forma_pago as FormaPago,
  
  pp.id_divisa as divisa_prop,
  pad.id_divisa as divisa_PagoDet,
  pa.id_divisa as divisa_Pago,
  
  SUM(pp.importe) AS  importe_propuesta,
  SUM(pad.importe) AS importe_PagadoDet,
  SUM(pa.importe) AS  importe_Pagado,
  
  pg.nom_arch,
  pg.id_estatus_arch,
  pg.id_banco_benef,
  pg.id_chequera_benef,
  CASE    
          WHEN pg.no_folio_det= pad.folio_ref and  pg.id_estatus_mov in ('K','T') THEN 'PAGADO' 
          WHEN pg.no_folio_det= pad.no_folio_det and  pg.id_estatus_mov in ('K','T') THEN 'PAGADO'
          WHEN pg.no_folio_det= pad.folio_ref and  pg.id_estatus_mov in ('X') THEN 'CANCELADO' 
   ELSE 'SIN PAGAR'   END estatus
, case when e_prop.empleado_de_la_empresa is not null  then  e_prop.empleado_de_la_empresa else 'PROVEEDOR' end AS Empledao_o_Proveedor_prop
, case when e_pad.empleado_de_la_empresa is not null  then  e_pad.empleado_de_la_empresa else 'PROVEEDOR' end AS Empledao_o_Proveedor_PagoDetalle
, case when e_pa.empleado_de_la_empresa is not null  then  e_pa.empleado_de_la_empresa else 'PROVEEDOR' end AS Empledao_o_Proveedor_Pago
 ,pp.no_cliente as no_cliente_prop
, pad.no_cliente as no_cliente_PagoDet
, pa.no_cliente as no_cliente_Pago

FROM   `mx-herdez-analytics.sethdzqa.TransfPropuestasR3000` pp
LEFT JOIN   (select * from `mx-herdez-analytics.sethdzqa.TransfPagoDetalleR3201` union all select * from `sethdzqa.TransfPagoDetalleR3201_complemento_viene_3200` )   pad ON  pp.no_docto= pad.no_docto
LEFT JOIN   `mx-herdez-analytics.sethdzqa.TransfPagosR3200` pa ON   pa.no_docto= pad.no_docto
LEFT JOIN                                                   pg  ON   pg.no_folio_det= pad.folio_ref 
LEFT JOIN   `mx-herdez-analytics.sethdzqa.cat_banco`        ban_o ON   ban_o.id_banco= pp.id_banco
LEFT JOIN   `mx-herdez-analytics.sethdzqa.cat_banco`        ban_b ON   ban_b.id_banco= pp.id_banco_benef
LEFT JOIN   `mx-herdez-analytics.sethdzqa.cat_banco`        ban_o_pad ON   ban_o_pad.id_banco= pad.id_banco 
LEFT JOIN   `mx-herdez-analytics.sethdzqa.cat_banco`        ban_b_pad ON   ban_b_pad.id_banco= pad.id_banco_benef
left join `mx-herdez-analytics.sethdzqa.cat_forma_pago`     fp_pp  on   pp.id_forma_pago  = fp_pp.id_forma_pago
left join `mx-herdez-analytics.sethdzqa.cat_forma_pago`     fp_pad on  pad.id_forma_pago = fp_pad.id_forma_pago
left join `mx-herdez-analytics.sethdzqa.cat_forma_pago`     fp_pa  on   pa.id_forma_pago  = fp_pa.id_forma_pago
left join `mx-herdez-analytics.sethdzqa.cat_estatus`        ce_prop on pp.id_estatus_mov = ce_prop.id_estatus and ce_prop.clasificacion='MOV'
left join `mx-herdez-analytics.sethdzqa.cat_estatus`        ce_pad on pad.id_estatus_mov = ce_pad.id_estatus and ce_pad.clasificacion='MOV'
left join `mx-herdez-analytics.sethdzqa.cat_estatus`        ce_pa on pa.id_estatus_mov   = ce_pa.id_estatus and ce_pa.clasificacion='MOV'
left join `mx-herdez-analytics.sethdzqa.seleccion_automatica_grupo` sag on pp.cve_control=sag.cve_control 
left join  `mx-herdez-analytics.sethdzqa.cat_usuario` u1 on sag.usuario_uno = u1.no_usuario
left join  `mx-herdez-analytics.sethdzqa.cat_usuario` u2 on sag.usuario_dos = u2.no_usuario
left join  `mx-herdez-analytics.sethdzqa.cat_usuario` u3 on sag.usuario_tres = u3.no_usuario
left join  `mx-herdez-analytics.sethdzqa.v_cat_empleados`  e_prop ON   CAST(pp.no_cliente AS STRING) = CAST(e_prop.no_persona AS STRING)
left join  `mx-herdez-analytics.sethdzqa.v_cat_empleados`  e_pad ON   CAST(pad.no_cliente AS STRING) = CAST(e_pad.no_persona AS STRING)
left join  `mx-herdez-analytics.sethdzqa.v_cat_empleados`  e_pa ON   CAST(pa.no_cliente AS STRING) = CAST(e_pa.no_persona AS STRING)
WHERE
  1=1
 
GROUP BY
  pp.no_docto,
  pa.id_banco_benef,
  pa.id_chequera_benef,
  pp.id_banco,
  pp.id_chequera,
  pg.nom_arch,
  CASE     WHEN pa.no_folio_det=pad.folio_ref THEN 'PAGADO' END,
  pa.no_folio_det,
  pad.folio_ref,
  pg.no_folio_det,
  pad.no_folio_det,
  pg.id_estatus_mov,
  pg.id_estatus_arch,
  pg.id_banco_benef,
  pg.id_chequera_benef,
  pp.id_banco_benef,
  pp.id_chequera_benef,
  pg.no_docto,
  pad.no_docto,
  FORMAT_DATE( "%d/%m/%Y",     extract(date    FROM      pp.fec_valor)),
  FORMAT_DATE( "%d/%m/%Y",    extract(date    FROM      pad.fec_valor)),
  FORMAT_DATE( "%d/%m/%Y",    extract(date    FROM      pa.fec_valor)),   
  ban_o.desc_banco,
  ban_b.desc_banco,
  ban_o_pad.desc_banco,
  ban_b_pad.desc_banco,
  fp_pp.desc_forma_pago,
  fp_pad.desc_forma_pago ,
  fp_pa.desc_forma_pago ,
  ce_prop.desc_estatus  ,
  ce_pad.desc_estatus  ,
  ce_pa.desc_estatus,
  pad.id_estatus_mov,
  pa.id_estatus_mov,
  sag.cve_control,
  sag.fecha_propuesta,
  sag.concepto,
  sag.usuario_uno  ,
  sag.usuario_dos  ,
  sag.usuario_tres  ,
   concat( u1.nombre ,' ',u1.paterno ,' ',u1.materno ),
   concat( u2.nombre ,' ',u2.paterno ,' ',u2.materno ) ,
  concat( u3.nombre ,' ',u3.paterno ,' ',u3.materno ) ,
     pp.id_divisa  ,
  pad.id_divisa  ,
  pa.id_divisa , 
  e_prop.empleado_de_la_empresa ,
    e_pad.empleado_de_la_empresa ,
      e_pa.empleado_de_la_empresa 
      ,pp.no_cliente
,pad.no_cliente
,pa.no_cliente



