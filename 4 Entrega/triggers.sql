/* = = = = = = = = = = = = = = Funcoes Callback = = = = = = = = = = = = = = */

/* Um Coordenador só pode solicitar vídeos de câmaras colocadas num local cujo
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
    using hint = 'Um Coordenador so pode solicitar vídeos de camaras colocadas ' ||
                 'num local cujo acionamento de meios esteja a ser (ou tenha '   ||
                 'sido) auditado por ele proprio.';
  end if;

  return new;
end;
$body$ language plpgsql;



/* Um Meio de Apoio só pode ser alocado a Processos de Socorro para os quais
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
    using hint = 'Um Meio de Apoio só pode ser alocado a Processos de Socorro para ' ||
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

/* check_Solicita_trigger */

select idCoordenador
from Vigia natural join EventoEmergencia natural join Audita
order by idCoordenador;

select numCamara
from Vigia natural join EventoEmergencia natural join Audita
where idCoordenador = 1
order by numCamara;

select *
from Vigia natural join EventoEmergencia natural join Audita
where idCoordenador = 1 and numCamara = 116;

select *
from Video
where numCamara = 116;

insert into Solicita values (1, timestamp '2018-10-9 19:26:16', 116, timestamp '2018-12-06 15:46:00', timestamp '2018-12-06 16:00:00');

insert into Solicita values (1, timestamp '2018-10-9 19:26:16', 1, timestamp '2018-12-06 15:46:00', timestamp '2018-12-06 16:00:00');


/* check_Alocado_trigger */


/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */
