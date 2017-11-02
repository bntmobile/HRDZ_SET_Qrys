/* BENITO SANCHEZ*/
SELECT COUNT(1) FROM dbo.BNCMR_LogFiles WITH(NOLOCK)
-- TOTAL FILES CARGADOS             -> 11099
-- SERVER HRDZ TOTAL FILES CARGADOS -> 17267  Archivos NO Cargados -> ('BE100802','BC226788')

use LRS
sp_help BNCMR_Trans_Pago_Convenio_CIE
sp_help BNCMR_Trans_TNN
sp_help BNCMR_Trans_TSC

USE sethdzqa
sp_help zimpcheqprov
sp_help cat_cta_banco
sp_help persona


-- SELECT COUNT(1) FROM BNCMR_Trans_TSC WITH(NOLOCK)
-- SELECT COUNT(1) FROM BNCMR_Trans_TNN WITH(NOLOCK) 106614


CREATE VIEW  v_Archivos_Elementos_comun
AS
BEGIN
SELECT AsuntoBeneficiario,AsuntoOrdenante,ImporteOperacion,MotivoPago,[FileName]
from BNCMR_Trans_TNN with(nolock)
WHERE AsuntoOrdenante IS NOT NULL
UNION
SELECT AsuntoBeneficiario,AsuntoOrdenante,ImporteOperacion,MotivoPago,[FileName]
FROM BNCMR_Trans_TSC with(nolock)
WHERE AsuntoOrdenante IS NOT NULL
UNION
SELECT '' AS AsuntoBeneficiario,AsuntoOrdenante,ImporteOperacion,MotivoPago,[FileName]
FROM BNCMR_Trans_Pago_Convenio_CIE with(nolock)
WHERE AsuntoOrdenante IS NOT NULL
END




CREATE VIEW v_Cat_Ctas_Beneficiarios
as
BEGIN
select   AsuntoBeneficiario from v_Archivos_Elementos_comun group by AsuntoBeneficiario
END

CREATE VIEW v_Cat_Ctas_Ordenantes
as
BEGIN
select   AsuntoOrdenante from v_Archivos_Elementos_comun group by AsuntoOrdenante
END


CREATE VIEW v_Busqueda_Cta_Ordenante
as
select a.AsuntoOrdenante,b.id_chequera,b.desc_chequera,id_banco
from v_Cat_Ctas_Ordenantes a
left  join [sethdzqa]..[cat_cta_banco] b 
		on cast(cast(a.asuntoOrdenante as bigint) as varchar(25))=b.id_chequera collate Modern_Spanish_CI_AS
		
		
-- vistas
select * from v_Archivos_Elementos_comun
select * from v_Cat_Ctas_Beneficiarios
select * from v_Cat_Ctas_Ordenantes 


/* BUSQUEDA DE ORDENANTE */
select a.AsuntoOrdenante,b.id_chequera,b.desc_chequera,id_banco
from v_Cat_Ctas_Ordenantes a
left  join [sethdzqa]..[cat_cta_banco] b 
		on cast(cast(a.asuntoOrdenante as bigint) as varchar(25))=b.id_chequera collate Modern_Spanish_CI_AS
order by 3 asc


/* BUSQUEDA DE BENEFICIARIO */
select a.AsuntoBeneficiario,b.id_chequera,b.desc_chequera,id_banco
from v_Cat_Ctas_Beneficiarios a
left  join [sethdzqa]..[cat_cta_banco] b on cast(cast(a.AsuntoBeneficiario as bigint) as varchar(25))=b.id_chequera collate Modern_Spanish_CI_AS
order by 3 asc


select a.AsuntoBeneficiario,b.id_chequera,b.desc_chequera,id_banco
from v_Cat_Ctas_Beneficiarios a
left  join [sethdzqa]..ctas_banco b on cast(cast(a.AsuntoBeneficiario as bigint) as varchar(25))=b.id_chequera collate Modern_Spanish_CI_AS
WHERE 1=1
--AND  b.id_chequera IS NOT NULL
--AND  b.id_chequera IS  NULL
order by 3 asc


SELECT * FROM [sethdzqa]..cat_cta_banco  WHERE id_chequera LIKE '%154000455'
SELECT * FROM [sethdzqa]..ctas_banco  WHERE id_chequera LIKE '%0154000455'




SELECT *
FROM 
(SELECT distinct  SUBSTRING (AsuntoBeneficiario,9,10) CTA_BENEF ,AsuntoBeneficiario AS AsuntoBeneficiarioTXT FROM v_Cat_Ctas_Beneficiarios) X 
LEFT JOIN 
(SELECT distinct SUBSTRING(id_chequera,10,11) CTA,id_chequera,id_banco FROM [sethdzqa]..ctas_banco ) Y 
	ON X.CTA_BENEF=Y.CTA COLLATE Modern_Spanish_CI_AS
