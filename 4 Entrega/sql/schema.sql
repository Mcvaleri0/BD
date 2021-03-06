/* ================ CORRER ESTE SCRIPT FAZ RESET AS TABELAS ================ */

/* = = = = = = = = = = Eliminacao das tabelas antigas = = = = = = = = = = */

drop table if exists Camara cascade;
drop table if exists Local cascade;
drop table if exists EntidadeMeio cascade;
drop table if exists Coordenador cascade;

drop table if exists Video cascade;
drop table if exists SegmentoVideo cascade;
drop table if exists ProcessoSocorro cascade;
drop table if exists Meio cascade;
drop table if exists MeioCombate cascade;
drop table if exists MeioApoio cascade;
drop table if exists MeioSocorro cascade;

drop table if exists Vigia cascade;
drop table if exists EventoEmergencia cascade;
drop table if exists Transporta cascade;
drop table if exists Alocado cascade;
drop table if exists Acciona cascade;
drop table if exists Audita cascade;
drop table if exists Solicita cascade;

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */




/* = = = = = = = = = = = Criacao das Tabelas (Schemas) = = = = = = = = = = = */

/* ------------------------- Tabelas independentes ------------------------- */

create table Camara(
	numCamara integer,
	primary key(numCamara)
);


create table Local (
	moradaLocal varchar(255),
	primary key (moradaLocal)
);


create table EntidadeMeio (
	nomeEntidade varchar(200),
	primary key (nomeEntidade)
);


create table Coordenador (
  idCoordenador integer,
  primary key (idCoordenador)
);

/* ------------------------------------------------------------------------- */



/* ----------------------- Tabelas que dependem de 1 ----------------------- */

create table Video (
	dataHoraInicio timestamp,
	dataHoraFim timestamp not null,
	numCamara integer,
	primary key(dataHoraInicio, numCamara),
	foreign key(numCamara)
		references Camara(numCamara) on delete cascade on update cascade
);


create table SegmentoVideo (
	numSegmento integer,
	duracao interval not null,
	dataHoraInicio timestamp,
	numCamara integer,
	primary key (numSegmento, dataHoraInicio, numCamara),
	foreign key (dataHoraInicio, numCamara)
		references Video(dataHoraInicio, numCamara) on delete cascade on update cascade
);


create table ProcessoSocorro (
	numProcessoSocorro integer,
	primary key (numProcessoSocorro)
	/* Processo tem de estar associado a um ou mais EventoEmergencia */
);


create table Meio (
	numMeio integer,
	nomeMeio varchar(30) not null,
	nomeEntidade varchar(200),
	primary key (numMeio, nomeEntidade),
	foreign key (nomeEntidade)
		references EntidadeMeio(nomeEntidade) on delete cascade on update cascade
);


create table MeioCombate (
	numMeio integer,
	nomeEntidade varchar(200),
	primary key (numMeio, nomeEntidade),
	foreign key (numMeio, nomeEntidade)
		references Meio(numMeio, nomeEntidade) on delete cascade on update cascade
);


create table MeioApoio (
  numMeio integer,
  nomeEntidade varchar(200),
  primary key (numMeio, nomeEntidade),
  foreign key (numMeio, nomeEntidade)
    references Meio(numMeio, nomeEntidade) on delete cascade on update cascade
);


create table MeioSocorro(
  numMeio integer,
  nomeEntidade varchar(200),
  primary key (numMeio, nomeEntidade),
  foreign key (numMeio, nomeEntidade)
    references Meio(numMeio, nomeEntidade) on delete cascade on update cascade
);

/* ------------------------------------------------------------------------- */



/* ----------------------- Tabelas que dependem de 2 ----------------------- */

create table Vigia (
	moradaLocal varchar(255),
	numCamara integer,
  primary key (moradaLocal, numCamara),
	foreign key (moradaLocal)
		references Local(moradaLocal) on delete cascade on update cascade,
	foreign key (numCamara)
		references Camara(numCamara) on delete cascade on update cascade
);


