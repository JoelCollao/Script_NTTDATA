SELECT    PuertoCTO    AS PuertoCTO,
          Q.TipoEquipo AS TipoEquipo,
          Equipo,
          Terminal,
          Puertos,
          LastNodeID AS PuertoODF,
          P.ID_PUERTO_ODF,
          P.MODULO,
          P.BANDEJA,
          P.PUERTO          AS NumPuerto,
          P.NOMBRE_COMPLETO AS CodigoPuertoODF,
          O.ID_ODF,
          O.CODIGO AS CodigoODF,
          O.PISO,
          O.ID_SITE_HOLDER,
          S.ID_NUMERO_PREDIAL,
          O.SALA
FROM     (
                 SELECT Puerto1.ID_PUERTO                                                 AS PuertoCTO,
                        STRING_AGG(Puerto2.ID_PUERTO, ';') WITHIN GROUP (GRAPH PATH)      AS Puertos,
                        STRING_AGG(Puerto2.ID_TIPO_EQUIPO, ';') WITHIN GROUP (GRAPH PATH) AS TipoEquipo,
                        STRING_AGG(Puerto2.ID_EQUIPO, ';') WITHIN GROUP (GRAPH PATH)      AS Equipo,
                        STRING_AGG(Puerto2.ID_TERMINAL, ';') WITHIN GROUP (GRAPH PATH)    AS Terminal,
                        LAST_VALUE(Puerto2.ID_TIPO_EQUIPO) WITHIN GROUP (GRAPH PATH)      AS LastNode,
                        LAST_VALUE(Puerto2.ID_EQUIPO) WITHIN GROUP (GRAPH PATH)           AS LastNodeID
                 FROM   Red.PUERTO                                                        AS Puerto1,
                        Red.FIBRA FOR PATH                                                AS fi,
                        Red.PUERTO FOR PATH                                               AS Puerto2
                 WHERE  MATCH(SHORTEST_PATH(Puerto1(-(fi)->Puerto2)+))
                 AND    Puerto1.ID_TIPO_PUERTO = 0 --TIPO DE PUERTO DE ENTRADA (divisor de CTO)
                 AND    Puerto1.ID_EQUIPO = 172497 ) AS Q --ESTE ID EQUIPO ES EL ID_DIVISOR
LEFT JOIN Red.PUERTO_ODF P ON Q.LastNodeID = P.ID_PUERTO_ODF
LEFT JOIN Red.ODF O ON P.ID_ODF = O.ID_ODF
LEFT JOIN Infraestructura.SITE_HOLDER S ON O.ID_SITE_HOLDER = S.ID_SITE_HOLDER
WHERE Q.LastNode = 0 -- EL NODO FINAL ES EL PUERTO DE ODF


select * from red.divisor where id_TERMINAL = 177887