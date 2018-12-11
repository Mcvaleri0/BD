/* = = = = = = = = = = = = = = Funcoes Callback = = = = = = = = = = = = = = */

/* Um Coordenador só pode solicitar videos de câmaras colocadas num local cujo
    acionamento de meios esteja a ser (ou tenha sido) auditado por ele próprio. */
create or replace function check_Solicita()
returns trigger as $body$
begin

  if not exists(
    select *
    from (Vigia natural join EventoEmergencia natural join Audita) T /* -> Cameras que o coordenador pode solicitar */
    where T.idCoordenador = new.idCoordenador and
          T.numCamara = new.numCamara
  )
  then
    raise exception 'O Coordenador % nao pode solicitar videos da camara %.',
      new.idCoordenador, new.numCamara
    using hint = 'Um Coordenador so pode solicitar videos de camaras colocadas ' ||
                 'num local cujo acionamento de meios esteja a ser (ou tenha '   ||
                 'sido) auditado por ele proprio.';
  end if;

  return new;
end;
$body$ language plpgsql;



/* Um Meio de Apoio so pode ser alocado a Processos de Socorro para os quais
    tenha sido accionado. */
create or replace function check_Alocado()
returns trigger as $body$
begin

  if not exists (
    select *
    from Acciona A
    where A.numMeio = new.numMeio and
          A.nomeEntidade = new.nomeEntidade and
          A.numProcessoSocorro = new.numProcessoSocorro
  )
  then
    raise exception 'O Meio de Apoio (%, %) nao pode ser alocado pelo Processo de Socorro %.', new.numMeio, new.nomeEntidade, new.numProcessoSocorro
    using hint = 'Um Meio de Apoio so pode ser alocado a Processos de Socorro para ' ||
                 'os quais tenha sido accionado.';
  end if;

  return new;
end;
$body$ language plpgsql;

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */




/* = = = = = = = = = = = = = = = = Triggers = = = = = = = = = = = = = = = = */

drop trigger if exists check_Solicita_trigger on Solicita cascade;
drop trigger if exists check_Alocado_trigger on Alocado cascade;


create trigger check_Solicita_trigger
before insert or update on Solicita
for each row execute procedure check_Solicita();


create trigger check_Alocado_trigger
before insert or update on Alocado
for each row execute procedure check_Alocado();

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */




/* = = = = = = = = = = = = = Queries Auxiliares = = = = = = = = = = = = = */

/* ------------------------ check_Solicita_trigger ------------------------ */

/* Insercao dos resgistos */
insert into EventoEmergencia values ('926626599', timestamp '2018-12-10 17:00:00', 'Eu', 'Aqui', 2000);

insert into Acciona values (2000, 'Entidade', 2000);

insert into Audita values (2000, 2000, 'Entidade', 2000, timestamp '2018-12-10 17:30:00', timestamp '2018-12-10 18:00:00', date '2018-12-10');

insert into Vigia values ('Aqui', 2000);


/* Verificacao da insercao */
select *
from (Vigia natural join EventoEmergencia natural join Audita) T
where T.idCoordenador = 2000 and
      T.numCamara = 2000;


/* Verificacao dos registos todos */
select *
from Solicita S
where exists (
    select *
    from (Vigia natural join EventoEmergencia natural join Audita) T
    where S.idCoordenador = T.idCoordenador and
          S.numCamara = T.numCamara );


/* NAO PODE DAR ERRO */
insert into Solicita values (2000, timestamp '2018-12-10 16:30:00', 2000, timestamp '2018-12-10 17:30:00', timestamp '2018-12-10 18:30:00');


/* TEM DE DAR ERRO */
insert into Solicita values (2000, timestamp '2018-12-10 16:30:00', 1000, timestamp '2018-12-10 17:30:00', timestamp '2018-12-10 18:30:00');

/* ------------------------------------------------------------------------- */



/* ------------------------- check_Alocado_trigger ------------------------- */

/* Insercao dos resgistos */
insert into MeioApoio values (2000, 'Entidade');


/* Verificacao da insercao */
select *
from Acciona
where nummeio = 2000 and
      nomeEntidade = 'Entidade' and
      numProcessoSocorro = 2000;


/* NAO PODE DAR ERRO */
insert into Alocado values (2000, 'Entidade', interval '2 hours', 2000);


/* TEM DE DAR ERRO */
insert into Alocado values (2000, 'Entidade', interval '2 hours', 1000);

/* ------------------------------------------------------------------------- */

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */
