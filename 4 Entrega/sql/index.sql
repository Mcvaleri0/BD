/* = = = = = = = = = = = = = = = = Indices = = = = = = = = = = = = = = = = */
drop index if exists nCam cascade;
drop index if exists cam_ind cascade;

drop index if exists nProc_T cascade;
drop index if exists nProc_E cascade;

/**/
create index nCam on Video using hash (numCamara);
create index cam_ind on Vigia (moradaLocal, numCamara);

/**/
create index nProc_T on Transporta (numProcessoSocorro);
create index nProc_E on EventoEmergencia (numProcessoSocorro);
/**/
/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */


