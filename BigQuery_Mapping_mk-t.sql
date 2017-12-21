use sethdzqa

with data as (
SELECT 
  TABLE_NAME
, COLUMN_NAME+':' +
 case 
	when DATA_TYPE='varchar' then 'STRING'
	when DATA_TYPE='nvarchar' then 'STRING'
	when DATA_TYPE='nchar' then 'STRING'
	when DATA_TYPE='char' then 'STRING'
	when DATA_TYPE='int' then 'INTEGER'
	when DATA_TYPE='smallint' then 'INTEGER'
	when DATA_TYPE='bigint' then 'INTEGER'
	when DATA_TYPE='decimal' then 'FLOAT'
	when DATA_TYPE='numeric' then 'FLOAT'
	when DATA_TYPE='float' then 'FLOAT'
	when DATA_TYPE='datetime' then 'TIMESTAMP'
	when DATA_TYPE='date' then 'TIMESTAMP'
END  value2
,ORDINAL_POSITION
--select * 
FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_CATALOG='sethdzqa'  and TABLE_NAME in (
'BITACORA_ACT_CHEQUERA',
'caja_usuario',
'cat_caja',
'cat_estatus',
'cat_forma_pago',
'cat_grupo_cupo',
'cat_grupo_flujo',
'cat_usuario',
'concilia_banco',
'cruce_concilia',
'ctas_banco',
'det_arch_transfer',
'empresa',
'grupo_empresa',
'hist_movimiento',
'movimiento',
'movto_banca_e',
'persona',
'seleccion_automatica_grupo',
'set006',
'usuario_empresa',
'zexp_fact',
'zimp_fact','detalle_pago_as400',
'cat_banco')


)
    
SELECT 'bq mk -t sethdz.'+p1.table_name+' '+
       ( SELECT value2 + ',' 
           FROM data p2
          WHERE p2.table_name = p1.table_name
          ORDER BY ORDINAL_POSITION,value2
            FOR XML PATH('') ) AS Products
FROM data p1
      GROUP BY table_name ;
      
     
select COUNT(1) from cat_banco