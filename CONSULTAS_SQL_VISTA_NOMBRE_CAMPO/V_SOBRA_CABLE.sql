SELECT SC.OBJECTID
	,SC.ID_SOBRA_CABLE as SC__ID_SOBRA_CABLE
	,SC.ID_TRAMO_CABLE as SC__ID_TRAMO_CABLE
	,SC.ID_PA as SC__ID_PA
	,SC.ID_PROYECTO as SC__ID_PROYECTO
	,SC.CODIGO as SC__CODIGO
	,SC.ID_TIPO_INSTALACION as SC__ID_TIPO_INSTALACION
	,SC.LONGITUD as SC__LONGITUD
	,SC.OBSERVACION as SC__OBSERVACION
	,SC.ID_SITUACION as SC__ID_SITUACION
	,SC.FECHA_ALTA as SC__FECHA_ALTA
	,SC.FECHA_ACT as SC__FECHA_ACT
	,SC.Shape
	,TC.ID_TRAMO_CABLE as TC__ID_TRAMO_CABLE
	,TC.CODIGO as TC__CODIGO
	,TC.ID_TIPO_CABLE as TC__ID_TIPO_CABLE
	,TC.ID_TIPO_RED as TC__ID_TIPO_RED
	,TC.ID_PROYECTO as TC__ID_PROYECTO
	,TC.ID_TIPO_INSTALACION as TC__ID_TIPO_INSTALACION
	,TC.FIBRAS as TC__FIBRAS
	,TC.LONGITUD_ESTIMADA as TC__LONGITUD_ESTIMADA
	,TC.LONGITUD_REAL as TC__LONGITUD_REAL
	,TC.LONGITUD_REAL_CON_SOBRA as TC__LONGITUD_REAL_CON_SOBRA
	,TC.RUTA as TC__RUTA
	,TC.STUB as TC__STUB
	,TC.FECHA_ALTA as TC__FECHA_ALTA
	,TC.FECHA_ACT as TC__FECHA_ACT
	,TC.ACOMETIDA as TC__ACOMETIDA
	,TC.OBSERVACION as TC__OBSERVACION
	,TC.OBSERVACION2 as TC__OBSERVACION2
	,TC.ID_TIPO_PROPIEDAD as TC__ID_TIPO_PROPIEDAD
	,TC.ID_PROPIETARIO as TC__ID_PROPIETARIO
	,TC.ID_SITUACION as TC__ID_SITUACION
	,PR.ID_PROYECTO as PR__ID_PROYECTO
	,PR.CODIGO as PR__CODIGO
	,PR.ID_TIPO_PROYECTO as PR__ID_TIPO_PROYECTO
	,PR.ID_ESTADO_PROYECTO as PR__ID_ESTADO_PROYECTO
	,PR.ID_CARACTERISTICA as PR__ID_CARACTERISTICA
	,PA.ID_TIPO_PA as PA__ID_TIPO_PA
FROM Red.SOBRA_DE_CABLE SC, Red.TRAMO_DE_CABLE TC, Red.PROYECTO PR, Infraestructura.PA PA
WHERE SC.ID_TRAMO_CABLE = TC.ID_TRAMO_CABLE AND SC.ID_PROYECTO = PR.ID_PROYECTO AND SC.ID_PA = PA.ID_PA;
