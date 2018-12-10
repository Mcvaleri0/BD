/* Drop all tables */
DROP TABLE IF EXISTS d_evento;
DROP TABLE IF EXISTS d_meio;
DROP TABLE IF EXISTS d_tempo;

/* Criar Tabelas */
create table d_evento(
    idEvento        int AUTO_INCREMENT, 
    numTelefone     varchar(9), 
    instanteChamada timestamp,
    primary key (idEvento)
);

create table d_meio(
    idMeio       int AUTO_INCREMENT, 
    numMeio      integer, 
    nomeMeio     varchar(30) not null, 
    nomeEntidade varchar(200), 
    tipo         integer,
    primary key (idMeio)
);

create table d_tempo(
    dia  integer,                      /* aqui n entendo qual é a primary key (é suposto adicionar uma? ou são todas primary?)*/
    mes  integer,
    ano  integer
);

/* Preencher tabelas */

INSERT INTO d_evento (numTelefone, instanteChamada)
    SELECT numTelefone, instanteChamada 
    FROM EventoEmergencia;

INSERT INTO d_meio (numMeio, nomeMeio, nomeEntidade, tipo)
    SELECT numMeio, nomeMeio, nomeEntidade                          /*aqui é suposto ir buscar o tipo (no clue how to do that)*/
    FROM Meio;


INSERT INTO d_tempo (dia, mes, ano)
    SELECT EXTRACT(DAY FROM timestamp instanteChamada) as dia, EXTRACT(MONTH FROM timestamp instanteChamada) as mes, EXTRACT(YEAR FROM timestamp instanteChamada) as ano 
    FROM EventoEmergencia;

    /* n tenho a certeza se a função a usar aqui é o extract mas penso q sim*/
