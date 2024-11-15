<?php
session_start();
if (!isset($_SESSION['login']) || (isset($_SESSION['usuario']) && $_SESSION['usuario']['estado'] == false)) {
  header("Location:http://localhost/distribumax");
} else {
  // Validación de ruta
  /*   $url = $_SERVER['REQUEST_URI'];
  $rutaCompleta = explode("/", $url);
  $rutaCompleta = array_filter($rutaCompleta);
  $totalElementos = count($rutaCompleta);
  var_dump($rutaCompleta);
  echo "<br> ----------------------------------- <br>";

  // Buscaremos la vistaActual n la listaAcceso
  $vistaActual = $rutaCompleta[$totalElementos];
  $listaAccesos = $_SESSION['login']['accesos'];


  var_dump($vistaActual);
  echo "<br> ----------------------------------- <br>";
  var_dump($listaAccesos);
  echo "<br> ----------------------------------- <br>";
  var_dump($totalElementos);
  echo "<br> ----------------------------------- <br>";


  // Validar que existan accesos antes de procesar

  $encontrado = false;
  $i = 0;
  while ($i < count($listaAccesos) && !$encontrado) {
    if ($listaAccesos[$i]['ruta'] == $vistaActual) {
      $encontrado = true;
    }
    $i++;
  }

  if (!$encontrado) {
    header("Location:http://localhost/distribumax/Views/");
    exit();
  } */
}
$host = "http://localhost/distribumax";
?>
<!DOCTYPE html>
<html lang="es">

<!--Variable temporal --->
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title>Distribumax</title>

<link href="<?= $host ?>/css/styles.css" rel="stylesheet" />
<link href="<?= $host ?>/css/list.css" rel="stylesheet" />

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
  integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- Datatables CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/2.1.8/css/dataTables.bootstrap5.css" />
<link rel="stylesheet" href="https://cdn.datatables.net/2.1.8/css/dataTables.dataTables.css">

<!-- Font Awesome -->
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<!-- Bootstrap JS and Popper -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.7/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
  integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
  crossorigin="anonymous"></script>

</head>
<!-- fin del header -->

<body class="sb-nav-fixed">

  <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
    <!-- Navbar Brand-->
    <a class="navbar-brand ps-3" href=" <?= $host ?>/views">Distribumax</a>
    <!-- Sidebar Toggle-->
    <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!">
      <i class="fas fa-bars"></i>
    </button>
    <!-- Navbar Search-->
    <!-- Navbar-->
    <div class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
      <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
        <li class="nav-item dropdown d-sm-none d-lg-block">
          <a class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-bs-toggle="dropdown"
            aria-expanded="false">
            <i class="fas fa-user fa-fw"></i>
            <?= $_SESSION['login']['nombres'] ?>
            <?= $_SESSION['login']['appaterno'] ?>
          </a>
          <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="#!">Configuracion</a></li>
            <li><a class="dropdown-item" href="#!">Cambiar Contraseña</a></li>
            <li><a class="dropdown-item" href="#!">Historial</a></li>
            <li>
              <hr class="dropdown-divider" />
            </li>
            <li><a class="dropdown-item"
                href="<?= $host ?>/controller/usuario.controller.php?operation=logout">
                Cerrar Sesión</a>
            </li>
          </ul>
        </li>
      </ul>
    </div>
  </nav>
  <!-- fin navbar -->
  <div id="layoutSidenav">
    <div id="layoutSidenav_nav">
      <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
        <div class="sb-sidenav-menu">
          <div class="nav">
            <div class="sb-sidenav-menu-heading">Modulos</div>
            <?php
            // foreach ($listaAccesos as $acceso) {
            // var_dump($acceso);
            // if ($acceso['sidebaroption '] === 'S') {
            // echo "<a class='nav-link' href='$host/views/{$acceso['modulo']}/{$acceso['ruta']}'>
            // <div class='sb-nav-link-icon'><i class='{$acceso['icono']}'></i></div>
            // {$acceso['texto']}
            // </a>";
            // }
            // }

            ?>


            <a class="nav-link" href="<?= $host ?>/views/Pedidos/">
              <div class="sb-nav-link-icon"><i class="fa-solid fa-clipboard-list fa-lg"></i></div>
              Pedidos
            </a>
            <a class="nav-link" href="<?= $host ?>/views/Ventas/">
              <div class="sb-nav-link-icon"><i class="fa-solid fa-cart-plus fa-lg"></i></div>
              Ventas
            </a>

            <a class="nav-link" href="<?= $host ?>/views/Clientes/">
              <div class="sb-nav-link-icon"><i class="bi bi-person-rolodex fa-lg"></i></div>
              Clientes
            </a>
            <a class="nav-link" href="<?= $host ?>/views/Empresas/">
              <div class="sb-nav-link-icon"><i class="fa-solid fa-building fa-lg"></i></div>
              Empresas
            </a>
            <a class="nav-link" href="<?= $host ?>/views/Productos/">
              <div class="sb-nav-link-icon"><i class="fa-solid fa-boxes-stacked fa-lg"></i></div>
              Productos
            </a>
            <a class="nav-link" href="<?= $host ?>/views/Kardex/">
              <div class="sb-nav-link-icon"><i class="fa-solid fa-boxes-packing fa-lg"></i></div>
              Kardex
            </a>
            <a class="nav-link" href="<?= $host ?>/views/Proveedores/">
              <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
              Proveedores
            </a>
            <div class="sb-sidenav-menu-heading">Módulos personas</div>
            <a class="nav-link" href="<?= $host ?>/views/Personas/">
              <div class="sb-nav-link-icon"><i class="fa-solid fa-person-circle-plus fa-lg"></i></div>
              Registrar persona
            </a>
            <a class="nav-link" href="<?= $host ?>/views/Usuarios/">
              <div class="sb-nav-link-icon"><i class="fa-solid fa-user-plus fa-lg"></i></div>
              Registrar usuario
            </a>
            <div class="sb-sidenav-menu-heading">Módulos reportes</div>
            <a class="nav-link" href="<?= $host ?>/views/Promociones/">
              <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
              Promociones
            </a>
            <a class="nav-link" href="<?= $host ?>/views/Categorias/">
              <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
              Categorias
            </a>
            <a class="nav-link" href="<?= $host ?>/views/Subcategoria/">
              <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
              Subcategorias
            </a>
            <a class="nav-link" href="<?= $host ?>/views/Marcas/">
              <div class="sb-nav-link-icon"><i class="bi bi-tags-fill"></i></div>
              Marcas
            </a>
            <a class="nav-link" href="<?= $host ?>/views/Vehiculos/">
              <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
              Vehiculos
            </a>
            <a class="nav-link" href="<?= $host ?>/views/Despacho/">
              <div class="sb-nav-link-icon"><i class="fa-solid fa-truck-ramp-box fa-lg"></i></div>
              Despacho
            </a>
          </div>
        </div>
      </nav>
    </div>
    <div id="layoutSidenav_content">