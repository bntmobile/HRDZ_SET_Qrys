select   
  zi.no_doc_sap  as KxNoDocto
, zi.forma_pago as KnFormaPagoZimpFact
, zi.origen as KxOrigenZimpFact
, prov.no_persona  KnNoClienteZimpFact
, prov.empleado_de_la_empresa as DxTipoProveedor
, zi.no_benef KnNoClienteBenefZimpFact
, pp.no_empresa KnNoEmpresa
, pp.no_cliente KnNoClientePropuesta
, provProp.razon_social as DxRazonSocialProp
--, pa.no_cliente KnNoClientePago
--, grp_pg.no_cliente KnNoClientePago_grp_pg
, case when pa.no_cliente  is null then grp_pg.no_cliente else pa.no_cliente  end as KnNoClientePago
, provPa.razon_social DxRazonSocialPago
, pp.id_rubro as KnRubroProp
, rProp.desc_rubro as DxRubroProp
, case when pa.id_rubro  is null then grp_pg.id_rubro else pa.id_rubro  end as KnRubroPago
, rpa.desc_rubro as DxRubroPago
, pp.id_forma_pago as  KnFormaPagoPropuesta
, pp.origen_mov as KxOrigenPropuesta
, pp.no_folio_det  as KnNoFolioDetPropuesta
,	pp.id_tipo_operacion as KnTipoOperacionPropuesta
--,	pp.no_docto
,	pp.grupo_pago as KnGrupoPagoPropuesta
,	pp.folio_ref as KnFolioRefPropuesta
, pp.no_factura as KxNoFactura
, zi.importe as MfImporteZimpFact
, pp.importe as MfImportePropuesta
, pp.id_estatus_mov as KxEstatusPropuesta
--, pa.no_folio_det as no_folio_det_pa,	pa.id_tipo_operacion as id_tipo_operacion_pa
--,	pa.no_docto as no_docto_pa,	pa.grupo_pago as grupo_pago_pa
--, pa.id_estatus_mov as id_estatus_mov_pa, pa.importe as importe_pa
--, grp_pg.grupo_pago as grupo_pago_grp_pg, grp_pg.id_estatus_mov as id_estatus_mov_grp_pg
--, grp_pg.importe
, case when pa.id_estatus_mov is null then   grp_pg.id_estatus_mov else  pa.id_estatus_mov end as KxEstatusPagado
, case
        
        when      pp.id_estatus_mov='X'   
             AND  case when pa.id_estatus_mov is null then   grp_pg.id_estatus_mov else  pa.id_estatus_mov end ='X' 
             AND  case when  dat.id_estatus_arch is null  then dat2.id_estatus_arch 
                       when  dat2.id_estatus_arch is null then dat.id_estatus_arch 
                       when  dat2.id_estatus_arch=dat.id_estatus_arch 
                  then dat.id_estatus_arch END  IN ('R','T')                  
             THEN 'REVISAR CANCELADO Y PAGADO' 
        -- SI A NIVEL DE PROPUESTA TIENE ESTATUS X ES CANCELADO
        when pp.id_estatus_mov='X'  THEN 'CANCELADO'
        -- SI A NIVEL DE PROPUESTA TIENE X Y ADEMÁS COMO PAGO ACUMAULADO TIENE ESTATUS "X" ES CANCELADO
        when pp.id_estatus_mov='X'   OR  case when pa.id_estatus_mov is null then   grp_pg.id_estatus_mov else  pa.id_estatus_mov end ='X' then 'CANCELADO'
        -- TAMBIEN ES CANCELADO AUNQUE EN PROP TENGA ESTATUS DIFERENTE A 'X' Y EN PAGO TENEGA ESTATUS DE T,K Y EN DET_ARCH_TRANSFER TENGA 'X'
        when pp.id_estatus_mov<>'X' AND  case when pa.id_estatus_mov is null then   grp_pg.id_estatus_mov else  pa.id_estatus_mov end in ('T','K') 
            AND case when  dat.id_estatus_arch is null  then dat2.id_estatus_arch when  dat2.id_estatus_arch is null then dat.id_estatus_arch when  dat2.id_estatus_arch=dat.id_estatus_arch then dat.id_estatus_arch end  IN ('X')
        then 'CANCELADO'
        
        -- PARA SER PAGADO DEBE LA PROPUESTA TENER ESTATUS DIFERENTE DE "X", ADEMÁS A NIVEL DE PAGO INDIVIDUAL O GRUPASL DEBE TENER ESTATUS T O K 
        -- Y ADEMÁS EN DET_ARCH_TRANSFER DEBERÁ TENER EL PAGO EL ESTATUS DE 'R' O 'T' 
        when pp.id_estatus_mov<>'X' AND  case when pa.id_estatus_mov is null then   grp_pg.id_estatus_mov else  pa.id_estatus_mov end in ('T','K') 
            AND case when  dat.id_estatus_arch is null  then dat2.id_estatus_arch when  dat2.id_estatus_arch is null then dat.id_estatus_arch when  dat2.id_estatus_arch=dat.id_estatus_arch then dat.id_estatus_arch end  IN ('R','T')
        then 'PAGADO'
        else 'SIN PAGAR'
        
  end DxEstatus
