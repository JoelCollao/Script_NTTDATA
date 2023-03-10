SELECT TR.OBJECTID
      ,TR.ID_TERMINAL as TR__ID_TERMINAL
      ,TR.ID_TIPO_PROPIEDAD as TR__ID_TIPO_PROPIEDAD
      ,TR.ID_PROPIETARIO as TR__ID_PROPIETARIO
      ,TR.ID_SITUACION as TR__ID_SITUACION
      ,TR.ID_PA as TR__ID_PA
      ,TR.ID_TIPO_TERMINAL as TR__ID_TIPO_TERMINAL
      ,TR.ID_PREDIAL as TR__ID_PREDIAL
      ,TR.ID_FUNCION_TERMINAL as TR__ID_FUNCION_TERMINAL
      ,TR.ID_PROYECTO as TR__ID_PROYECTO
      ,TR.CODIGO as TR__CODIGO
      ,TR.PISO as TR__PISO
	  ,TR.NUM_DIVISORES_1N as TR__NUM_DIVISORES_1N
	  ,TR.NUM_DIVISORES_2N as TR__NUM_DIVISORES_2N
      ,TR.OBSERVACION as TR__OBSERVACION
      ,TR.OBSERVACION2 as TR__OBSERVACION2
      ,TR.RUTA as TR__RUTA
      ,TR.FIBRAS_ASIGNADAS as TR__FIBRAS_ASIGNADAS
      ,TR.FIBRAS_DEFECTUOSAS as TR__FIBRAS_DEFECTUOSAS
      ,TR.FIBRAS_LIBRES as TR__FIBRAS_LIBRES
      ,TR.FIBRAS_OCUPADAS as TR__FIBRAS_OCUPADAS
      ,TR.FIBRAS_RESERVADAS as TR__FIBRAS_RESERVADAS
      ,TR.FECHA_ALTA as TR__FECHA_ALTA
      ,TR.FECHA_ACT as TR__FECHA_ACT
      ,TR.Shape
      ,TR.GDB_GEOMATTR_DATA as TR__GDB_GEOMATTR_DATA
      ,TR.ID_CLASIFICACION_TERMINAL as TR__ID_CLASIFICACION_TERMINAL
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
  FROM Red.TERMINAL TR, Infraestructura.PA PA, red.PROYECTO PR
WHERE TR.ID_PA = PA.ID_PA AND TR.ID_PROYECTO = PR.ID_PROYECTO;
