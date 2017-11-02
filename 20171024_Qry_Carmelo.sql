--226077
select 
upper(dt.nom_arch ) nom_arch
,dt.id_chequera as cta_otorgante
,dt.id_banco_benef
,dt.id_chequera_benef cta_beneficiario
,dt.beneficiario
, count(dt.id_banco) cuenta_registros
, SUM(dt.importe) as Importe
from sethdzqa..det_arch_transfer dt
inner join sethdzqa..hist_movimiento hm 
										ON  dt.no_folio_det  = hm.no_folio_det 
inner join sethdzqa..persona p 
									    ON cast(hm.no_cliente as varchar(15))= cast(p.no_persona as varchar(15))
inner join sethdzqa..ctas_banco cb 
								        ON   cb.no_persona=p.no_persona 
										AND  cast(hm.no_cliente as varchar(15))= cast(p.no_persona as varchar(15))
										AND  hm.id_chequera_benef = cb.id_chequera 
WHERE 1=1
--AND dt.nom_arch = 'BC218486' 
and dt.id_banco = 12
AND dt.id_estatus_arch IN ('T','R') 
group by dt.nom_arch 
,dt.id_chequera 
,dt.id_banco_benef
,dt.id_chequera_benef 
,dt.beneficiario




--226077
select 
upper(dt.nom_arch ) nom_arch
, count(dt.id_banco) cuenta_registros
, SUM(dt.importe) as Importe
--into tmp_files_set
from sethdzqa..det_arch_transfer dt
inner join sethdzqa..hist_movimiento hm 
										ON  dt.no_folio_det  = hm.no_folio_det 
inner join sethdzqa..persona p 
									    ON cast(hm.no_cliente as varchar(15))= cast(p.no_persona as varchar(15))
inner join sethdzqa..ctas_banco cb 
								        ON   cb.no_persona=p.no_persona 
										AND  cast(hm.no_cliente as varchar(15))= cast(p.no_persona as varchar(15))
										AND  hm.id_chequera_benef = cb.id_chequera 
WHERE 1=1
and dt.id_banco = 12
AND dt.id_estatus_arch IN ('T','R')
and dt.nom_arch='BC216649' 
group by dt.nom_arch 


SELECT     z0.nom_arch
, count(z0.cuenta_registros) cuenta_regSET
, sum(z0.Importe) importeSET
, z1.FileName
, sum(z1.importe) AS importeTXT
,count(z1.cuenta_reg) as cuentaRegTxt
FROM         tmp_files_set AS z0 INNER JOIN
                          (SELECT     FileName, SUM(CAST(ImporteOperacion AS decimal(20, 2))) AS importe, COUNT(1) AS cuenta_reg
                            FROM          LRS.dbo.BNCMR_Trans_TSC
                            WHERE      (AsuntoBeneficiario IS NOT NULL) AND (TipoCuenta = '40')
                            GROUP BY FileName) AS z1 ON z0.nom_arch = z1.FileName COLLATE SQL_Latin1_General_CP1_CI_AS
group by
 z0.nom_arch,  z1.FileName
 having count(z0.cuenta_registros) <>count(z1.cuenta_reg) 
 or sum(z0.Importe)<>sum(z1.importe) 
 
-- nom_arch	cuenta_regSET	importeSET	FileName	importeTXT	cuentaRegTxt
--BC216649  	1	1175243.78	BC216649	910215.13	1
 select nom_arch, SUM(importe) importe from det_arch_transfer where nom_arch='BC216649' group by nom_arch
-- nom_arch	importe
--bc216649  	910215.13
 select FileName, SUM(CAST(importeOperacion as decimal(20,2))) as importeOperacion
  from LRS..BNCMR_Trans_TSC where FileName='BC216649'
  group by FileName
--  FileName	importeOperacion
--BC216649	910215.13
  
  
  
  525.65