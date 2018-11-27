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