create table EventoEmergencia (
	numTelefone varchar(9),
	instanteChamada timestamp,
	nomePessoa varchar(80) not null ,
	moradaLocal varchar(255) not null ,
	numProcessoSocorro integer,
	primary key (numTelefone, instanteChamada),
	foreign key (moradaLocal)
		references Local(moradaLocal) on delete cascade on update cascade,
	foreign key (numProcessoSocorro)
		references ProcessoSocorro(numProcessoSocorro) on delete cascade on update cascade,
	unique (numTelefone, nomePessoa)
);


create table Transporta (
  numMeio integer,
  nomeEntidade varchar(200),
  numVitimas integer not null,
  numProcessoSocorro integer,
  primary key (numMeio, nomeEntidade, numProcessoSocorro),
  foreign key (numMeio, nomeEntidade)
    references MeioSocorro(numMeio, nomeEntidade) on delete cascade on update cascade,
  foreign key (numProcessoSocorro)
    references ProcessoSocorro(numProcessoSocorro) on delete cascade on update cascade
);


create table Alocado (
  numMeio integer,
  nomeEntidade varchar(200),
  numHoras interval not null,
  numProcessoSocorro integer,
  primary key (numMeio, nomeEntidade, numProcessoSocorro),
  foreign key (numMeio, nomeEntidade)
    references MeioApoio(numMeio, nomeEntidade) on delete cascade on update cascade,
  foreign key (numProcessoSocorro)
    references ProcessoSocorro(numProcessoSocorro) on delete cascade on update cascade
);


create table Acciona (
  numMeio integer,
  nomeEntidade varchar(200),
  numProcessoSocorro integer,
  primary key (numMeio, nomeEntidade, numProcessoSocorro),
  foreign key (numMeio, nomeEntidade)
    references Meio(numMeio, nomeEntidade) on delete cascade on update cascade,
  foreign key (numProcessoSocorro)
    references ProcessoSocorro(numProcessoSocorro) on delete cascade on update cascade
);


create table Audita (
  idCoordenador integer,
  numMeio integer,
  nomeEntidade varchar(200),
  numProcessoSocorro integer,
  datahoraInicio timestamp not null,
  datahoraFim timestamp not null,
  dataAuditoria date not null,
  texto text,
  primary key (idCoordenador, numMeio, nomeEntidade, numProcessoSocorro),
  foreign key (numMeio, nomeEntidade, numProcessoSocorro)
    references Acciona(numMeio, nomeEntidade, numProcessoSocorro) on delete cascade on update cascade,
  foreign key (idCoordenador)
    references Coordenador(idCoordenador) on delete cascade on update cascade,
  check (datahoraInicio < datahoraFim),
  check (dataAuditoria <= (current_date))
);


create table Solicita (
  idCoordenador integer,
  dataHoraInicioVideo timestamp,
  numCamara integer,
  dataHoraInicio timestamp not null,
  dataHoraFim timestamp not null,
  primary key (idCoordenador, dataHoraInicioVideo, numCamara),
  foreign key (idCoordenador)
    references Coordenador(idCoordenador) on delete cascade on update cascade,
  foreign key (dataHoraInicioVideo, numCamara)
    references Video(dataHoraInicio, numCamara) on delete cascade on update cascade
);

/* ------------------------------------------------------------------------- */

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */




/* = = = = = = = = = = = = = = Funcoes Callback = = = = = = = = = = = = = = */

/* Todos os processos de socorro tem de estar associados a um ou mais eventos de
    emergencia. -> Verificacao feita sempre que se insere um registo novo. */
create or replace function check_ProcSOS()
returns trigger as $body$
begin

  if not exists(
    select *
    from EventoEmergencia EE
    where EE.numProcessoSocorro = new.numProcessoSocorro)
  then
    raise exception 'Processo de Socorro % nao associado a nenhum Evento de Emergencia.', new.numProcessoSocorro
    using hint = 'Verifique o numero do Processo de Socorro';
  end if;

  return null;
end;
$body$ language plpgsql;

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */




/* = = = = = = = = = = = = = = = = Triggers = = = = = = = = = = = = = = = = */

drop trigger if exists check_ProcSOS_trigger on ProcessoSocorro cascade;

create constraint trigger check_ProcSOS_trigger
after insert or update on ProcessoSocorro
deferrable initially deferred
for each row execute procedure check_ProcSOS();

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */