CREATE PROCEDURE Pangea_ConsultaODN_SP
AS
SET NOCOUNT ON

declare @tBorne TABLE
	(
	LINE_ID VARCHAR(100),
	VNO_CODE VARCHAR(100),
	CODIGO VARCHAR(100),
	CODIGO_DIV VARCHAR(100),
	ID_DIVISOR INT,
	CODIGO_SITIO VARCHAR(100)
	)

INSERT INTO @tBorne
(LINE_ID, VNO_CODE, ID_DIVISOR, CODIGO, CODIGO_SITIO, CODIGO_DIV)
	SELECT B.LINE_ID, B.VNO_CODE, B.ID_DIVISOR, B.CODIGO, P.CODIGO_SITIO, D.CODIGO AS CODIGO_DIV
    FROM Red.BORNE B
    LEFT JOIN Red.PUERTO P ON P.ID_EQUIPO = B.ID_DIVISOR AND P.ID_TIPO_PUERTO=0 AND P.ID_TIPO_EQUIPO=2 --TIPO_PUERTO: ENTRADA TIPO_EQUIPO: DIVISOR_N2
    LEFT JOIN Red.DIVISOR D ON D.ID_DIVISOR = B.ID_DIVISOR
              LEFT JOIN Red.TERMINAL T ON T.ID_TERMINAL = D.ID_TERMINAL
              LEFT JOIN Red.PROYECTO PY ON PY.ID_PROYECTO = T.ID_PROYECTO
    WHERE B.LINE_ID IS NOT NULL 
		AND B.LINE_ID <> '' 
		AND ID_ESTADO_PROYECTO IN (4,6)

DECLARE curBORNE CURSOR FOR
	SELECT DISTINCT ID_DIVISOR, CODIGO_SITIO
	FROM @tBorne

DECLARE 
	@LINE_ID	VARCHAR(100),
	@VNO_CODE	VARCHAR(100),
	@ID_DIVISOR INT,
	@CODIGO		VARCHAR(100),
	@CODIGO_SITIO VARCHAR(100), 
	@CODIGO_DIV	 VARCHAR(100)

DECLARE @tTrace TABLE
	(
	Trace VARCHAR(1000),
	DIVISOR_N1 VARCHAR(500),
	ID_DIVISOR INT, 
	CODIGO_SITIO VARCHAR(150),
	LastCableID VARCHAR(500),
	LastNodeID VARCHAR(500)
	)
OPEN curBORNE  
  
FETCH NEXT FROM curBORNE   
INTO @ID_DIVISOR, @CODIGO_SITIO
 
WHILE @@FETCH_STATUS = 0  
BEGIN  
	INSERT INTO @tTrace
	(Trace, DIVISOR_N1, ID_DIVISOR, CODIGO_SITIO, LastCableID, LastNodeID)
	SELECT Trace, 
	(SELECT CODIGO FROM Red.DIVISOR WHERE ID_DIVISOR=SUBSTRING(REPLACE(Q.DIVISOR_N1,'&&',''),0,CHARINDEX('|', REPLACE(Q.DIVISOR_N1,'&&','')))) AS DIVISOR_N1,
	@ID_DIVISOR, @CODIGO_SITIO, LastCableID, LastNodeID
		FROM
		(
			SELECT STRING_AGG(CONCAT(Puerto2.ID_EQUIPO,'|',Puerto2.ID_TIPO_EQUIPO,'|',fi.ID_TRAMO_CABLE,'|',fi.SENAL,'|',fi.CUENTA), '&&') WITHIN GROUP (GRAPH PATH) AS Trace,
				STRING_AGG(CASE WHEN Puerto2.ID_TIPO_EQUIPO=1 THEN CONCAT(Puerto2.ID_EQUIPO,'|') ELSE '' END, '&&') WITHIN GROUP (GRAPH PATH) AS DIVISOR_N1,
				LAST_VALUE(Puerto2.ID_TIPO_EQUIPO) WITHIN GROUP (GRAPH PATH) AS LastNode,
				LAST_VALUE(Puerto2.ID_EQUIPO) WITHIN GROUP (GRAPH PATH) AS LastNodeID,
				LAST_VALUE(fi.ID_TRAMO_CABLE) WITHIN GROUP (GRAPH PATH) AS LastCableID
			FROM Red.PUERTO AS Puerto1, --ID_DIVISOR AND ENTRADA AND TIPO_CTO
				(SELECT ID_TRAMO_CABLE, SENAL, CUENTA, CODIGO_SITIO FROM Red.FIBRA WHERE CODIGO_SITIO= @CODIGO_SITIO) FOR PATH AS fi,
				Red.PUERTO FOR PATH AS Puerto2
			WHERE Puerto1.ID_EQUIPO = @ID_DIVISOR AND Puerto1.ID_TIPO_PUERTO = 0 AND Puerto1.ID_TIPO_EQUIPO = 2
				AND MATCH(SHORTEST_PATH(Puerto1(-(fi)->Puerto2)+))
		) AS Q --CTO
		WHERE Q.LastNode = 0

	FETCH NEXT FROM curBORNE   
	INTO @ID_DIVISOR, @CODIGO_SITIO
END   
CLOSE curBORNE;  
DEALLOCATE curBORNE;  

SELECT	q.Trace, q.DIVISOR_N1, p.NOMBRE_COMPLETO as CodigoPuertoODF, C.CODIGO as CODIGO_CABLE_ODF, 
		b.LINE_ID, b.VNO_CODE, b.CODIGO, b.CODIGO_DIV, b.ID_DIVISOR, b.CODIGO_SITIO 
FROM @tTrace AS Q inner join @tBorne b
	on q.ID_DIVISOR = b.ID_DIVISOR
	and q.CODIGO_SITIO = b.CODIGO_SITIO
LEFT JOIN Red.PUERTO_ODF P ON Q.LastNodeID = P.ID_PUERTO_ODF
LEFT JOIN Red.TRAMO_DE_CABLE C ON Q.LastCableID = C.ID_TRAMO_CABLE