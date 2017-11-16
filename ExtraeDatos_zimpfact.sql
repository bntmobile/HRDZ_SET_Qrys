--15063

  select   
     zf.*
  -- , d.id_divisa
   , d.desc_divisa  
  -- , fp.id_forma_pago
   , fp.desc_forma_pago
   --, r.id_rubro
   , r.desc_rubro
   --, cj.id_caja
   , cj.desc_caja
   , case 
			when zf.estatus= 'I' then 'IMPORTADO'
			when zf.estatus= 'R' then 'RECHAZADO'
			else 'N/A'
	end as Estatus_zf
 -- , o.origen_mov
  , o.desc_origen_mov
 -- , fpo.id_forma_pago as id_forma_pago_original
  , fpo.desc_forma_pago as desc_forma_pago_original
 -- , COALESCE ( b.id_banco,'0') id_banco_pagador_bancos
  , COALESCE (b.desc_banco,'SIN BANCO PAGADOR') as banco_desc_pagador
 -- , COALESCE (as4.id_tipo_docto_as400,'0')id_tipo_docto_as400
  , COALESCE (as4.desc_tipo_docto_as400,'SIN ID TIPO DOCTO AS400')desc_tipo_docto_as400
  from  sethdzqa..zimp_fact zf
  inner join sethdzqa..cat_divisa  d on  zf.id_divisa=d.id_divisa 
  inner join sethdzqa..cat_forma_pago fp on zf.forma_pago=fp.id_forma_pago
  inner join sethdzqa..cat_rubro r on zf.id_rubro=r.id_rubro
  inner join sethdzqa..cat_caja cj on zf.id_caja = cj.id_caja
  inner join sethdzqa..cat_origen_mov o on zf.origen=o.origen_mov
  inner join sethdzqa..cat_forma_pago fpo on zf.forma_pago_original=fpo.id_forma_pago
  left  join sethdzqa..cat_banco b on zf.banco_pagador=b.id_banco
  left join  lrs..cat_tipo_docto_as400 as4 on zf.tipo_docto_as400=as4.id_tipo_docto_as400 collate Modern_Spanish_CI_AS
  where zf.fec_valor like '%/10/2017'
  order by zf.forma_pago
  
  
  