, case 
      when pp.id_estatus_mov='X' or pa.id_estatus_mov ='X' then 0
      when (pp.id_estatus_mov<>'X' or pa.id_estatus_mov <>'X') and   pa.importe is null then  grp_pg.importe   else pa.importe 
   end as MfImportePagado
,	pa.folio_ref as KnFolioRefPago
, sag.cve_control as KxCveControl
, zi.fec_valor KdFechaEstimadaPagoZimpFact
, zi.fec_propuesta as KdFechaPropuestaZimpFact
, zi.fec_fact as KdFechaFactura
, prov.KdDiasPlazo as KnDiasPlazo
, DATE_ADD(EXTRACT (DATE FROM TIMESTAMP(PARSE_DATE('%d/%m/%Y',zi.fec_fact )) ) , interval cast(prov.KdDiasPlazo as int64) DAY) as KdFechaFacMasDiasPlazo
, CASE  	WHEN  sag.fecha_pago is null  THEN 0
		ELSE DATE_DIFF(extract( date from  sag.fecha_pago) 
							   ,  DATE_ADD(EXTRACT (DATE FROM TIMESTAMP(PARSE_DATE('%d/%m/%Y',zi.fec_fact )) ) , interval cast(prov.KdDiasPlazo as int64) DAY) -- KdFechaFacMasDiasPlazo
							   ,  DAY )
  END AS KnDifFecFactFecPago
, sag.fecha_propuesta KdFechaPropuestaSag
, sag.fecha_pago KdFechaPagoSag
, sag.usuario_uno KnFirma1
, sag.usuario_dos KnFirma2
, sag.usuario_tres KnFirma3
, case when sag.usuario_uno is null then 0 else 1 end + case when sag.usuario_dos is null then 0 else 1 end + case when sag.usuario_tres is null then 0 else 1 end  MfTotalFirmas
--, dat.id_estatus_arch as KxEstatusArch
--, dat.no_folio_det KnNoFolioDetPagado
--, dat2.no_folio_det KnNoFolioDetPagado_
,case 
      when  dat.no_folio_det is null  then dat2.no_folio_det
      when  dat2.no_folio_det is null then dat.no_folio_det
      when  dat2.no_folio_det=dat.no_folio_det then dat.no_folio_det
end AS KnNoFolioDetPagadoUnified
--, dat.X as KnEstatusArchCancelado
,case 
      when  dat.X is null  then dat2.X
      when  dat2.X is null then dat.X
      when  dat2.X=dat.X then dat.X
end AS KnEstatusArchCanceladoUnified
--, dat.R as KnEstatusArchRegenerado

,case 
      when  dat.R is null  then dat2.R
      when  dat2.R is null then dat.R
      when  dat2.R=dat.R then dat.R
end as KnEstatusArchRegeneradoUnified
--, dat.T as KnEstatusArchTransferido

,case 
      when  dat.T is null  then dat2.T
      when  dat2.T is null then dat.T
      when  dat2.T=dat.T then dat.T
end as KnEstatusArchTransferidoUnified

,
case 
      when  dat.id_estatus_arch is null  then dat2.id_estatus_arch
      when  dat2.id_estatus_arch is null then dat.id_estatus_arch
      when  dat2.id_estatus_arch=dat.id_estatus_arch then dat.id_estatus_arch
end KxEstatusArch,

CASE
     WHEN  cast(prov.no_persona as string) = pp.no_cliente AND pp.no_cliente = case when pa.no_cliente  is null then grp_pg.no_cliente else pa.no_cliente end    THEN 0
     ELSE 1
