

CREATE VIEW vw_lotes AS 
SELECT 
    p.nombreproducto, 
    l.stockactual, 
    l.numlote
FROM 
    productos p
INNER JOIN 
    lotes l ON p.idproducto = l.idproducto
WHERE 
    l.estado='Agotado' OR l.estado='Por Agotarse'
;




DROP PROCEDURE IF EXISTS sp_generar_notificaciones;


CREATE PROCEDURE sp_generar_notificaciones()
BEGIN
    INSERT INTO notificaciones (mensaje)
    SELECT 
        CONCAT(
            'El producto "', nombreproducto, 
            '" del lote "', numlote, 
            '" está en estado crítico con un stock de ', stockactual, '.'
        )
    FROM vw_lotes
    WHERE NOT EXISTS (
        SELECT 1 
        FROM notificaciones 
        WHERE mensaje = CONCAT(
            'El producto "', nombreproducto, 
            '" del lote "', numlote, 
            '" está en estado crítico con un stock de ', stockactual, '.'
        )
    );
END ;


call sp_generar_notificaciones();
DROP PROCEDURE IF EXISTS sp_leer_notificacion;

CREATE PROCEDURE sp_leer_notificacion
(
	IN _leido  TINYINT(1),
    IN _idnotificacion INT
)
BEGIN
	UPDATE notificaciones 
    SET leido=_leido,
    update_at=NOW()
    WHERE idnotificacion=_idnotificacion;
END;