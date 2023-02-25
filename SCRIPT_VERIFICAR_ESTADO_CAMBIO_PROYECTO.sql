SELECT PR.CODIGO,EP.NOMBRE FROM RED.PROYECTO PR
JOIN RED.DOM_ESTADO_PROYECTO EP ON EP.ID_ESTADO_PROYECTO = PR.ID_ESTADO_PROYECTO
WHERE PR.CODIGO IN (
'21-0410900033FO'
,'22-2111200064FO'
,'22-2111100592FO'
,'22-2167088763FO'
,'22-2123716772FO'
,'P-22-2182944322FO'
,'21-0410900056FO'
,'21-0410900060FO'
,'21-0410900046FO'
,'22-2161488083FO'
,'22-2110900209FO'
,'22-2110900237FO'
,'22-2110900083FO'
,'P-22-5446435158FO')


