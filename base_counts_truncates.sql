--truncate table BNCMR_LogFiles
--truncate table BNCMR_Trans_Pago_Convenio_CIE
--truncate table BNCMR_Trans_TNN
--truncate table BNCMR_Trans_TSC
--truncate table BNCMR_Trans_Pago_Internacional_OPI

select COUNT(1) from BNCMR_LogFiles with(nolock)
--17267--NO CARGO 1 

select COUNT(1) from BNCMR_Trans_TNN with(nolock) order by 1 desc
select COUNT(1) from BNCMR_Trans_TSC with (nolock) order by 1 desc
select COUNT(1) from BNCMR_Trans_Pago_Convenio_CIE with (nolock) order by 1 desc
select COUNT(1) from BNCMR_Trans_Pago_Internacional_OPI with (nolock) order by 1 desc



	select count(distinct  [FileName]) from BNCMR_Trans_TNN with (nolock) 
union
	select count(distinct  [FileName]) from BNCMR_Trans_TSC with (nolock) 
union
	select count(distinct  [FileName]) from BNCMR_Trans_Pago_Convenio_CIE with (nolock) 
union
	select COUNT(distinct  [FileName]) from BNCMR_Trans_Pago_Internacional_OPI with (nolock) order by 1 desc


select [FileName]
into t1
from (
		select distinct  [FileName] from BNCMR_Trans_TNN with (nolock) 
		union
		select distinct  [FileName] from BNCMR_Trans_TSC with (nolock) 
		union
		select distinct  [FileName] from BNCMR_Trans_Pago_Convenio_CIE with (nolock) 
		union
		select distinct  [FileName] from BNCMR_Trans_Pago_Internacional_OPI with (nolock) 
) x


select t1.[FileName]   ,a.[NombreFile]
from t1  
right join BNCMR_LogFiles a with (nolock) on  a.[NombreFile]=t1.[FileName]
where  t1.[FileName] is null
order by 2 desc





SELECT *  FROM BNCMR_LOGFILES WHERE  NOMBREFILE IN ('BE100802','BC226788')

