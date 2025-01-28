<?php
// Configuración del servidor MySQL
$host = 'localhost';       // Cambia según tu configuración
$user = 'root';            // Cambia por tu usuario de MySQL
$password = '';            // Cambia por tu contraseña
$dbname = 'distribumax';   // Nombre de la base de datos

try {
    // Conexión al servidor MySQL sin especificar base de datos
    $pdo = new PDO("mysql:host=$host", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Seleccionar la base de datos
    $pdo->exec("USE $dbname");

    // Carpeta donde están almacenados los archivos SQL
    $directory = '../db-test/'; // Cambia por la ruta de tu carpeta

    // Obtener todos los archivos con extensión .sql en la carpeta
    $files = glob($directory . '*.sql');

    // Verificar si hay archivos en la carpeta
    if (empty($files)) {
        die("No se encontraron archivos SQL en la carpeta especificada.");
    }

    // Procesar cada archivo SQL
    foreach ($files as $file) {
        try {
            // Leer el contenido del archivo
            $sql = file_get_contents($file);

            // Verificar que el archivo no esté vacío
            if (empty(trim($sql))) {
                echo "El archivo está vacío: " . basename($file) . "<br>";
                continue; // Saltar al siguiente archivo
            }

            // Ejecutar el contenido del archivo SQL
            $pdo->exec($sql);

            echo "Archivo ejecutado con éxito: " . basename($file) . "<br>";
        } catch (PDOException $e) {
            echo "Error al ejecutar el archivo: " . basename($file) . "<br>";
            echo "Mensaje de error: " . $e->getMessage() . "<br>";

            // Opcional: Registrar el error en un archivo
            // file_put_contents('errores.log', "Error en " . basename($file) . ": " . $e->getMessage() . "\n", FILE_APPEND);
        }
    }

    echo "Todos los archivos SQL se ejecutaron correctamente.";

} catch (PDOException $e) {
    // Error de conexión o ejecución
    echo "Error: " . $e->getMessage();
    exit;
}
?>
