<?php require_once '../header.php'; ?>
<style>
  .is-invalid {
    border: 2px solid red;
  }

  .invalid-feedback {
    color: red;
    font-size: 12px;
    display: none;
  }

  /* Aumentar el tamaño del formulario de manera moderada
  .form-container {
    max-width: 700px;
    width: 100%;
    padding: 30px;
  }

  /* Iconos en los campos de formulario */
  /* .form-floating .form-control {
    padding-left: 2.5rem;
  }

  .form-floating .input-group-text {
    position: absolute;
    left: 10px;
    top: 50%;
    transform: translateY(-50%);
  }

  .form-floating {
    position: relative;
  } */

  /* Mejorar el espaciado de los botones */
  /* .card-footer {
    padding-top: 20px;
  } */
</style>
<main>
  <div class="card mt-4 shadow-sm mx-auto" style="max-width: 500px;">
    <div class="card-header text-center">
      <h4><i class="fas fa-key me-2"></i> Cambiar Contraseña</h4>
    </div>

    <div class="card-body">
      <!-- Formulario para actualizar contraseña -->
      <form method="POST" action="#" id="form-actualizar-contraseña" autocomplete="off">
        <input type="hidden" id="idusuario" value="<?= $_SESSION['login']['idusuario'] ?>">

        <!-- Input para nueva contraseña -->
        <div class="mb-3">
          <div class="form-floating">
            <input
              type="password"
              class="form-control form-control-sm"
              id="password_usuario"
              minlength="8"
              maxlength="100"
              required
              placeholder="Nueva Contraseña" />
            <label for="password_usuario"><i class="fas fa-lock"></i> Nueva Contraseña</label>
          </div>
        </div>

        <!-- Input para confirmar contraseña -->
        <div class="mb-3">
          <div class="form-floating">
            <input
              type="password"
              class="form-control form-control-sm"
              id="confir-password"
              minlength="8"
              maxlength="100"
              required
              placeholder="Confirmar Contraseña" />
            <label for="confir-password"><i class="fas fa-lock"></i> Confirmar Contraseña</label>
            <div class="invalid-feedback">
              Las contraseñas no coinciden.
            </div>
          </div>
        </div>

        <div class="card-footer d-flex justify-content-between">
          <div>
            <button type="submit" class="btn btn-success btn-sm me-2" id="btn-guardar">
              <i class="fas fa-check me-2"></i> Guardar Cambios
            </button>
            <button type="reset" class="btn btn-outline-danger btn-sm">
              <i class="fas fa-times me-2"></i> Cancelar
            </button>
          </div>
        </div>
      </form>
    </div>
  </div>


</main>

<?php require_once '../footer.php'; ?>
<script src="../../js/User/update-password.js"></script>