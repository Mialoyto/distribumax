<?php

require_once '../../header.php';
?>

<div class="container mt-5">
        <div class="card shadow-lg border-0 rounded-lg">
            <div class="card-header">
                <h3 class="text-center">Registro de Venta</h3>
            </div>
            <div class="card-body">
                <form method="POST" action="#">

                    <!-- Sección Pedido -->
                    <div class="accordion" id="pedidoAccordion">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingOne">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                    Pedido
                                </button>
                            </h2>
                            <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#pedidoAccordion">
                                <div class="accordion-body">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="idpedido" class="form-label">Pedido</label>
                                            <select class="form-control" id="idpedido" name="idpedido" required>
                                                <option value="">Seleccione un pedido</option>
                                                <!-- Opciones dinámicas -->
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="fecha_venta" class="form-label">Fecha de Venta</label>
                                            <input type="datetime-local" class="form-control" id="fecha_venta" name="fecha_venta" required>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Sección Detalles de Pago -->
                    <div class="accordion mt-3" id="pagoAccordion">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingTwo">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                    Método de Pago y Comprobante
                                </button>
                            </h2>
                            <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#pagoAccordion">
                                <div class="accordion-body">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="idmetodopago" class="form-label">Método de Pago</label>
                                            <select class="form-control" id="idmetodopago" name="idmetodopago" required>
                                                <option value="">Seleccione un método de pago</option>
                                                <!-- Opciones dinámicas -->
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="idtipocomprobante" class="form-label">Tipo de Comprobante</label>
                                            <select class="form-control" id="idtipocomprobante" name="idtipocomprobante" required>
                                                <option value="">Seleccione un comprobante</option>
                                                <!-- Opciones dinámicas -->
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Sección Totales -->
                    <div class="accordion mt-3" id="totalesAccordion">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingThree">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                    Totales
                                </button>
                            </h2>
                            <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#totalesAccordion">
                                <div class="accordion-body">
                                    <div class="row mb-3">
                                        <div class="col-md-4">
                                            <label for="subtotal" class="form-label">Subtotal</label>
                                            <input type="number" step="0.01" class="form-control" id="subtotal" name="subtotal" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="descuento" class="form-label">Descuento</label>
                                            <input type="number" step="0.01" class="form-control" id="descuento" name="descuento" value="0.00" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="igv" class="form-label">IGV</label>
                                            <input type="number" step="0.01" class="form-control" id="igv" name="igv" value="0.00" required>
                                        </div>
                                        <div class="col-md-4 mt-3">
                                            <label for="total_venta" class="form-label">Total Venta</label>
                                            <input type="number" step="0.01" class="form-control" id="total_venta" name="total_venta" required>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Botones -->
                    <div class="d-flex justify-content-end mt-4">
                        <button type="submit" class="btn btn-primary me-2">Registrar Venta</button>
                        <button type="reset" class="btn btn-secondary">Cancelar</button>
                    </div>

                </form>
            </div>
        </div>
    </div>

<?php
require_once '../../footer.php';
?>