WHERE CTA_BENEF='0165372151'
ORDER BY 3


SELECT *
FROM 
(SELECT AsuntoBeneficiario CTA_BENEF  FROM v_Cat_Ctas_Beneficiarios) X 
LEFT JOIN 
(SELECT distinct id_chequera CTA,id_chequera,id_banco FROM [sethdzqa]..ctas_banco ) Y 
	ON X.CTA_BENEF=Y.CTA COLLATE Modern_Spanish_CI_AS

ORDER BY 3




select distinct LEN(id_chequera) from [sethdzqa]..ctas_banco order by 1
select distinct LEN(id_chequera) from [sethdzqa]..ctas_banco order by 1

select * 
from [sethdzqa]..ctas_banco
where id_chequera='02057800596'

select id_chequera, COUNT(1)
from [sethdzqa]..ctas_banco
group by id_chequera
having COUNT(1)>1

--4435
------------------
--4452 TOTAL
-- MATCH 1798
--2654 SIN ENCONTRAR RELACION

SELECT  distinct SUBSTRING (AsuntoBeneficiario,9,10) CTA_BENEF  FROM v_Cat_Ctas_Beneficiarios WHERE  AsuntoBeneficiario='000000000154000455'-- 0154000455
SELECT SUBSTRING(id_chequera,10,11) CTA FROM [sethdzqa]..ctas_banco WHERE id_chequera='0000009100154000455' -- 0154000455


SELECT id_chequera, COUNT(1)  FROM ctas_banco GROUP BY id_chequera HAVING


SELECT   SUBSTRING (AsuntoBeneficiario,9,10)
FROM v_Cat_Ctas_Beneficiarios 
WHERE AsuntoBeneficiario LIKE '%0165372151%'




SELECT * FROM [sethdzqa]..ctas_banco WHERE id_chequera LIKE '%0165372151%'
--00165372151

SELECT distinct  SUBSTRING (AsuntoBeneficiario,9,10) CTA_BENEF ,AsuntoBeneficiario AS AsuntoBeneficiarioTXT 
FROM v_Cat_Ctas_Beneficiarios
WHERE AsuntoBeneficiario LIKE '%0165372151%'



SELECT *
FROM 
(SELECT distinct  SUBSTRING (AsuntoBeneficiario,9,10) CTA_BENEF  FROM v_Cat_Ctas_Beneficiarios) X 
LEFT JOIN 
(SELECT distinct SUBSTRING(id_chequera,10,10) CTA,id_banco FROM [sethdzqa]..ctas_banco ) Y 
	ON X.CTA_BENEF=Y.CTA COLLATE Modern_Spanish_CI_AS
ORDER BY 3




select top 1 *   FROM [sethdzqa]..ctas_banco

SELECT no_empresa, SUBSTRING(id_chequera,10,10) CTA,id_chequera,id_banco 
FROM [sethdzqa]..ctas_banco
WHERE  id_chequera like '%2617469411'


SELECT no_empresa, SUBSTRING(id_chequera,10,10) CTA,id_chequera,id_banco 
FROM [sethdzqa]..ctas_banco
WHERE  id_chequera like '%2657295782'

SELECT distinct  SUBSTRING (AsuntoBeneficiario,9,10) CTA_BENEF 
 FROM v_Cat_Ctas_Beneficiarios 
where AsuntoBeneficiario like '%2657295782' 


SELECT    SUBSTRING(id_chequera,10,10) 
			,*
FROM [sethdzqa]..ctas_banco
WHERE  1=1
and (id_chequera like '%2657295782' OR  id_chequera like '%2617469411')	
ORDER BY 1

-- misma cuenta para 2 bancos
SELECT 
	no_empresa
,  SUBSTRING(id_chequera,10,10)cta 
,  COUNT( distinct id_banco) contar_banco
--into tmp_33_cta_2Bancos
FROM [sethdzqa]..ctas_banco
where len(SUBSTRING(id_chequera,10,10))=10
group by SUBSTRING(id_chequera,10,10),no_empresa
having COUNT( distinct id_banco)>1
order by 1

select SUBSTRING(id_chequera,10,10),LEN(id_chequera)longitud ,*
from  [sethdzqa]..ctas_banco
WHERE SUBSTRING(id_chequera,10,10)  in 
(
select cta from tmp_33_cta_2Bancos
)
order by id_chequera

use [sethdzqa]
sp_help ctas_banco

SELECT 
	no_empresa
,  cast(CAST( id_chequera as numeric(25)) as varchar(25))cta 
,  COUNT( distinct id_banco) contar_banco
--into tmp_33_cta_2Bancos
FROM [sethdzqa]..ctas_banco
where len(SUBSTRING(id_chequera,10,10))=10
group by cast(CAST( id_chequera  as numeric(25)) as varchar(25)),no_empresa
having COUNT( distinct id_banco)>1
order by 1
