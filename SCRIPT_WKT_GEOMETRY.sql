Select * from sys.spatial_reference_systems

SELECT DISTINCT unit_of_measure, unit_conversion_factor
FROM sys.spatial_reference_systems;

DECLARE @g geometry;  
SET @g = geometry::STGeomFromText('LINESTRING(0 0, 2 3)', 0);  
SELECT @g.STAsText(); 

SELECT geometry::STGeomFromText(A.Shape.STAsText(),4326) FROM Infraestructura.ACOMETIDA A
SELECT geometry::STGeomCollFromText(Shape.ToString(),4326) FROM Infraestructura.ACOMETIDA 
SELECT geometry::STLineFromText(Shape.STAsText(),4326) FROM Infraestructura.ACOMETIDA 
--STLineFromText

SELECT geometry::STMPolyFromText(Shape.ToString(),0) FROM Red.TERMINAL 