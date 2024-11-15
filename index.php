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
        /* Estilos para centrar el formulario */
        html,
        body {
            height: 100%;
            margin: 0;
        }

        body {
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #007bff;
        }

        .card {
            width: 100%;
            max-width: 400px;
            /* Tamaño máximo del formulario */
        }

        .logo {
            width: 100px;
            height: 100px;
            display: block;
            margin: 0 auto 20px auto;
            /* Centrar el logo y añadir espacio debajo */
        }
    </style>
</head>

<body>
    <div class="card shadow-lg border-0 rounded-lg">
        <div class="card-header text-center">
            <!-- Ruta del logo -->
            <h3 class="text-center font-weight-light my-4">Bienvenido!</h3>
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
                <button class="btn btn-primary w-100" type="submit">Login</button>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="http://localhost/distribumax/js/login/login.js"></script>
    <script>

    </script>
</body>

</html>