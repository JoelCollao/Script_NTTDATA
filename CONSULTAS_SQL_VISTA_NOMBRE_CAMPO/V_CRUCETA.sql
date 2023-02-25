SELECT CR.OBJECTID
	,CR.ID_CRUCETA as CR__ID_CRUCETA
	,CR.ID_TIPO_CRUCETA as CR__ID_TIPO_CRUCETA
	,CR.OBSERVACION as CR__OBSERVACION
	,CR.ID_LOCALIZACION as CR__ID_LOCALIZACION
	,CR.ID_TIPO_PROPIEDAD as CR__ID_TIPO_PROPIEDAD
	,CR.ID_PROPIETARIO as CR__ID_PROPIETARIO
	,CR.ID_SITUACION as CR__ID_SITUACION
	,CR.ID_PROYECTO as CR__ID_PROYECTO
	,CR.FECHA_ALTA as CR__FECHA_ALTA
	,CR.FECHA_ACT as CR__FECHA_ACT
	,CR.Shape
    ,PR.ID_PROYECTO as PR__ID_PROYECTO
    ,PR.ID_ESTADO_PROYECTO as PR__ID_ESTADO_PROYECTO
    ,PR.ID_TIPO_PROYECTO as PR__ID_TIPO_PROYECTO
    ,PR.ID_CARACTERISTICA as PR__ID_CARACTERISTICA
    ,PR.CODIGO as PR__CODIGO
FROM Infraestructura.CRUCETA CR, Red.PROYECTO PR
WHERE CR.ID_PROYECTO = PR.ID_PROYECTO;
