select   no_folio_det ,grupo_pago
,sum(T) T,sum(X) X ,sum(R) R
, case when sum(T)>=1 then 'T' 
       when sum(T)=0 AND SUM(R)>=1 then 'R'
       when sum(X)>=1 and sum(R)=0 AND sum(T)=0 then 'X'
end as id_estatus_arch 
FROM (
      select 
        a.no_folio_det, b.grupo_pago
        , case when a.id_estatus_arch='T' THEN count(1) else 0 end as T
        , case when a.id_estatus_arch='X' THEN count(1)  else 0 end as X
        , case when a.id_estatus_arch='R' THEN count(1)  else 0 end as R
        , COUNT(1) conteo
      from `mx-herdez-analytics.sethdzqa.det_arch_transfer`  AS  a
      inner join  `mx-herdez-analytics.sethdzqa.TransfPagosR3200` b on a.no_folio_det=b.no_folio_det
     -- where  no_docto='009586748' 
     --where  no_folio_det=70
     --where b.no_docto in ('009561320','009649835','009649836','009649837','009649838','009649839','009649840','009649841','009645355','009645810', '009566822')
      group by no_folio_det , id_estatus_arch, b.grupo_pago
    ) T1
GROUP BY 
  no_folio_det,grupo_pago