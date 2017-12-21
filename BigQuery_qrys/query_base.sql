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
  sag.fecha_pago as FechaPagoSag,
  pp.no_docto,
  sag.cve_control,
  sag.fecha_propuesta,
  sag.concepto,
 
 sag.usuario_uno as Firma1,
 concat( u1.nombre ,' ',u1.paterno ,' ',u1.materno )as PersonaFirma1,
 sag.usuario_dos as Firma2,
 concat( u2.nombre ,' ',u2.paterno ,' ',u2.materno )as PersonaFirma2,
 sag.usuario_tres as Firma3,
 concat( u3.nombre ,' ',u3.paterno ,' ',u3.materno ) as PersonaFirma3,
 case when sag.usuario_uno is null then 0 else 1 end + case when sag.usuario_dos is null then 0 else 1 end + case when sag.usuario_tres is null then 0 else 1 end  TotalFirmas,
 
 pp.id_banco AS id_banco_prop_otorgante,
 ban_o_pp.desc_banco AS desc_banco_prop_otorgante,
 pp.id_chequera AS id_chequera_prop_otorgante,
 pp.id_banco_benef AS id_banco_prop_benef,
 ban_b_pp.desc_banco AS desc_banco_prop_benef,
 pp.id_chequera_benef AS id_chequera_pop_benef,
 
  pad.id_banco AS id_banco_pagoDet_otorgante,
  ban_o_pad.desc_banco AS desc_banco_pagoDet_otorgante,
  pad.id_chequera AS id_chequera_pagoDet_otorgante,
  pad.id_banco_benef AS id_banco_pagoDet_benef,
  ban_b_pad.desc_banco AS desc_banco_pagoDet_beneficiario,
  pad.id_chequera_benef AS id_chequera_pagoDet_benef,
  
  
  
  pa.id_banco AS id_banco_pago_otorgante,
  ban_o_pa.desc_banco AS desc_banco_pago_otorgante,
  pa.id_chequera AS id_chequera_pago_otorgante,
  pa.id_banco_benef AS id_banco_pago_benef,
  ban_b_pa.desc_banco AS desc_banco_pago_beneficiario,
  pa.id_chequera_benef AS id_chequera_pago_benef,
    
  pp.id_estatus_mov id_estatus_prop,
  ce_prop.desc_estatus as desc_estatus_prop,
  pad.id_estatus_mov id_estatus_pagoDet,
  ce_pad.desc_estatus as desc_estatus_PagoDet,
  pa.id_estatus_mov id_estatus_pago,  
  ce_pa.desc_estatus as desc_estatus_Pago,

  
  fp_pp.desc_forma_pago as FormaPagoProp,
  fp_pad.desc_forma_pago as FormaPagoPagpDet,
  fp_pa.desc_forma_pago as FormaPago,
  
  pp.id_divisa as divisa_prop,
  pp.id_divisa_original as divisa_original_prop,
  pad.id_divisa as divisa_PagoDet,
   pad.id_divisa_original as divisa_original_PagoDet,
    pa.id_divisa as divisa_Pago,
  pa.id_divisa_original as divisa_original_Pago,
  
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
          WHEN pp.id_estatus_mov='X' OR pad.id_estatus_mov='X' THEN 'CANCELADO' 
   	  ELSE 'SIN PAGAR'   
   END estatus

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

LEFT JOIN   `mx-herdez-analytics.sethdzqa.cat_banco`        ban_o_pp ON   ban_o_pp.id_banco= pp.id_banco
LEFT JOIN   `mx-herdez-analytics.sethdzqa.cat_banco`        ban_b_pp ON   ban_b_pp.id_banco= pp.id_banco_benef 

LEFT JOIN   `mx-herdez-analytics.sethdzqa.cat_banco`        ban_o_pad ON   ban_o_pad.id_banco= pad.id_banco     
LEFT JOIN   `mx-herdez-analytics.sethdzqa.cat_banco`        ban_b_pad ON   ban_b_pad.id_banco= pad.id_banco_benef 

LEFT JOIN   `mx-herdez-analytics.sethdzqa.cat_banco`        ban_o_pa ON   ban_o_pa.id_banco= pa.id_banco      
LEFT JOIN   `mx-herdez-analytics.sethdzqa.cat_banco`        ban_b_pa ON   ban_b_pa.id_banco= pa.id_banco_benef



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
  pad.id_banco,
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
  ban_o_pp.desc_banco,
  ban_b_pp.desc_banco,
   ban_o_pa.desc_banco,
  ban_b_pa.desc_banco,
  ban_o_pad.desc_banco,
  ban_b_pad.desc_banco,
  fp_pp.desc_forma_pago,
  fp_pad.desc_forma_pago ,
  fp_pa.desc_forma_pago ,
  ce_prop.desc_estatus  ,
  ce_pad.desc_estatus  ,
  ce_pa.desc_estatus,
  pp.id_estatus_mov,
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
       pp.id_divisa_original  ,
  pad.id_divisa_original  ,
  pa.id_divisa_original ,
  e_prop.empleado_de_la_empresa ,
    e_pad.empleado_de_la_empresa ,
      e_pa.empleado_de_la_empresa 
      ,pp.no_cliente
,pad.no_cliente
,pa.no_cliente
 ,sag.fecha_pago
 ,pa.id_banco
 ,pa.id_chequera
  ,pa.id_banco_benef 
  ,pa.id_chequera_benef 
  
 ,pad.id_chequera
 ,pad.id_banco
 ,pad.id_banco_benef 
 ,pad.id_chequera_benef 



