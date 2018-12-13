/* = = = = = = = = = = = = = = Drop all tables = = = = = = = = = = = = = = */

drop table if exists d_evento cascade;
drop table if exists d_meio cascade;
drop table if exists d_tempo cascade;
drop table if exists facts cascade;

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */



/* = = = = = = = = = = = = = = = Criar Tabelas = = = = = = = = = = = = = = = */

create table d_evento (
    idEvento serial,
    numTelefone varchar(9) not null,
    instanteChamada timestamp not null,
    primary key (idEvento)
);


create table d_meio (
    idMeio serial,
    numMeio integer not null,
    nomeMeio varchar(30) not null,
    nomeEntidade varchar(200) not null,
    tipo varchar(7) not null,
    primary key (idMeio)
);


create table d_tempo (
    idData serial,
    dia integer not null,
    mes integer not null,
    ano integer not null,
    primary key (idData)
);


create table facts (
    idFact serial,
    idEvento integer not null,
    idMeio integer not null,
    idData integer not null,
    primary key(idFact),
    foreign key (idEvento) references d_evento(idEvento)
        on delete cascade on update cascade,
    foreign key (idMeio) references d_meio(idMeio)
      on delete cascade on update cascade,
    foreign key (idData) references d_tempo(idData)
        on delete cascade on update cascade
);

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */




/* = = = = = = = = = = = = = = Preencher tabelas = = = = = = = = = = = = = = */

insert into d_evento (numTelefone, instanteChamada)
    select numTelefone, instanteChamada
    from EventoEmergencia
    order by instanteChamada, numtelefone;


insert into d_meio (numMeio, nomeMeio, nomeEntidade, tipo)
    select *
    from (
        select numMeio, nomeMeio, nomeEntidade, 'Apoio'
        from MeioApoio natural join Meio
        union
        select numMeio, nomeMeio, nomeEntidade, 'Socorro'
        from MeioSocorro natural join Meio
        union
        select numMeio, nomeMeio, nomeEntidade, 'Combate'
        from MeioCombate natural join Meio
        union
        select numMeio, nomeMeio, nomeEntidade, 'Nenhum'
        from Meio natural join (
            select numMeio, nomeEntidade
            from Meio
            except
            ( select * from MeioApoio
              union
              select * from MeioSocorro
              union
              select * from MeioCombate )
            ) Meios_Sem_Tipo
        ) T_Meio
    order by numMeio, nomeEntidade, nomeMeio;


insert into d_tempo (dia, mes, ano)
    select extract(day from instanteChamada) as dia,
           extract(months from instanteChamada) as mes,
           extract(year from instanteChamada) as ano
    from EventoEmergencia
    order by ano, mes, dia;


insert into facts (idEvento, idMeio, idData)
    select idEvento, idMeio, idData
    from d_evento
        natural join EventoEmergencia E
        natural join Acciona A
        natural join d_meio M
        inner join d_tempo T on
            (extract(day from E.instantechamada) = T.dia and
             extract(month from E.instantechamada) = T.mes and
             extract(year from E.instantechamada) = T.ano)
    order by idEvento, idMeio, idData;

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */