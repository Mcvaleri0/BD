/* Criacao das Tabelas (Schemas) */

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
	duracao integer,
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


create table ProcessoSocorro (
	numProcessoSocorro integer,
	primary key (numProcessoSocorro)
	/* Processo tem de estar associado a um ou mais EventoEmergencia */
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