/* = = = = = = = = = = = = = = Instrucao OLAP = = = = = = = = = = = = = = */

with Tmeio15 as (
     select *
     from d_meio natural join facts natural join d_tempo
     where idEvento = 15
    )
select *
from (
    select tipo, ano, mes, count(*) as nMeios
    from Tmeio15
    group by tipo, ano, mes
    union
    select tipo, ano, null, count(*) as nMeios
    from Tmeio15
    group by tipo, ano
    union
    select tipo, null, null, count(*) as nMeios
    from Tmeio15
    group by tipo
    ) T
order by tipo, ano, mes, nMeios;

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */