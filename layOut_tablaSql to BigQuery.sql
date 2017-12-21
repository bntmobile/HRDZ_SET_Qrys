 SELECT 
  TABLE_NAME
, COLUMN_NAME
, DATA_TYPE
, IS_NULLABLE 
, '{"name":"'+COLUMN_NAME+'","type":"' + 
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
END + '","mode":"'+ 
CASE 
	when IS_NULLABLE='NO' then  'REQUIRED'
     when IS_NULLABLE='YES' then 'NULLABLE'
END +'"},'
value
FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_CATALOG='sethdzqa'  and TABLE_NAME='detalle_pago_as400'
ORDER BY   TABLE_NAME, ORDINAL_POSITION

