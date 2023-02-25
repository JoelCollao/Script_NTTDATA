---REPORTE A TRAMO DUCTO CABLE
SELECT * FROM Red.TRAMO_DE_CABLE TC
JOIN RED.TRAMO_CABLE_DUCTO TCD ON TCD.ID_TRAMO_CABLE = TC.ID_TRAMO_CABLE
JOIN Infraestructura.DUCTO D ON D.ID_DUCTO = TCD.ID_DUCTO
WHERE TC.ID_TRAMO_CABLE = 560081

SELECT * FROM Infraestructura.DUCTO

----  REPORTE TRAMO PUNTO DE ACCESO
SELECT DISTINCT
TC.ID_TRAMO_CABLE,
TC.CODIGO,
PA.ID_PA,
DPA.NOMBRE,
PA.CODIGO,
PR.ID_PROYECTO,
PR.CODIGO,
DTC.NOMBRE
FROM RED.TRAMO_DE_CABLE TC
JOIN RED.TRAMO_CABLE_PA TCPA ON TCPA.ID_TRAMO_CABLE = TC.ID_TRAMO_CABLE
JOIN RED.DOM_TIPO_CABLE DTC ON DTC.ID_TIPO_CABLE = TC.ID_TIPO_CABLE
JOIN RED.PROYECTO PR ON PR.ID_PROYECTO = TC.ID_PROYECTO
JOIN Infraestructura.PA PA ON PA.ID_PA IN (TCPA.ID_PA_ORIGEN,TCPA.ID_PA_DESTINO)
JOIN Infraestructura.DOM_TIPO_PA DPA ON DPA.ID_TIPO_PA = PA.ID_TIPO_PA
WHERE TC.ID_TRAMO_CABLE = 541580




SELECT * FROM RED.TRAMO_CABLE_PA  TCPA--75550
WHERE TCPA.ID_TRAMO_CABLE = 541580


SELECT
TC.ID_TRAMO_CABLE,
TC.CODIGO,
--COUNT(FB.NUMERO) AS CANTIDAD_FIBRAS_CABLE, -- CONSULTAR CON KEVIN
TC.FIBRAS AS CANTIDAD_FIBRAS_CABLE,
FB.NUMERO,
FB.SENAL,
FB.CUENTA,
FB.CODIGO_SITIO
FROM [RED].[TRAMO_DE_CABLE] TC
    JOIN [RED].[FIBRA] FB ON FB.ID_TRAMO_CABLE = TC.ID_TRAMO_CABLE
WHERE TC.ID_TRAMO_CABLE = 541580
GROUP BY TC.ID_TRAMO_CABLE, TC.CODIGO,FB.NUMERO,FB.SENAL,FB.CUENTA,FB.CODIGO_SITIO,TC.FIBRAS

SELECT * FROM Infraestructura.DUCTO