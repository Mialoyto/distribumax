USE distribumax;

DROP PROCEDURE IF EXISTS `spu_obtener_acceso_usuario`;

CREATE PROCEDURE spu_obtener_acceso_usuario(IN _idperfil INT)
BEGIN
    SELECT 
       PE.idpermiso,
       MO.modulo,
       VI.ruta,
       VI.sidebaroption,
       VI.texto,
       VI.icono
    FROM permisos PE
    INNER JOIN vistas VI ON VI.idvista = PE.idvista
    LEFT JOIN modulos MO ON MO.idmodulo = VI.idmodulo
    WHERE PE.idperfil = _idperfil;
END;

-- Ejecuta el procedimiento
CALL spu_obtener_acceso_usuario(1);
