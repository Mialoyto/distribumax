<?php 
 
   $host="http://localhost/distribumax" ;
 ?>
<!DOCTYPE html>
<html lang="es">

   <!--Variable temporal --->

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Seminario</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="<?=$host?>/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.7/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</head>

<body class="sb-nav-fixed">
 
    <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
        <!-- Navbar Brand-->
        <a class="navbar-brand ps-3" href=" <?=$host?>/dashboard.php">Distribumax</a>
        <!-- Sidebar Toggle-->
        <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i
                class="fas fa-bars"></i></button>
        <!-- Navbar Search-->
        <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
            
        </form>
        <!-- Navbar-->
        <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown"
                    aria-expanded="false"></a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                 
                    <li>
                        <hr class="dropdown-divider" />
                    </li>
                    <li><a class="dropdown-item" href="<?= $host ?>/controllers/usuario.controller.php?operacion=destroy">Salir</a></li>
                </ul>
            </li>
        </ul>
    </nav>
    <div id="layoutSidenav">
        <div id="layoutSidenav_nav">
            <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                <div class="sb-sidenav-menu">
                    <div class="nav">
                       
                    
                        <div class="sb-sidenav-menu-heading">Modulos</div>
                        <a class="nav-link" href="<?=$host?>/views/Pedidos/">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                           Pedidos
                        </a>
                        <a class="nav-link" href="<?=$host?>/views/Ventas/">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                           Ventas
                        </a>
                        <a class="nav-link" href="<?=$host?>/views/Usuarios/">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                           Usuarios
                        </a>
                        <a class="nav-link" href="<?=$host?>/views/Clientes/">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                           Clientes
                        </a>
                        <a class="nav-link" href="<?=$host?>/views/Empresas/">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                           Empresas
                        </a>
                        <a class="nav-link" href="<?=$host?>/views/Productos/">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                           Productos
                        </a>
                        <a class="nav-link" href="<?=$host?>/views/Kardex/">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                            Kardex
                        </a>
                        <a class="nav-link" href="<?=$host?>/views/Proveedores/">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                           Proveedores
                        </a>
                        <a class="nav-link" href="<?=$host?>/views/Promociones/">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                           Promociones
                        </a>
                        <a class="nav-link" href="<?=$host?>/views/Categorias/">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                           Categorias
                        </a>
                        <a class="nav-link" href="<?=$host?>/views/Subcategoria/">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                           Subcategorias
                        </a>
                        <a class="nav-link" href="<?=$host?>/views/Marcas/">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                           Marcas
                        </a>
                        

                    </div>
                </div>
                
            </nav>
        </div>
      <div id="layoutSidenav_content">
            <main>