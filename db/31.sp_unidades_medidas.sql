USE distribumax;

DROP PROCEDURE IF EXISTS sp_registrar_unidades;
CREATE PROCEDURE sp_registrar_unidades(
  IN _unidad  VARCHAR(100)
)
BEGIN
  INSERT INTO unidades_medidas (unidadmedida)
    VALUES(_unidad);
END;

CREATE VIEW vw_unidades_medidas AS
  SELECT idunidadmedida, unidadmedida
    FROM unidades_medidas
    WHERE estado = 1 
    ORDER BY unidadmedida ASC;