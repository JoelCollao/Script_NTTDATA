SELECT AG.OBJECTID
	,AG.ID_PUNTO_ACCESO_GENERICO as AG__ID_PUNTO_ACCESO_GENERICO
	,AG.OBSERVACION as AG__OBSERVACION
	,AG.OBSERVACION2 as AG__OBSERVACION2
	,AG.ID_LOCALIZACION as AG__ID_LOCALIZACION
	,AG.ID_TIPO_PROPIEDAD as AG__ID_TIPO_PROPIEDAD
	,AG.ID_PROPIETARIO as AG__ID_PROPIETARIO
	,AG.ID_PA as AG__ID_PA
	,AG.FECHA_ALTA as AG__FECHA_ALTA
	,AG.FECHA_ACT as AG__FECHA_ACT
	,AG.Shape
    ,PA.OBJECTID as PA__OBJECTID
    ,PA.ID_PA as PA__ID_PA
    ,PA.ID_TIPO_PA as PA__ID_TIPO_PA
    ,PA.FECHA_ALTA as PA__FECHA_ALTA
    ,PA.FECHA_ACT as PA__FECHA_ACT
    ,PA.CODIGO as PA__CODIGO
    ,PR.ID_PROYECTO as PR__ID_PROYECTO
    ,PR.ID_ESTADO_PROYECTO as PR__ID_ESTADO_PROYECTO
    ,PR.ID_TIPO_PROYECTO as PR__ID_TIPO_PROYECTO
    ,PR.ID_CARACTERISTICA as PR__ID_CARACTERISTICA
    ,PR.CODIGO as PR__CODIGO
FROM Infraestructura.PUNTO_ACCESO_GENERICO AG, Infraestructura.PA PA, Red.PROYECTO PR
WHERE AG.ID_PA = PA.ID_PA AND AG.ID_PROYECTO = PR.ID_PROYECTO;
