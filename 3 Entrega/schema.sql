/* ================ CORRER ESTE SCRIPT FAZ RESET AS TABELAS ================ */

/* - - - - - - - - - - Eliminacao das tabelas antigas - - - - - - - - - - */

drop table if exists Camara cascade;
drop table if exists Video cascade;
drop table if exists SegmentoVideo cascade;
drop table if exists Local cascade;
drop table if exists Vigia cascade;
drop table if exists ProcessoSocorro cascade;
drop table if exists EventoEmergencia cascade;
drop table if exists EntidadeMeio cascade;
drop table if exists Meio cascade;
drop table if exists MeioCombate cascade;
drop table if exists MeioApoio cascade;
drop table if exists MeioSocorro cascade;
drop table if exists Transporta cascade;
drop table if exists Alocado cascade;
drop table if exists Acciona cascade;
drop table if exists Coordenador cascade;
drop table if exists Audita cascade;
drop table if exists Solicita cascade;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */



/* - - - - - - - - - - - Criacao das Tabelas (Schemas) - - - - - - - - - - - */

create table Camara(
	numCamara integer,
	primary key(numCamara)
);


create table Video (
	dataHoraInicio timestamp,	/* timestamp ou datatestamp */
	dataHoraFim timestamp,		/* not null? */
	numCamara integer, 				/* integer ou numeric */
	primary key(dataHoraInicio, numCamara),
	foreign key(numCamara)
		references Camara(numCamara)
);


create table SegmentoVideo (
	numSegmento integer,
	duracao interval,
	dataHoraInicio timestamp,
	numCamara integer,
	primary key (numSegmento, dataHoraInicio, numCamara),
	foreign key (dataHoraInicio, numCamara)
		references Video(dataHoraInicio, numCamara)
);


create table Local (
	moradaLocal varchar(255),
	primary key (moradaLocal)
);


create table Vigia (
	moradaLocal varchar(255),
	numCamara integer,
	foreign key (moradaLocal)
		references Local(moradaLocal),
	foreign key (numCamara)
		references Camara(numCamara)
);


create table ProcessoSocorro (
	numProcessoSocorro integer,
	primary key (numProcessoSocorro)
	/* Processo tem de estar associado a um ou mais EventoEmergencia */
);


create table EventoEmergencia (
	numTelefone varchar(9),	/* varchar ou numeric? E preciso verificar ITU E.16 */
	instanteChamada timestamp,
	nomePessoa varchar(80),
	moradaLocal varchar(255),
	numProcessoSocorro integer,
	primary key (numTelefone, instanteChamada),
	foreign key (moradaLocal)
		references Local(moradaLocal),
	foreign key (numProcessoSocorro)
		references ProcessoSocorro(numProcessoSocorro),
	unique (numTelefone, nomePessoa)
);


create table EntidadeMeio (
	nomeEntidade varchar(200),
	primary key (nomeEntidade)
);


create table Meio (
	numMeio integer,
	nomeMeio varchar(30),
	nomeEntidade varchar(200),
	primary key (numMeio, nomeEntidade),
	foreign key (nomeEntidade)
		references EntidadeMeio(nomeEntidade)
);


create table MeioCombate (
	numMeio integer,
	nomeEntidade varchar(200),
	primary key (numMeio, nomeEntidade),
	foreign key (numMeio, nomeEntidade)
		references Meio(numMeio, nomeEntidade)
);


create table MeioApoio (
  numMeio integer,
  nomeEntidade varchar(200),
  primary key (numMeio, nomeEntidade),
  foreign key (numMeio, nomeEntidade)
    references Meio(numMeio, nomeEntidade)
);


create table MeioSocorro(
  numMeio integer,
  nomeEntidade varchar(200),
  primary key (numMeio, nomeEntidade),
  foreign key (numMeio, nomeEntidade)
    references Meio(numMeio, nomeEntidade)
);


create table Transporta (
  numMeio integer,
  nomeEntidade varchar(200),
  numVitimas integer,
  numProcessoSocorro integer,
  primary key (numMeio, nomeEntidade, numProcessoSocorro),
  foreign key (numMeio, nomeEntidade)
    references MeioSocorro(numMeio, nomeEntidade),
  foreign key (numProcessoSocorro)
    references ProcessoSocorro(numProcessoSocorro)
);


create table Alocado (
  numMeio integer,
  nomeEntidade varchar(200),
  numHoras integer, /* numero ou tempo? */
  numProcessoSocorro integer,
  primary key (numMeio, nomeEntidade, numProcessoSocorro),
  foreign key (numMeio, nomeEntidade)
    references MeioApoio(numMeio, nomeEntidade),
  foreign key (numProcessoSocorro)
    references ProcessoSocorro(numProcessoSocorro)
);


create table Acciona (
  numMeio integer,
  nomeEntidade varchar(200),
  numProcessoSocorro integer,
  primary key (numMeio, nomeEntidade, numProcessoSocorro),
  foreign key (numMeio, nomeEntidade)
    references MeioApoio(numMeio, nomeEntidade),
  foreign key (numProcessoSocorro)
    references ProcessoSocorro(numProcessoSocorro)
);


create table Coordenador (
  idCoordenador integer,
  primary key (idCoordenador)
);


create table Audita (
  idCoordenador integer,
  numMeio integer,
  nomeEntidade varchar(200),
  numProcessoSocorro integer,
  datahoraInicio timestamp,
  datahoraFim timestamp,
  dataAuditoria date,
  texto text,
  primary key (idCoordenador, numMeio, nomeEntidade, numProcessoSocorro),
  foreign key (numMeio, nomeEntidade, numProcessoSocorro)
    references Acciona(numMeio, nomeEntidade, numProcessoSocorro),
  foreign key (idCoordenador)
    references Coordenador(idCoordenador),
  check (datahoraInicio < datahoraFim), /* os checks sao assim? */
  check (dataAuditoria <= (current_date))
);



create table Solicita (
  idCoordenador integer,
  dataHoraInicioVideo timestamp,
  numCamara integer,
  dataHoraInicio timestamp,
  dataHoraFim timestamp,
  primary key (idCoordenador, dataHoraInicioVideo, numCamara),
  foreign key (idCoordenador)
    references Coordenador(idCoordenador),
  foreign key (dataHoraInicioVideo, numCamara)
    references Video(dataHoraInicio, numCamara)
);

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */