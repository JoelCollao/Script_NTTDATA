SELECT COUNT(*) AS CANTIDAD,S.ID_PROPIETARIO,DTP.NOMBRE FROM Infraestructura.SITE_HOLDER S
JOIN Infraestructura.DOM_TIPO_PROPIETARIO DTP ON DTP.ID_TIPO_PROPIETARIO = S.ID_PROPIETARIO 
GROUP BY S.ID_PROPIETARIO,DTP.NOMBRE

SELECT * FROM Infraestructura.DOM_TIPO_PROPIETARIO