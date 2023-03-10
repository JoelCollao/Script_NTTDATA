/* ACOMETIDA PLANEADA */
SELECT DISTINCT
ACO.ID_ACOMETIDA AS ID,
ACO.DISTANCIA_ESTIMADA,
ACO.DISTANCIA_REAL,
PA.ID_PA AS ID_PUNTO_ACCESO,
DPA.NOMBRE AS TIPO_PUNTO_ACCESO,
PA.CODIGO AS CODIGO_PUNTO_ACCESO,
CASE 
	WHEN DPA.NOMBRE='POSTE' THEN POS.Shape.STAsText()
	WHEN DPA.NOMBRE='CAMARA' THEN CAMA.Shape.STAsText()
	WHEN DPA.NOMBRE='FACHADA' THEN FA.Shape.STAsText()
	WHEN DPA.NOMBRE='GENERICO' THEN PAG.Shape.STAsText()
	WHEN DPA.NOMBRE='SITE_HOLDER' THEN SI.Shape.STAsText()
	WHEN DPA.NOMBRE='PEDESTAL' THEN PED.Shape.STAsText()
	WHEN DPA.NOMBRE='DERIVACION_BANCO_DUCTOS' THEN DBD.Shape.STAsText()
	ELSE POS.Shape.STAsText()
END AS REP_GRAFICA_PUNTO_DE_ACCESO,
PR.ID_PREDIAL AS ID_NUMERO_PREDIAL,
PR.NORMALIZADO AS CODIGO_CALLE,
PR.NUMERO AS NUMERO_PREDIAL,
DI.NOMBRE AS DISTRITO,
PR.Shape.STX AS X,
PR.Shape.STY AS Y,
ACO.OBSERVACION,
ACO.OBSERVACION2,
T.ID_TERMINAL,
DTE.NOMBRE AS TIPO_DE_TERMINAL, -- DEBE IR EL DOMINIO DEL TERMINAL
T.CODIGO AS COD_TERMINAL,
U.COMPLEMENTO_HORIZONTAL,
U.CH_COMPLEMENTO_VERTICAL_1,
CASE WHEN U.COMPLEMENTO_HORIZONTAL IS NOT NULL THEN U.CH_COMPLEMENTO_VERTICAL_1 ELSE U.COMPLEMENTO_VERTICAL_1 END AS COMPLEMENTO_VERTICAL_1,
CASE WHEN U.COMPLEMENTO_HORIZONTAL IS NOT NULL THEN U.CH_COMPLEMENTO_VERTICAL_2 ELSE U.COMPLEMENTO_VERTICAL_2 END AS CH_COMPLEMENTO_VERTICAL_2,
U.COMPLEMENTO_VERTICAL_2,
U.CLIENTE,
ACO.Shape.STAsText() AS COORDENADAS_ACOMETIDA
FROM Infraestructura.ACOMETIDA ACO
JOIN Cartografia.PREDIAL PR ON PR.ID_PREDIAL = ACO.ID_PREDIAL
JOIN Cartografia.UIP U ON U.ID_PREDIAL = PR.ID_PREDIAL
JOIN Cartografia.DISTRITO DI ON DI.ID_DISTRITO = PR.ID_DISTRITO
JOIN RED.TERMINAL T ON T.ID_TERMINAL = ACO.ID_TERMINAL
JOIN RED.DOM_TIPO_TERMINAL DTE ON DTE.ID_TIPO_TERMINAL = T.ID_TIPO_TERMINAL
JOIN Infraestructura.PA PA ON PA.ID_PA = T.ID_PA
JOIN Infraestructura.DOM_TIPO_PA DPA ON DPA.ID_TIPO_PA = PA.ID_TIPO_PA
-- las infraestructuras con las que hace JOIN por ID_PA
LEFT JOIN Infraestructura.POSTE POS ON POS.ID_PA = PA.ID_PA
LEFT JOIN Infraestructura.CAMARA CAMA ON CAMA.ID_PA = PA.ID_PA
LEFT JOIN Infraestructura.PEDESTAL PED ON PED.ID_PA = PA.ID_PA
LEFT JOIN Infraestructura.DERIVACION_BANCO_DUCTOS DBD ON DBD.ID_PA = PA.ID_PA
LEFT JOIN Infraestructura.PUNTO_ACCESO_GENERICO PAG ON PAG.ID_PA = PA.ID_PA
LEFT JOIN Infraestructura.FACHADA FA ON FA.ID_PA = PA.ID_PA
LEFT JOIN Infraestructura.SITE_HOLDER SI ON SI.ID_PA = PA .ID_PA
--WHERE ACO.ID_ACOMETIDA in (469724)
--WHERE DPA.NOMBRE='SITE_HOLDER'
WHERE PR.ID_PREDIAL = 5855461 
/*
SELECT * FROM Infraestructura.PUNTO_ACCESO_GENERICO PAG
WHERE PAG.ID_PA = 133753

SELECT * FROM Infraestructura.PA PAS
WHERE PAS.ID_PA = 133753

select POST.Shape.STX from Infraestructura.POSTE POST

SELECT * FROM Infraestructura.DOM_TIPO_PA*/