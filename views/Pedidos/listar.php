<?php require_once '../header.php'; ?>
<main>
   <div class="container-fluid px-4">
      <ol class="breadcrumb mb-4">
         <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
      </ol>

      <div class="card ">
         <div class="card-header ">
            <h2 class="card-title">Listar Pedidos</h2>
         </div>
         <div class="card-body">

            <div class="table-responsive">
               <table class="table table-sm" id="table-pedidos">
                  <thead>
                     <tr>
                        <th>Pedido</th>
                        <th>Tipo</th>
                        <th>Documento</th>
                        <th>Cliente</th>
                        <th>Fecha</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                     </tr>
                  </thead>
                  <tbody id="contenido-pedidos">
                     <!-- Aquí se cargarán los pedidos dinámicamente -->
                  </tbody>
               </table>
            </div>

            <!-- MODAL -->
            <div class="modal fade" id="edits-pedido"
               data-bs-backdrop="static"
               data-bs-keyboard="false"
               tabindex="-1"
               aria-labelledby="staticBackdropLabel"
               aria-hidden="true">
               <div class="modal-dialog modal-xl"> <!-- Clase agrandada -->
                  <div class="modal-content">
                     <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">Editar Pedido</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                     </div>
                     <form class="form-pedido" autocomplete="off">
                        <div class="modal-body">
                           <div class="form-floating mb-3">
                              <!-- fila 01 -->
                              <div class="row g-3 mb-3">
                                 <div class="col-md-6 mb-2">
                                    <div class="form-floating">
                                       <input type="text" class="form-control numeros" id="update-nro-doc" name="update-nro-doc" placeholder="Número de documento" min="1" required disabled>
                                       <label for="update-nro-doc">Número de documento</label>
                                    </div>
                                 </div>
                                 <div class="col-md-6 mb-2">
                                    <div class="form-floating">
                                       <input type="text" class="form-control" id="update-cliente" disabled>
                                       <label for="update-cliente"><i class="fa-regular fa-id-card fa-lg"></i> Tipo de cliente</label>
                                    </div>
                                 </div>
                              </div>
                              <!-- fila 2 -->
                              <div class="row g-3 mb-3">
                                 <div class="col-md-4 mt-3">
                                    <div class="form-floating">
                                       <input class="form-control" id="update-nombres" name="update-nombres" type="text" placeholder="Nombres" disabled required />
                                       <label for="update-nombres">Nombres</label>
                                    </div>
                                 </div>
                                 <div class="col-md-4 mt-3">
                                    <div class="form-floating">
                                       <input class="form-control" id="update-appaterno" name="update-appaterno" type="text" placeholder="Apellido Paterno" disabled required />
                                       <label for="update-appaterno">Apellido paterno</label>
                                    </div>
                                 </div>
                                 <div class="col-md-4 mt-3">
                                    <div class="form-floating">
                                       <input class="form-control" id="update-apmaterno" name="update-apmaterno" type="text" placeholder="Apellido Materno" disabled required />
                                       <label for="update-apmaterno">Apellido materno</label>
                                    </div>
                                 </div>
                              </div>
                              <div class="row g-3 mb-3">
                                 <div class="col-md-6 mt-3">
                                    <div class="form-floating">
                                       <input class="form-control" id="update-razon-social" name="update-razon-social" type="text" placeholder="Razón Social" disabled required />
                                       <label for="update-razon-social">Razón social</label>
                                    </div>
                                 </div>
                                 <div class="col-md-6 mt-3">
                                    <div class="form-floating">
                                       <input class="form-control" id="update-direccion-cliente" name="update-direccion-cliente" type="text" placeholder="Dirección Cliente" disabled required />
                                       <label for="update-direccion-cliente">Dirección cliente</label>
                                    </div>
                                 </div>
                              </div>
                              <hr class="my-3">
                              <!-- Sección de Detalle de Pedido -->
                              <h5 class="mb-3">Detalle del Pedido</h5>
                              <div class="col-md-8 mb-3">
                                 <div class="form-floating">
                                    <input type="search" class="form-control" id="addProducto" list="datalistProducto" placeholder="Agregar Producto" disabled>
                                    <label for="update-addProducto">Agregar producto</label>
                                    <ul id="datalistProducto" class="list-group position-absolute w-100 ListarDatos" style="z-index: 1000; display: none;"></ul>
                                 </div>
                              </div>

                              <div class="table-responsive">
                                 <table class="table table-striped table-hover" id="update-detalle-productos">
                                    <thead class="bg-primary text-white">
                                       <tr>
                                          <th>Código</th>
                                          <th>Producto</th>
                                          <th>Cantidad</th>
                                          <th>Unidad Medida</th>
                                          <th>Precio Unitario</th>
                                          <th>Subtotal</th>
                                          <th>% Descuento</th>
                                          <th>Monto Descuento</th>
                                          <th>Total</th>
                                          <th>Acciones</th>
                                       </tr>
                                    </thead>
                                    <tbody id="update-detalle-pedido">
                                       <!-- Detalles dinámicos -->
                                    </tbody>
                                 </table>
                              </div>
                           </div>
                        </div>
                        <div class="modal-footer">
                           <button type="submit" class="btn btn-success">Actualizar</button>
                           <button type="reset" class="btn btn-outline-danger" data-bs-dismiss="modal">Cerrar</button>
                        </div>
                     </form>
                  </div>
               </div>
            </div>
            <!-- FIN DEL MODAL -->
         </div>
         <div class="card-footer">
            <a href="../Pedidos/" class="btn btn-primary">Registrar Pedidos</a>
         </div>
      </div>
   </div>
</main>
<?php require_once '../footer.php'; ?>
<script type="module" src="http://localhost/distribumax/js/pedidos/listar.js"></script>
<script type="module" src="http://localhost/distribumax/js/pedidos/update-pedido.js"></script>