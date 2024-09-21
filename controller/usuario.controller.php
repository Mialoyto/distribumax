<?php
session_start();
require_once '../model/Usuario.php';
$usuario = new Usuario();
header("Content-Type: application/json; charset=utf-8");

$verbo = $_SERVER["REQUEST_METHOD"];
// echo $verbo;

switch ($verbo) {
    case 'GET':
        if (isset($_GET['operation'])) {
            switch ($_GET['operation']) {
                case 'searchUser':
                    $datosEnviar = [
                        "idtipodocumento" => $_GET["idtipodocumento"],
                        "idpersonanrodoc" => $_GET["idpersonanrodoc"]
                    ];
                    $row = $usuario->searchUser($datosEnviar);
                    echo json_encode($row);
                    break;
                case 'checkUsername':
                    $datosEnviar = ["username" => $_GET["username"]];
                    $row = $usuario->getUser($datosEnviar);
                    echo json_encode(["existe" => $row]);
                    break;
                case 'logout':
                    session_unset(); // libera las variables de sesión pero no destruye la sesion
                    session_destroy(); // destruye la sesion actual y sus variables
                    header("Location:http://localhost/distribumax/dashboard.php");
                    break;
            }
        }
        break;
    case 'POST':
        if (isset($_POST['operation'])) {
            switch ($_POST['operation']) {
                case 'addUsuario':
                    $datosEnviar = [
                        "idpersona" => $_POST["idpersona"],
                        "idrol" => $_POST["idrol"],
                        "nombre_usuario" => $_POST["nombre_usuario"],
                        "password_usuario" => $_POST["password_usuario"]
                    ];
                    $idobtenido = $usuario->addUsuario($datosEnviar);
                    echo json_encode(['idusuario' => $idobtenido]);
                    break;

                case 'login':
                    $login = [
                        'acceso' => false,
                        'idusuario' => "",
                        'dni'       => "",
                        "appaterno" => "",
                        "apmaterno" => "",
                        "nombres"   => "",
                        "rol"       => "",
                        "status"    => ""
                    ];
                    $dato = ['nombre_usuario' => $_POST['nombre_usuario']];
                    $row = $usuario->login($dato);

                    if (count($row) == 0) {
                        $login['status'] = 'No existe el usuario';
                    } else {
                        $claveEncripta = $row[0]['password_usuario'];
                        $claveAcceso = $_POST['password_usuario'];
                        if (password_verify($claveAcceso, $claveEncripta)) {
                            $login['acceso'] = true;
                            $login['idusuario'] = $row[0]['idusuario'];
                            $login['dni']       = $row[0]['dni'];
                            $login['appaterno'] = $row[0]['appaterno'];
                            $login['apmaterno'] = $row[0]['apmaterno'];
                            $login['nombres']   = $row[0]['nombres'];
                            $login['rol']       = $row[0]['rol'];
                        } else {
                            $login['status'] = 'Contraseña incorrecta';
                        }
                    }
                    $_SESSION['login'] = $login;
                    echo json_encode($login);
                    break;
            }
        }
        break;
}
