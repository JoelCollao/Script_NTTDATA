SELECT DISTINCT
PRO.CODIGO,
TRED.NOMBRE,-- primer nivel
DV.ID_DIVISOR AS ID_DivisorN2,  --- LLAVE PARA EL STOREPROCEDURE
DV.CODIGO AS DivisorN2,
TR.ID_TERMINAL AS ID_TerminalN2,
SUBSTRING(DV.CODIGO,1,6) AS TerminalN2,
FTR.NOMBRE AS Funci�n,
TTR.NOMBRE AS Tipo,
--PuertoN1 (SP)
PA.CODIGO AS PA_TerminalN1,
--Cable Secundario (SP)
--Hilo Secundario (SP)
TR2.NOMBRE2,-- primer nivel
TR2.ID_DIVISOR as ID_DivisorN1,
TR2.COD as DivisorN1,
TR2.ID_TERMINAL as ID_TerminalN1,
TR2.CODIGO AS TerminalN1
FROM (SELECT DI.ID_DIVISOR,DI.CODIGO as COD,T.ID_TERMINAL,T.CODIGO,TRED2.NOMBRE AS NOMBRE2,T.ID_PROYECTO FROM RED.TERMINAL T
		JOIN RED.DIVISOR DI ON DI.ID_TERMINAL = T.ID_TERMINAL
		JOIN RED.DOM_TOPOLOGIA_RED TRED2 ON TRED2.ID_TOPOLOGIA_RED = DI.ID_TOPOLOGIA_RED
		WHERE DI.ID_TOPOLOGIA_RED = 1001
		) AS TR2,
Infraestructura.PUNTO_ACCESO_GENERICO PAG, Infraestructura.PA PA,RED.TERMINAL TR
JOIN [RED].PROYECTO PRO ON PRO.ID_PROYECTO =TR.ID_PROYECTO
JOIN RED.DOM_FUNCION_TERMINAL FTR ON FTR.ID_FUNCION_TERMINAL = TR.ID_FUNCION_TERMINAL
JOIN RED.DOM_TIPO_TERMINAL TTR ON TTR.ID_TIPO_TERMINAL = TR.ID_TIPO_TERMINAL
JOIN [RED].[DIVISOR] DV ON DV.ID_TERMINAL = TR.ID_TERMINAL
JOIN RED.DOM_TOPOLOGIA_RED TRED ON TRED.ID_TOPOLOGIA_RED = DV.ID_TOPOLOGIA_RED
WHERE PAG.ID_PA = PA.ID_PA 
and (SUBSTRING(TR.CODIGO,1,2) = SUBSTRING(TR2.CODIGO,1,2))
AND DV.ID_TOPOLOGIA_RED = 1002
AND DV.ID_DIVISOR = 213972
and TR.ID_PROYECTO = TR2.ID_PROYECTO
--AND TR.ID_TERMINAL = 208211

SELECT * FROM RED.DIVISOR D
WHERE D.ID_TOPOLOGIA_RED = 1001

SELECT * FROM RED.DIVISOR D
WHERE D.ID_DIVISOR = 208945


select PY.ID_PROYECTO,TR.ID_TERMINAL,DV.ID_TOPOLOGIA_RED
FROM [Red].[PROYECTO] PY
JOIN [RED].[TERMINAL] TR ON TR.ID_PROYECTO = PY.ID_PROYECTO
JOIN [RED].[DIVISOR] DV ON DV.ID_TERMINAL = TR.ID_TERMINAL
where DV.ID_DIVISOR in (208945,209022)

SELECT * FROM RED.PUERTO_ODF  ODF--PG_SMODF01-01-01-05
WHERE ODF.NOMBRE_COMPLETO = 'PG_SMODF01-01-01-05'  ---LLAVE ENTRE ISP / OSP

SELECT * FROM RED.FIBRA fi
where fi.SENAL is not null

SELECT FR.SENAL+', '+CONVERT(VARCHAR,FR.CUENTA) FROM RED.FIBRA FR
WHERE FR.SENAL IS NOT NULL
AND FR.SENAL = 'CAG300D01' 
AND FR.ID_TRAMO_CABLE = 572518
ORDER BY FR.CUENTA ASC


SELECT * FROM RED.TRAMO_DE_CABLE

SELECT * FROM RED.DIVISOR DI
WHERE DI.ID_TOPOLOGIA_RED = 1001

SELECT * FROM RED.DOM_TOPOLOGIA_RED


