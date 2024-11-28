<?php
session_start();
if (isset($_SESSION['login']) && $_SESSION['login']['estado'] == true) {
    header("Location: http://localhost/distribumax/views/");
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Distribumax</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        /* Estilos generales para centrar */
        html,
        body {
            height: 100%;
            margin: 0;
        }

        body {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 15px;
            background-image: url('img/fondo.jpg'); /* Ruta de la imagen de fondo */
            background-size: cover; /* Ajusta la imagen para cubrir todo el fondo */
            background-position: center; /* Centra la imagen de fondo */
            background-repeat: no-repeat; /* Evita que la imagen se repita */
        }

        .card {
            width: 100%;
            max-width: 360px;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }

        .logo {
            width: 80px;
            height: 80px;
            display: block;
            margin: 0 auto 20px auto;
        }

        .card-header h3 {
            font-weight: bold;
            color: #333;
        }
    </style>
</head>

<body>

    <div class="row">
        <div class="col-6">
            <div class="card shadow-lg border-0 rounded-lg">
                <div class="card-header text-center">
                    <h3 class="text-center my-4">Bienvenido!</h3>
                </div>
                <div class="card-body">
                    <form autocomplete="off" id="form-login">
                        <div class="form-floating mb-3">
                            <input class="form-control" id="nombre_usuario" type="text" autofocus placeholder="correo@gmail.com" required />
                            <label for="nombre_usuario">Usuario</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input class="form-control" id="inputPassword" type="password" placeholder="Password" required />
                            <label for="inputPassword">Contraseña</label>
                        </div>
                        <div class="mb-3 text-cemter">
                            <a href="#" class="">¿Olvide mi contraseña?</a>
                        </div>
                        <button class="btn btn-primary w-100" type="submit">Login</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-6">
            <img src="http://localhost/distribumax/img/logo2.png" alt="Logo" style="width: 100%; height: auto;">
        </div>
    </div>

    <!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script> -->
    <script src="http://localhost/distribumax/js/login/login.js"></script>
    <script src="http://localhost/distribumax/js/utils/sweetalert.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</body>

</html>
