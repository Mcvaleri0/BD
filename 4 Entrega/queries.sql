/* = = = = = = = = = = = = = = = = Queries = = = = = = = = = = = = = = = = */
/**/
select dataHoraInicio, dataHoraFim
from Video V, Vigia I
where V.numCamara = I.numCamara and
      V.numCamara = 10 and
      I.moradaLocal = 'Loures';

/**/
select sum(numVitimas)
from Transporta T, EventoEmergencia E
where T.numProcessoSocorro = E.numProcessoSocorro
group by numTelefone, instanteChamada;
/**/

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */



/* = = = = = = = = = = = = = = = = Explain = = = = = = = = = = = = = = = = */

explain select dataHoraInicio, dataHoraFim
from Video V, Vigia I
where V.numCamara = I.numCamara and
      V.numCamara = 10 and
      I.moradaLocal = 'Loures';

/**/
explain select sum(numVitimas)
from Transporta T, EventoEmergencia E
where T.numProcessoSocorro = E.numProcessoSocorro
group by numTelefone, instanteChamada;

/* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = */
