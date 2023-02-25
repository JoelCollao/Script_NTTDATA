SELECT ME.OBJECTID
	,ME.ID_CABLE_MENSAJERO as ME__ID_CABLE_MENSAJERO
	,ME.ID_FUNCION_MENSAJERO as ME__ID_FUNCION_MENSAJERO
	,ME.ID_SITUACION as ME__ID_SITUACION
	,ME.ID_TIPO_PROPIEDAD as ME__ID_TIPO_PROPIEDAD
	,ME.ID_PROPIETARIO as ME__ID_PROPIETARIO
	,ME.ID_LOCALIZACION as ME__ID_LOCALIZACION
	,ME.ID_DIAMETRO_MENSAJERO as ME__ID_DIAMETRO_MENSAJERO
	,ME.ID_MATERIAL_MENSAJERO as ME__ID_MATERIAL_MENSAJERO
	,ME.ID_PROYECTO as ME__ID_PROYECTO
	,ME.LONGITUD_REAL as ME__LONGITUD_REAL
	,ME.LONGITUD_ESTIMADA as ME__LONGITUD_ESTIMADA
	,ME.OBSERVACION as ME__OBSERVACION
	,ME.FECHA_ALTA as ME__FECHA_ALTA
	,ME.FECHA_ACT as ME__FECHA_ACT
	,ME.Shape
    ,PR.ID_PROYECTO as PR__ID_PROYECTO
    ,PR.ID_ESTADO_PROYECTO as PR__ID_ESTADO_PROYECTO
    ,PR.ID_TIPO_PROYECTO as PR__ID_TIPO_PROYECTO
    ,PR.ID_CARACTERISTICA as PR__ID_CARACTERISTICA
    ,PR.CODIGO as PR__CODIGO
FROM Infraestructura.CABLE_MENSAJERO ME, Red.PROYECTO PR
WHERE ME.ID_PROYECTO = PR.ID_PROYECTO;