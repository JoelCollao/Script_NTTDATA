SELECT PV.OBJECTID
	,PV.ID_PROVINCIA as PV__ID_PROVINCIA
	,PV.ID_DEPARTAMENTO as PV__ID_DEPARTAMENTO
	,PV.NOMBRE as PV__NOMBRE
	,PV.CODIGO_POSTAL as PV__CODIGO_POSTAL
	,PV.Shape
	,DE.ID_DEPARTAMENTO as DE__ID_DEPARTAMENTO
	,DE.NOMBRE as DE__NOMBRE
	,DE.CODIGO_POSTAL as DE__CODIGO_POSTAL
FROM Cartografia.PROVINCIA PV, Cartografia.DEPARTAMENTO DE
WHERE PV.ID_DEPARTAMENTO = DE.ID_DEPARTAMENTO;
