SELECT PO.OBJECTID
	,PO.ID_POSTE as PO__ID_POSTE
	,PO.ID_TIPO_POSTE as PO__ID_TIPO_POSTE
	,PO.ID_MATERIAL_POSTE as PO__ID_MATERIAL_POSTE
	,PO.ALTURA as PO__ALTURA
	,PO.NUMERO_APOYOS as PO__NUMERO_APOYOS
	,PO.PUNTOS_APOYO_OCUPADOS as PO__PUNTOS_APOYO_OCUPADOS
	,PO.ESTADO_APOYO as PO__ESTADO_APOYO
	,PO.ID_MATERIAL_APOYO as PO__ID_MATERIAL_APOYO
	,PO.RUTA as PO__RUTA
	,PO.OBSERVACION as PO__OBSERVACION
	,PO.ID_TIERRA as PO__ID_TIERRA
	,PO.ID_LOCALIZACION as PO__ID_LOCALIZACION
	,PO.ID_TIPO_PROPIEDAD as PO__ID_TIPO_PROPIEDAD
	,PO.ID_PROPIETARIO as PO__ID_PROPIETARIO
	,PO.ID_SITUACION as PO__ID_SITUACION
	,PO.ID_PROYECTO as PO__ID_PROYECTO
	,PO.ID_PA as PO__ID_PA
	,PO.FECHA_ALTA as PO__FECHA_ALTA
	,PO.FECHA_ACT as PO__FECHA_ACT
	,PO.Shape
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
FROM Infraestructura.POSTE PO, Infraestructura.PA PA, red.PROYECTO PR
WHERE PO.ID_PA = PA.ID_PA AND PO.ID_PROYECTO = PR.ID_PROYECTO;
