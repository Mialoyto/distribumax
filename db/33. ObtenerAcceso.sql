-- Active: 1732637704938@@127.0.0.1@3306@distribumax
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

CREATE PROCEDURE spu_listar_perfiles()
BEGIN
    SELECT 
        idperfil,
        perfil,
        nombrecorto
    FROM perfiles;
END;
 CALL spu_listar_perfiles();

-- //TODO: LISTAR PERFILES

/* CALL spu_listar_perfiles();
-- Ejecuta el procedimiento
CALL spu_obtener_acceso_usuario(1);
select * from usuarios;
select * from perfiles; */