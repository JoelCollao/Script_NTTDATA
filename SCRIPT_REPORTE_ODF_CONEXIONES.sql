SELECT  
Q.Cod_Sitio, 
O.ID_ODF,
O.CODIGO AS CodigoODF, 
O.PISO,
O.SALA ,
P.ID_PUERTO_ODF,
P.MODULO,                                 
P.BANDEJA,
P.PUERTO AS PuertoDGO_Posición,  
TC.ID_TRAMO_CABLE,                                 
TC.CODIGO,   
LastNodeID AS PuertoODF,  
TC.FIBRAS,
Q.Cuenta,
P.NOMBRE_COMPLETO AS CodigoPuertoODF
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
LAST_VALUE(fi.CODIGO_SITIO) WITHIN GROUP (GRAPH PATH) AS Cod_Sitio,  
LAST_VALUE(fi.CUENTA) WITHIN GROUP (GRAPH PATH) AS Cuenta,
LAST_VALUE(Puerto2.$node_id) WITHIN GROUP (GRAPH PATH) AS NodoODF                            
FROM                                
Red.PUERTO AS Puerto1,                                
(SELECT * FROM Red.FIBRA 

/*WHERE CODIGO_SITIO='SJ-SAN JOSE') */ ) FOR PATH as fi,                                
Red.PUERTO FOR PATH  AS Puerto2                            
WHERE MATCH(SHORTEST_PATH(Puerto1(-(fi)->Puerto2)+))                           
--AND Puerto1.ID_EQUIPO = 1445695

) AS Q 
LEFT JOIN Red.PUERTO_ODF P ON Q.LastNodeID = P.ID_PUERTO_ODF                                
LEFT JOIN Red.ODF  O ON P.ID_ODF = O.ID_ODF                               
LEFT JOIN Red.TERMINAL  T ON Q.idTerminal = T.ID_TERMINAL                               
LEFT JOIN Infraestructura.SITE_HOLDER  S ON O.ID_SITE_HOLDER = S.ID_SITE_HOLDER                               
LEFT JOIN Cartografia.PREDIAL P1 ON T.ID_PREDIAL = P1.ID_PREDIAL                               
LEFT JOIN Cartografia.PREDIAL P2 ON S.ID_NUMERO_PREDIAL = P2.ID_PREDIAL                               
LEFT JOIN Red.TRAMO_DE_CABLE TC ON Q.FirstCableID = TC.ID_TRAMO_CABLE                                                       
WHERE 
--Q.LastNode = 0 
--AND
TC.ID_TRAMO_CABLE = 542287 
AND Q.Cod_Sitio = 'SJ-SAN JOSE'
AND O.CODIGO =  'PG_SJODF01'