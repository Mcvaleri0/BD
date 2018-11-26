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
end;
$body$ language plpgsql;

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */




/* = = = = = = = = = = = = = = = = Triggers = = = = = = = = = = = = = = = = */

create trigger check_ProcSOS_trigger
before insert or update on ProcessoSocorro
for each row execute procedure check_ProcSOS();

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */