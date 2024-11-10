-- Active: 1728094991284@@127.0.0.1@3306@distribumax
USE distribumax;

DROP PROCEDURE IF EXISTS ´spu_usuarios_obtener_permisos´;
DELIMITER //
CREATE PROCEDURE  spu_usuarios_obtener_permisos(IN _idperfil INT)
BEGIN
    SELECT
    PE.