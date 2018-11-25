/* 1) Qual é o processo de socorro que envolveu maior número de meios distintos; */

with TmeiosAccionados as (
    select numProcessoSocorro, count(*) as numMeiosAccionados
    from Acciona
    group by numProcessoSocorro
    )
select numProcessoSocorro, numMeiosAccionados
from TmeiosAccionados
         natural join (
                      select max(numMeiosAccionados) as numMeiosAccionados
                      from TmeiosAccionados
                      ) TmaxMeios;



/* 2) Qual a entidade fornecedora de meios que participou em mais processos de
    socorro no Verao de 2018; */

with TnumProcessosEntidade as (
     select nomeEntidade, count(*) as numProcessos
     from Acciona natural join EventoEmergencia
     where instanteChamada >= timestamp '2018-06-21 00:00:00' and
           instanteChamada <= timestamp '2018-09-23 23:59:59'
     group by nomeEntidade
    )
select nomeEntidade, numProcessos
from TnumProcessosEntidade
       natural join (
                    select max(numProcessos) as numProcessos
                    from TnumProcessosEntidade
                    ) TentidadeMax;



/* 3) Quais sao os processos de socorro, referentes a eventos de emergencia em
    2018 de Oliveira do Hospital, onde existe pelo menos um acionamento de meios
    que nao foi alvo de auditoria; */

select numProcessoSocorro
from (
     select *
     from Acciona
     except
     select numMeio, nomeEntidade, numProcessoSocorro
     from Acciona natural join Audita
     ) TprocessosNaoAuditados
       natural join EventoEmergencia
where extract(year from instanteChamada) = 2018 and
      moradaLocal = 'Oliveira do Hospital';



/* 4) Quantos segmentos de video com duracao superior a 60 segundos, foram gravados
    em cameras de vigilancia de Monchique durante o mes de Agosto de 2018; */

select count(*) as numSegmentos
from SegmentoVideo natural join Vigia
where duracao > '60 secs' and
      moradaLocal = 'Monchique' and
      extract(year from dataHoraInicio) = 2018 and
      extract(month from dataHoraInicio) = 8;



/* 5) Liste os Meios de combate que nao foram usados como Meios de Apoio em nenhum
    processo de socorro; */

select *
from MeioCombate
except
select numMeio, nomeEntidade
from MeioApoio natural join Acciona;



/* 6) Liste as entidades que forneceram meios de combate a todos os Processos de
    socorro que acionaram meios; */

select nomeEntidade
from EntidadeMeio entM
where not exists (
            select *
            from processoSocorro
            except
            select numProcessoSocorro
            from (MeioCombate natural join Acciona) MeiosAcc
            where entM.nomeEntidade = MeiosAcc.nomeEntidade);