END KbCambioCliente,
zi.id_divisa KxDivisaZimp,
pp.id_divisa KxDivisaProp,
CASE WHEN pa.id_divisa IS NULL THEN grp_pg.id_divisa ELSE pa.id_divisa END as KxDivisaPagado
,datx.nom_arch as KxNomArch
, ze.fecha_exp as KdFechaExpZexpFact
, ze.hora_recibo DxHoraReciboZexpFact
, case  when ze.estatus = 'E' then 'EXPORTADAO' when ze.estatus='I' then 'IMPORTADO' ELSE 'REVISAR ESTATUS' END as DxEstatusZexpFact
, ze.causa_rech as DxCausaRechZexpFact
, ccon.fec_alta as KdFechaAltaCruceConcilia
, ccon.tipo_concilia as KxTipoConcilia
, cban.id_estatus_cb as KxEstatusCb
, cban.importe as MfImporteCb
, cban.folio_banco as KXFolioBancoCb
, cban.descripcion DxDescripcionCb
, mbe.archivo KxArchivoMvtoBanE
, CASE 
	WHEN 				UPPER(mbe.archivo) like 'MDBI%'
					OR UPPER(mbe.archivo) like 'MHBI%'	
					OR UPPER(mbe.archivo) like 'MOVC%'
					OR UPPER(mbe.archivo) like 'HHCV%'
					OR UPPER(mbe.archivo) like 'REPMOVCON%'
					OR UPPER(mbe.archivo) like '80048635931%'
					OR UPPER(mbe.archivo) like 'H2H%'
					
								THEN 'AUTOMATICO'
	ELSE 'MANUAL'
END AS DxEstatusArchivoMvtoBanE,
CASE 
	WHEN UPPER(mbe.archivo) like 'MDBI%' THEN 'BANAMEX'
	WHEN UPPER(mbe.archivo) like 'MHBI%'	THEN 'BANAMEX'
	WHEN UPPER(mbe.archivo) like 'MOVC%' THEN 'BANCOMER'
	WHEN UPPER(mbe.archivo) like 'HHCV%' THEN 'BANCOMER'
	WHEN UPPER(mbe.archivo) like 'REPMOVCON%' THEN 'HSBC'
	WHEN UPPER(mbe.archivo) like '80048635931%' THEN 'SANTANDER'
	WHEN UPPER(mbe.archivo) like 'H2H%' THEN 'SCOTIABANK'
	ELSE 'MANUAL'
END AS DxArchivoBancoMvtoBnE
FROM        `mx-herdez-analytics.sethdzqa.v_zimp_fact_trans` zi 
inner JOIN   `mx-herdez-analytics.sethdzqa.TransfPropuestasR3000` pp on  zi.no_doc_sap=pp.no_docto 
LEFT JOIN   `mx-herdez-analytics.sethdzqa.TransfPagosR3200` pa ON   pa.no_docto= pp.no_docto and pp.no_folio_det=pa.folio_ref  
LEFT JOIN  (select grupo_pago,no_folio_det,id_estatus_mov , no_cliente,id_divisa,id_rubro,sum(importe)as importe
            from `mx-herdez-analytics.sethdzqa.TransfPagosR3200` 
            where grupo_pago <>0 group by  grupo_pago,no_folio_det,id_estatus_mov,no_cliente,id_divisa,id_rubro
            ) as grp_pg ON pp.grupo_pago = grp_pg.grupo_pago
LEFT JOIN `mx-herdez-analytics.sethdzqa.seleccion_automatica_grupo`   sag on sag.cve_control = pp.cve_control
LEFT JOIN `mx-herdez-analytics.sethdzqa.v_resumen_det_arch_transfer` as dat on dat.no_folio_det = pa.no_folio_det 
left join (select * from `mx-herdez-analytics.sethdzqa.v_resumen_det_arch_transfer` where grupo_pago<>0) dat2 on dat2.grupo_pago=pp.grupo_pago
LEFT JOIN `mx-herdez-analytics.sethdzqa.v_cat_empleados_proveedores`  as prov on zi.no_benef = prov.equivale_persona
LEFT JOIN `mx-herdez-analytics.sethdzqa.v_cat_empleados_proveedores`  as provPa on  cast(provPa.no_persona as string) = case when pa.no_cliente  is null then grp_pg.no_cliente else pa.no_cliente  end 
LEFT JOIN  `mx-herdez-analytics.sethdzqa.cat_rubro` rpa on rpa.id_rubro = case when pa.id_rubro  is null then grp_pg.id_rubro else pa.id_rubro  end 
LEFT JOIN `mx-herdez-analytics.sethdzqa.v_cat_empleados_proveedores`  as provProp on  cast(provProp.no_persona as string) = pp.no_cliente  
LEFT JOIN  `mx-herdez-analytics.sethdzqa.cat_rubro` rProp on rProp.id_rubro =  pp.id_rubro  
LEFT JOIN `mx-herdez-analytics.sethdzqa.det_arch_transfer`  datx on datx.no_folio_det = 
case  when  dat.no_folio_det is null  then dat2.no_folio_det
      when  dat2.no_folio_det is null then dat.no_folio_det
      when  dat2.no_folio_det=dat.no_folio_det then dat.no_folio_det end and datx.id_estatus_arch = 
case  when  dat.id_estatus_arch is null  then dat2.id_estatus_arch
      when  dat2.id_estatus_arch is null then dat.id_estatus_arch
      when  dat2.id_estatus_arch=dat.id_estatus_arch then dat.id_estatus_arch end 
and case when      pp.id_estatus_mov='X'   
             AND  case when pa.id_estatus_mov is null then   grp_pg.id_estatus_mov else  pa.id_estatus_mov end ='X' 
             AND  case when  dat.id_estatus_arch is null  then dat2.id_estatus_arch 
                       when  dat2.id_estatus_arch is null then dat.id_estatus_arch 
                       when  dat2.id_estatus_arch=dat.id_estatus_arch 
                  then dat.id_estatus_arch END  IN ('R','T')                  
             THEN 'REVISAR CANCELADO Y PAGADO' 
        -- SI A NIVEL DE PROPUESTA TIENE ESTATUS X ES CANCELADO
        when pp.id_estatus_mov='X'  THEN 'CANCELADO'
        -- SI A NIVEL DE PROPUESTA TIENE X Y ADEMÁS COMO PAGO ACUMAULADO TIENE ESTATUS "X" ES CANCELADO
        when pp.id_estatus_mov='X'   OR  case when pa.id_estatus_mov is null then   grp_pg.id_estatus_mov else  pa.id_estatus_mov end ='X' then 'CANCELADO'
        -- TAMBIEN ES CANCELADO AUNQUE EN PROP TENGA ESTATUS DIFERENTE A 'X' Y EN PAGO TENEGA ESTATUS DE T,K Y EN DET_ARCH_TRANSFER TENGA 'X'
        when pp.id_estatus_mov<>'X' AND  case when pa.id_estatus_mov is null then   grp_pg.id_estatus_mov else  pa.id_estatus_mov end in ('T','K') 
            AND case when  dat.id_estatus_arch is null  then dat2.id_estatus_arch when  dat2.id_estatus_arch is null then dat.id_estatus_arch when  dat2.id_estatus_arch=dat.id_estatus_arch then dat.id_estatus_arch end  IN ('X')
        then 'CANCELADO'
        -- PARA SER PAGADO DEBE LA PROPUESTA TENER ESTATUS DIFERENTE DE "X", ADEMÁS A NIVEL DE PAGO INDIVIDUAL O GRUPASL DEBE TENER ESTATUS T O K 
        -- Y ADEMÁS EN DET_ARCH_TRANSFER DEBERÁ TENER EL PAGO EL ESTATUS DE 'R' O 'T' 
        when pp.id_estatus_mov<>'X' AND  case when pa.id_estatus_mov is null then   grp_pg.id_estatus_mov else  pa.id_estatus_mov end in ('T','K') 
            AND case when  dat.id_estatus_arch is null  then dat2.id_estatus_arch when  dat2.id_estatus_arch is null then dat.id_estatus_arch when  dat2.id_estatus_arch=dat.id_estatus_arch then dat.id_estatus_arch end  IN ('R','T')
        then 'PAGADO'
        else 'SIN PAGAR'
  end  in ('PAGADO','REVISAR CANCELADO Y PAGADO')
LEFT JOIN `mx-herdez-analytics.sethdzqa.zexp_fact` ze on zi.no_doc_sap = ze.no_doc_sap  
																		and case 
																			  when  dat.no_folio_det is null  then dat2.no_folio_det
																			  when  dat2.no_folio_det is null then dat.no_folio_det
																			  when  dat2.no_folio_det=dat.no_folio_det then dat.no_folio_det
																			end = ze.no_pedido 
																		and ze.no_folio_set not in (5036899) -- se omite éste  porque sino duplica los registros referente al docto 009605673 que  esta en dls y esta doble en sus registros 3000
Left join(
			Select no_folio_1, no_folio_2,tipo_concilia, fec_alta, no_empresa,id_banco,id_chequera, fec_exporta
			from `mx-herdez-analytics.sethdzqa.cruce_concilia`
			group by no_folio_1, no_folio_2,tipo_concilia, fec_alta, no_empresa,id_banco,id_chequera, fec_exporta
			)  ccon on -- se mete agrupación ya que hay 1 registro duplicado 4811747 
case 
      when  dat.no_folio_det is null  then dat2.no_folio_det
      when  dat2.no_folio_det is null then dat.no_folio_det
      when  dat2.no_folio_det=dat.no_folio_det then dat.no_folio_det
end = ccon.no_folio_1
left join `mx-herdez-analytics.sethdzqa.concilia_banco` cban on cban.secuencia = ccon.no_folio_2 and ccon.no_empresa=cban.no_empresa
left join `mx-herdez-analytics.sethdzqa.movto_banca_e` mbe on mbe.secuencia = cban.secuencia and mbe.no_empresa = cban.no_empresa

--where zi.no_doc_sap --in('5645003204')
--in ('009561320','009649835','009649836','009649837','009649838','009649839','009649840','009649841','009645355','009645810', '009566822'
--,'5646237987', '5646385924')