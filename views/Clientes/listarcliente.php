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

    $stmt = $pdo->prepare("SELECT tipo_cliente,create_at,estado FROM clientes");
    $stmt->execute();

    // Almacenar los resultados en un array
    $clientes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Devolver los datos en formato JSON
    echo json_encode([
        "data" => $clientes // Data es el campo requerido por DataTables
    ]);

} catch (PDOException $e) {
    echo 'Error: ' . $e->getMessage();
}
?>
