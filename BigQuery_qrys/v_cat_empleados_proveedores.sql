with  as400_proveedores as (
  SELECT 
    cast( PROV as INT64) KdProveedor 
  , NPROV DxProveedor
  , PZPRV KdDiasPlazo
  , RFCPR KxRFC
  FROM `mx-herdez-analytics.PRISM.HDZCXP2_PF02` 
)

SELECT  a.*
,
CASE 
    when LENGTH(a.equivale_persona)=7 then 'HERDEZ' 
    when LENGTH(a.equivale_persona)=8 then 'NUTRISA'
    ELSE 'PROVEEDOR' 
END AS empleado_de_la_empresa
 ,COALESCE (t2.KdDiasPlazo,0) as KdDiasPlazo
from `mx-herdez-analytics.sethdzqa.persona`   a
left join as400_proveedores t2 on a.no_persona=t2.KdProveedor