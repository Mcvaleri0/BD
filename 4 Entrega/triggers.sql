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

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */




/* = = = = = = = = = = = = = = = = Triggers = = = = = = = = = = = = = = = = */

drop trigger if exists check_Solicita_trigger on Solicita cascade;

create trigger check_Solicita_trigger
before insert or update on Solicita
for each row execute procedure check_Solicita();

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */




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