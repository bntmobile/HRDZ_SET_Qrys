

select 
		t1.AsuntoBeneficiario
		,t1.cta_int
		,t2.cta_int as cta_cat 
from 
			(
			select  distinct  AsuntoBeneficiario
			,cast(CAST( AsuntoBeneficiario as numeric(25))  as varchar(25)) cta_int
			from LRS..v_Cat_Ctas_Beneficiarios
			
			) t1
left join (
			SELECT   
			  id_chequera 
			, cast(CAST( id_chequera as numeric(25))  as varchar(25)) cta_int
			FROM ctas_banco 
			WHERE 1=1 
			and id_chequera not like '%[a-z]%' 
			and id_chequera not like '%[A-Z]%'
			and id_chequera<>''
			group by  id_chequera
		   ) t2 
		on t1.cta_int=t2.cta_int
order by 1





