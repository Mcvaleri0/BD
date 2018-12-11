/* Drop all tables */
DROP TABLE IF EXISTS d_evento cascade;
DROP TABLE IF EXISTS d_meio cascade;
DROP TABLE IF EXISTS d_tempo cascade;
drop table if exists fact cascade;

/* Criar Tabelas */
create table d_evento(
    idEvento        serial,
    numTelefone     varchar(9) NOT NULL, 
    instanteChamada timestamp  NOT NULL,
    primary key (idEvento)
);

create table d_meio(
    idMeio       serial,
    numMeio      integer      NOT NULL, 
    nomeMeio     varchar(30)  NOT NULL, 
    nomeEntidade varchar(200) NOT NULL, 
    tipo         varchar(7)   NOT NULL,
    primary key (idMeio)
);

create table d_tempo(
    dia  integer,                      
    mes  integer,
    ano  integer,
    primary key (dia, mes, ano)
);

create table fact(
    idFact   serial,
    idEvento integer,
    idMeio   integer,
    dia      integer,
    mes      integer,
    ano      integer,
    nomePessoa varchar(80) not null,
    moradaLocal varchar(255) not null,
    numProcessoSocorro integer not null,
    primary key(idFact),
    foreign key (idEvento)
        references d_evento(idEvento) on delete cascade on update cascade,
    foreign key (idMeio)
        references d_meio(idMeio) on delete cascade on update cascade,
    foreign key (dia, mes, ano)
        references d_tempo(dia, mes, ano) on delete cascade on update cascade
);


/* Preencher tabelas */

INSERT INTO d_evento (numTelefone, instanteChamada)
    SELECT numTelefone, instanteChamada 
    FROM EventoEmergencia
    order by instanteChamada, numtelefone;

INSERT INTO d_meio (numMeio, nomeMeio, nomeEntidade, tipo)
    select *
    from (
        SELECT numMeio, nomeMeio, nomeEntidade, 'Apoio' as tipo
        FROM MeioApoio natural join Meio natural join Acciona
        UNION
        SELECT numMeio, nomeMeio, nomeEntidade, 'Socorro' as tipo
        FROM MeioSocorro natural join Meio natural join Acciona
        UNION
        SELECT numMeio, nomeMeio, nomeEntidade, 'Combate' as tipo
        FROM MeioCombate natural join Meio natural join Acciona
        ) T_Meio
    order by numMeio, nomeEntidade, nomeMeio;


INSERT INTO d_tempo (dia, mes, ano)
    SELECT EXTRACT(DAY FROM instanteChamada) as dia, EXTRACT(MONTH FROM instanteChamada) as mes, EXTRACT(YEAR FROM instanteChamada) as ano
    FROM EventoEmergencia
    group by dia, mes, ano;
