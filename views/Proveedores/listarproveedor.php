<?php

require_once '../../model/Conexion.php';

try {
    // Crear la cadena de conexión correctamente
    $dsn = "mysql:host=localhost;port=3306;dbname=distribumax";
    $usuario = "root";
    $clave = "";

    // Instanciar el objeto PDO correctamente
    $pdo = new PDO($dsn, $usuario, $clave);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Consulta a la tabla empresas
    $stmt = $pdo->prepare("SELECT idempresa, proveedor, contacto_principal, telefono_contacto, direccion, email FROM proveedores");
    $stmt->execute();

    // Almacenar los resultados en un array
    $proveedores = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Devolver los datos en formato JSON
    echo json_encode([
        "data" => $proveedores // Data es el campo requerido por DataTables
    ]);

} catch (PDOException $e) {
    echo 'Error: ' . $e->getMessage();
}
?>
