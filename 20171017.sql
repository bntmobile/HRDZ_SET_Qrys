 /* 
 	BENITO
 	SANCHEZ 
 	BUSTOS 
 */
 /*
 BUSQUEDA DE ORDENANTE
 */

select a.AsuntoOrdenante,a.NumFiles,b.id_chequera,b.desc_chequera,id_banco
from (
		select   
		asuntoOrdenante , COUNT(distinct [FileName]) NumFiles
		from LRS..BNCMR_Trans_TNN 
		where AsuntoBeneficiario is not null
		group by asuntoOrdenante 
		)a
left  join [sethdzqa]..[cat_cta_banco] b on cast(cast(a.asuntoOrdenante as bigint) as varchar(25))=b.id_chequera collate Modern_Spanish_CI_AS
order by 3 asc
-- total de cuentas Ordenante 47
-- 46 cuentas hacen match aplicanndo conversion a bigint y después a varchar 25
-- solo una cuenta no se encuentra en el catálogo
select * from LRS..BNCMR_Trans_TNN  where AsuntoOrdenante='000000000443409767'
--BC124359
--el dato viene del txt y en el catálogo esta asi '9100443409767'
-- LA CUENTA SI SE ENCUENTRA EN EL CATALOGO  PERO ESTA CON UN PRFIJO 9100
SELECT id_banco,id_chequera,desc_chequera FROM [sethdzqa]..[cat_cta_banco] WHERE id_chequera LIKE '%443409767%'





 /*
 BUSQUEDA DE BENEFICIARIO
 */

select a.AsuntoBeneficiario,a.NumFiles,b.id_chequera,b.desc_chequera,id_banco
from (
		select   
		AsuntoBeneficiario , COUNT(distinct [FileName]) NumFiles
		from LRS..BNCMR_Trans_TNN 
		where AsuntoBeneficiario is not null
		group by AsuntoBeneficiario 
		)a
left  join [sethdzqa]..[cat_cta_banco] b on cast(cast(a.AsuntoBeneficiario as bigint) as varchar(25))=b.id_chequera collate Modern_Spanish_CI_AS
WHERE b.id_chequera IS  NULL
order by 3 asc
-- total de cuentas bENEFICIARIO 4435
-- 36 cuentas hacen match aplicanndo conversion a bigint y después a varchar 25
-- 4399 CUENTAS no se encuentra en el catálogo
select * from LRS..BNCMR_Trans_TNN  where AsuntoBeneficiario='000000000144619757'
--BC124359
--el dato viene del txt y en el catálogo esta asi '9100443409767'
-- LA CUENTA SI SE ENCUENTRA EN EL CATALOGO  PERO ESTA CON UN PRFIJO 9100
SELECT * FROM [sethdzqa]..[cat_cta_banco] WHERE id_chequera LIKE '%144619757%'

select  * from zimpcheqprov a where equiv_per='00P01903'
select  distinct equiv_per from zimpcheqprov a
--51800
select  * from persona p where no_persona='00P01903'

--125665

select  distinct 
 a.id_chequera as id_chequera_trans
,c.id_chequera as id_chequera_bnco
,b.razon_social
,b.nombre_corto
,a.equiv_per as persona_trans
,b.equivale_persona as persona_cat
from zimpcheqprov a
left join persona b  on a.equiv_per=b.equivale_persona
left JOIN ctas_banco c on b.no_persona=c.no_persona and a.id_chequera=c.id_chequera
order by 2 

select * from persona

select * from zimpcheqprov where id_chequera='000000000136466788'
 
select * from LRS..BNCMR_Trans_TNN where AsuntoBeneficiario='000000000136466788'

sp_help zimpcheqprov
sp_help cat_cta_banco
sp_help persona


select * 
from LRS..BNCMR_Trans_Pago_Convenio_CIE 
where FileName like 'BE2%'
