-----------------------------------------------------------------------------------------------
CONSULTA SQL PARA OBTENER LA CONEXION DESDE UN DIVISOR DE SEGUNDO NIVEL A UN PUERTO DE ODF
-----------------------------------------------------------------------------------------------


SELECT PuertoCTO AS PuertoCTO,    
	Q.Trace as Trace,                   
	LastNodeID AS PuertoODF,        
	P.ID_PUERTO_ODF,        
	P.MODULO,       	
	P.BANDEJA,    
	P.PUERTO AS NumPuerto,    
	P.NOMBRE_COMPLETO AS CodigoPuertoODF,   
	O.ID_ODF,        
	O.CODIGO AS CodigoODF,         
	O.PISO,                  
	O.ID_SITE_HOLDER,      
	S.ID_NUMERO_PREDIAL,   
	O.SALA           
FROM


(               
	SELECT            
		Puerto1.ID_PUERTO AS PuertoCTO,     
		STRING_AGG(CONCAT(Puerto2.ID_PUERTO,',',Puerto2.ID_TIPO_EQUIPO,',',Puerto2.ID_EQUIPO,',',Puerto2.ID_TERMINAL   ), ';') WITHIN GROUP (GRAPH PATH) AS Trace,
		LAST_VALUE(Puerto2.ID_TIPO_EQUIPO) WITHIN GROUP (GRAPH PATH) AS LastNode,    
		LAST_VALUE(Puerto2.ID_EQUIPO) WITHIN GROUP (GRAPH PATH) AS LastNodeID     
	FROM                
		Red.PUERTO AS Puerto1, 
		Red.FIBRA FOR PATH AS fi,    
		Red.PUERTO FOR PATH  AS Puerto2         
	WHERE MATCH(SHORTEST_PATH(Puerto1(-(fi)->Puerto2)+))         
	AND Puerto1.ID_TIPO_PUERTO = 0 AND Puerto1.ID_EQUIPO = 170367 AND Puerto1.ID_TIPO_EQUIPO = 2       
    ) 
	
	
	AS Q 
	LEFT JOIN Red.PUERTO_ODF P ON Q.LastNodeID = P.ID_PUERTO_ODF    
	LEFT JOIN Red.ODF  O ON P.ID_ODF = O.ID_ODF             
	LEFT JOIN Infraestructura.SITE_HOLDER  S ON O.ID_SITE_HOLDER = S.ID_SITE_HOLDER       
WHERE Q.LastNode = 0

----------------------------------------------------------------------------------------------------------------------
OBSERVACIONES: (CAMBIANDO ESTOS VALORES SE PUEDEN REALIZAR DIFERENTES CONSULTAS)


-Puerto1.ID_EQUIPO = 170367 -> ES EL ID_DIVISOR DEL DIVISOR DE SEGUNDO NIVEL QUE SE QUIERE CONSULTAR. ESTE ES EL NUMERO QUE DEBERIAMOS DE CAMBIAR PARA CADA DIVISOR A CONSULTAR.
-Puerto1.ID_TIPO_EQUIPO = 2 -> ESTAMOS DICIENDO QUE EL TIPO DE EQUIPO A CONSULTAR ES UN DIVISOR DE SEGUNDO NIVEL
	LOS POSIBLES VALORE}}}}}S QUE PUEDE RECIBIR ESTE ID_TIPO_EQUIPO SON:
		ODF: 0 
        	DIVISOR1: 1
			DIVISOR2: 2
        	EMPALME: 3
        	RESERVA: 4
        	SITEHOLDER: 5
-Q.LastNode = 0 -> ESTAMOS DICIENDO QUE EL ULTIMO NODO ES UN PUERTO DE ODF       
-EN EL CAMPO Trace TENDRIAMOS TODOS LOS ELEMENTOS POR LO QUE PASA EL RECORRIDO DESDE LA CTO AL PUERTO DE ODF. CADA ELEMENTO DE ESTE RECORRIDO ESTA SEPARADO POR ';' Y A SU VEZ ESTE ELEMENTO ESTARIA SEPARADO POR ',' PARA OBTENER SUS CAMPOS:
			
			Puerto2.ID_PUERTO','Puerto2.ID_TIPO_EQUIPO','Puerto2.ID_EQUIPO','Puerto2.ID_TERMINAL