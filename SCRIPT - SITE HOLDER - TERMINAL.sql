/*Adjunto query donde para cada CTO, se obtiene el DIVICAU asociado y el SITE_HOLDER o Central Telefónica a los que pertenecen ambos usando la regla del prefijo o NODO del Site Holder.
*/
SELECT CTO.ID_TERMINAL AS CTO_ID_TERMINAL, CTO.CODIGO AS CTO_CODIGO, Substr(CTO.CODIGO, 1, 6) AS Prefix6, 
DIVICAU.ID_TERMINAL AS DIVICAU_ID_TERMINAL, DIVICAU.CODIGO AS DIVICAU_CODIGO,
SITE_HOLDER.ID_SITE_HOLDER , SITE_HOLDER.CODIGO AS SITE_HOLDER_CODIGO , Substr(CTO.CODIGO, 1, 2) AS Prefix2
 
FROM TERMINAL AS CTO
JOIN TERMINAL AS DIVICAU ON Prefix6 =  DIVICAU.CODIGO
JOIN SITE_HOLDER ON SITE_HOLDER.NODO = Prefix2
WHERE CTO.ID_CLASIFICACION_TERMINAL = 1001 AND DIVICAU.ID_CLASIFICACION_TERMINAL = 1002  AND SITE_HOLDER.ID_TIPO_SITE = 1002

/*Adjunto también la exportación del resultado según datos entregados el 5 de septiembre en formato Excel.

Recordar simplemente que los SITE_HOLDER

46 - JOSE GALLEZ
44 - MARIATEGA
49 - SANTA ROSA
91 -  CANTO GRANDE
94  - LOS OLIVOS

No tienen el campo NODO definido por falta de data en la entrega de TDP,  y por lo tanto no van a aparecer las CTO, ni los divicaus de esas URAS.

Un saludo, */
