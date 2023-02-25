SELECT PuertoCTO AS PuertoCTO,                                 
idTerminal,                                 
T.CODIGO as codigoTerminal,                                 
T.ID_TIPO_TERMINAL as tipoTerminal,                                 
(SELECT STRING_AGG(ID_CLASIFICACION_TERMINAL, ';') from Red.TERMINAL TE WHERE TE.ID_TERMINAL IN (SELECT CONVERT(int, value) FROM string_split(Q.Terminal, ';'))) AS clasificacionTerminal,
T.ID_PREDIAL as predioTerminal,                                 
P1.NORMALIZADO as normalizadoPredioTerminal,                                         
T.Shape.STDistance(geometry::STGeomFromText('POINT(-76.9870251 -12.0780733)', 4326))*111139 as distanciaTerminal,                                 
TC1.CODIGO as codigoCable,                                 
TC1.ID_TRAMO_CABLE as Cable,                                 
TC2.CODIGO as codigoCableODF,                                 
TC2.ID_TRAMO_CABLE as CableODF,                                 
TraceFiber,                                 
Q.TipoEquipo as TipoEquipo,                                 
Equipo,                                 
Terminal,                                 
Puertos,                                 
LastNodeID AS PuertoODF,                                 
P.ID_PUERTO_ODF,                                 
P.MODULO,                                 
P.BANDEJA,                                 
P.ID_ESTADO_OCUPACION AS estadoPuertoODF,                                 
P.PUERTO AS NumPuerto,                                 
P.NOMBRE_COMPLETO AS CodigoPuertoODF,                                 
O.ID_ODF,                                 
O.CODIGO AS CodigoODF,                                 
O.PISO,                                 
O.ID_SITE_HOLDER,                                 
S.ID_NUMERO_PREDIAL,                                 
S.CODIGO AS codURA,                                 
P2.NORMALIZADO as normalizadoPredioODF,                                 
O.SALA                         
FROM(                            
SELECT                                
Puerto1.ID_PUERTO AS PuertoCTO,                                
Puerto1.ID_TERMINAL AS idTerminal,                                
Puerto1.$node_id AS NodoPuerto,                                
STRING_AGG(Puerto2.ID_PUERTO, ';') WITHIN GROUP (GRAPH PATH) AS Puertos,                                
STRING_AGG(Puerto2.ID_TIPO_EQUIPO, ';') WITHIN GROUP (GRAPH PATH) AS TipoEquipo,                                
STRING_AGG(Puerto2.ID_EQUIPO, ';') WITHIN GROUP (GRAPH PATH) AS Equipo,                                
STRING_AGG(Puerto2.ID_TERMINAL, ';') WITHIN GROUP (GRAPH PATH) AS Terminal,                                
LAST_VALUE(Puerto2.ID_TIPO_EQUIPO) WITHIN GROUP (GRAPH PATH) AS LastNode,                                
STRING_AGG(CONCAT(fi.ID_FIBRA,',',fi.NUMERO), ';') WITHIN GROUP (GRAPH PATH) AS TraceFiber,                                
(SELECT TOP 1 * FROM STRING_SPLIT(STRING_AGG(fi.ID_TRAMO_CABLE, ';') WITHIN GROUP (GRAPH PATH),';')) AS FirstCableID,                                
LAST_VALUE(Puerto2.ID_EQUIPO) WITHIN GROUP (GRAPH PATH) AS LastNodeID,                                
LAST_VALUE(fi.ID_TRAMO_CABLE) WITHIN GROUP (GRAPH PATH) AS LastCableID,                                
LAST_VALUE(Puerto2.$node_id) WITHIN GROUP (GRAPH PATH) AS NodoODF                            
FROM                                
Red.PUERTO AS Puerto1,                                
(SELECT * FROM Red.FIBRA where CODIGO_SITIO='SB-SAN BORJA') FOR PATH as fi,                                
Red.PUERTO FOR PATH  AS Puerto2                            
WHERE MATCH(SHORTEST_PATH(Puerto1(-(fi)->Puerto2)+))                            
AND Puerto1.ID_TIPO_EQUIPO = 4 
AND Puerto1.ID_EQUIPO = 193245) AS Q 
LEFT JOIN Red.PUERTO_ODF P ON Q.LastNodeID = P.ID_PUERTO_ODF                                
LEFT JOIN Red.ODF  O ON P.ID_ODF = O.ID_ODF                               
LEFT JOIN Red.TERMINAL  T ON Q.idTerminal = T.ID_TERMINAL                               
LEFT JOIN Infraestructura.SITE_HOLDER  S ON O.ID_SITE_HOLDER = S.ID_SITE_HOLDER                               
LEFT JOIN Cartografia.PREDIAL P1 ON T.ID_PREDIAL = P1.ID_PREDIAL                               
LEFT JOIN Cartografia.PREDIAL P2 ON S.ID_NUMERO_PREDIAL = P2.ID_PREDIAL                               
LEFT JOIN Red.TRAMO_DE_CABLE TC1 ON Q.FirstCableID = TC1.ID_TRAMO_CABLE                               
LEFT JOIN Red.TRAMO_DE_CABLE TC2 ON Q.LastCableID = TC2.ID_TRAMO_CABLE                        
WHERE Q.LastNode = 0 
ORDER BY idTerminal 




