/* = = = = = = = = = = = = = = = = Indices = = = = = = = = = = = = = = = = */
drop index if exists cam_Video_idx cascade;
drop index if exists cam_Video_idx_hash cascade;
drop index if exists camLcl_Vigia_idx cascade;

drop index if exists numSOS_Transporta_idx cascade;
drop index if exists numSOS_Transporta_idx_hash cascade;
drop index if exists numSOS_Emergencia_idx cascade;
drop index if exists numSOS_Emergencia_idx_hash cascade;
drop index if exists phone_Emergencia_idx cascade;
drop index if exists phone_Emergencia_idx_hash cascade;
drop index if exists chamada_Emergencia_idx cascade;
drop index if exists chamada_Emergencia_idx_hash cascade;
drop index if exists composto_Emergencia_idx cascade;

/*
create index cam_Video_idx on Video (numCamara);
create index cam_Video_idx_hash on Video using hash (numCamara);
create index camLcl_Vigia_idx on Vigia (moradaLocal, numCamara);

*/
create index numSOS_Transporta_idx on Transporta (numProcessoSocorro);
create index numSOS_Transporta_idx_hash on Transporta using hash (numProcessoSocorro);
create index numSOS_Emergencia_idx on EventoEmergencia (numProcessoSocorro);
create index numSOS_Emergencia_idx_hash on EventoEmergencia using hash (numProcessoSocorro);
create index phone_Emergencia_idx on eventoEmergencia (numTelefone);
create index phone_Emergencia_idx_hash on eventoEmergencia using hash (numTelefone);
create index chamada_Emergencia_idx on eventoEmergencia (instanteChamada);
create index chamada_Emergencia_idx_hash on eventoEmergencia using hash (instanteChamada);
create index composto_Emergencia_idx on EventoEmergencia (numTelefone, instanteChamada);
/**/
/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */


