/* = = = = = = = = = = = = = = = = Indices = = = = = = = = = = = = = = = = */

drop index if exists cam_Video_idx cascade;
drop index if exists camLcl_Vigia_idx cascade;
drop index if exists numSOS_Transporta_idx cascade;
drop index if exists numSOS_Emergencia_idx cascade;
drop index if exists telInstCha_Emergencia_idx cascade;

/*create index cam_Video_idx on Video (numCamara);
create index camLcl_Vigia_idx on Vigia (moradaLocal, numCamara);
*/
create index numSOS_Transporta_idx on Transporta (numProcessoSocorro);
create index numSOS_Emergencia_idx on EventoEmergencia (numProcessoSocorro);
/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */
