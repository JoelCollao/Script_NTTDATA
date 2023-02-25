CREATE PROCEDURE Pangea_ConsultaODF_SP
AS
SET NOCOUNT ON

DECLARE curDIVISOR CURSOR FOR
	SELECT DISTINCT ID_DIVISOR
	FROM Red.DIVISOR

DECLARE 
	@ID_DIVISOR INT

DECLARE @tODF TABLE
	(
	PUERTOCTO INT,
	ID_PUERTO_ODF INT,
	MODULO VARCHAR(50),
	BANDEJA VARCHAR(50),
	CODIGOPUERTOODF VARCHAR(250), 
	ID_ODF  INT,
	CODIGOODF VARCHAR(80),
	PISO VARCHAR(10),
	SALA VARCHAR(25),
	NODO VARCHAR(2)
	)
OPEN curDIVISOR  
  
FETCH NEXT FROM curDIVISOR   
INTO @ID_DIVISOR
 
WHILE @@FETCH_STATUS = 0  
BEGIN  
	INSERT INTO @tODF
	(PUERTOCTO, ID_PUERTO_ODF, MODULO, BANDEJA, CODIGOPUERTOODF, ID_ODF, CODIGOODF, PISO, SALA, NODO)
   SELECT    PuertoCTO    AS PuertoCTO,
             P.ID_PUERTO_ODF,
             P.MODULO,
             P.BANDEJA,
             P.NOMBRE_COMPLETO AS CodigoPuertoODF,
             O.ID_ODF,
             O.CODIGO AS CodigoODF,
             O.PISO,
             O.SALA,
             S.NODO
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
                    AND    Puerto1.ID_TIPO_PUERTO = 0
                    AND    Puerto1.ID_EQUIPO = @ID_DIVISOR ) AS Q
   LEFT JOIN Red.PUERTO_ODF P ON Q.LastNodeID = P.ID_PUERTO_ODF
   LEFT JOIN Red.ODF O ON P.ID_ODF = O.ID_ODF
   LEFT JOIN Infraestructura.SITE_HOLDER S ON O.ID_SITE_HOLDER = S.ID_SITE_HOLDER
   WHERE Q.LastNode = 0

	FETCH NEXT FROM curDIVISOR   
	INTO @ID_DIVISOR
END   
CLOSE curDIVISOR;  
DEALLOCATE curDIVISOR;  

SELECT	t.PUERTOCTO, t.ID_PUERTO_ODF, t.MODULO, t.BANDEJA, t.CODIGOPUERTOODF, t.ID_ODF, t.CODIGOODF, t.PISO, t.SALA, t.NODO
FROM @tODF AS t
