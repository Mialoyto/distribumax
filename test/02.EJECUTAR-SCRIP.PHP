<?php
// Configuración del servidor MySQL
$host = 'localhost';       // Cambia según tu configuración
$user = 'root';         // Cambia por tu usuario de MySQL
$password = '';  // Cambia por tu contraseña
$dbname = 'distribumax'; // Nombre de la base de datos a crear

try {
  // Conexión al servidor MySQL sin especificar base de datos
  $pdo = new PDO("mysql:host=$host", $user, $password);
  $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);


  // Seleccionar la base de datos recién creada
  $pdo->exec("USE $dbname");

  // Carpeta donde están almacenados los archivos SQL
  $directory = '../db-test/'; // Cambia por la ruta de tu carpeta

  // Abrir la carpeta y obtener archivos con extensión .sql
  $files = glob($directory . '*.sql');

  // Procesar cada archivo SQL
  foreach ($files as $file) {
      try {
          // Leer el contenido del archivo
          $sql = file_get_contents($file);
          
          // Ejecutar el contenido del archivo SQL
          $pdo->exec($sql);
          
          echo "Archivo ejecutado con éxito: " . basename($file) . "<br>";
      } catch (PDOException $e) {
          echo "Error al ejecutar el archivo: " . basename($file) . "<br>";
          echo "Mensaje de error: " . $e->getMessage() . "<br>";
          // Opcional: Escribir el error en un archivo de registro
          // file_put_contents('errores.log', "Error en " . basename($file) . ": " . $e->getMessage() . "\n", FILE_APPEND);
      }
  }

  echo "Todos los archivos SQL se ejecutaron correctamente.";

} catch (PDOException $e) {
  echo "Error: " . $e->getMessage();
}
