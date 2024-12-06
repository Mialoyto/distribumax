document.addEventListener("DOMContentLoaded", () => {
  // Variables globales
  const formRegistrarDetalleMarca = document.querySelector("#form-registar-detalle");
  const idmarcactegoria = document.querySelector("#idmarca");
  const seleccionados = new Set();
  let ids = [];
  let contadorSelects = 0;

  // Función para cargar categorías en select específico
  async function cargarCategoriasEnSelect(select) {
    try {
      await getCategorias(`#${select.id}`);
      // Deshabilitar opciones ya seleccionadas
      seleccionados.forEach(valor => {
        const option = select.querySelector(`option[value="${valor}"]`);
        if (option) option.disabled = true;
      });
      return true;
    } catch (error) {
      console.error('Error al cargar categorías:', error);
      return false;
    }
  }

  // Manejador de selección de categorías
  function manejarSeleccionCategoria(select) {
    select.addEventListener('change', (event) => {
      const valorAnterior = select.dataset.valorPrevio;
      const nuevoValor = select.value;

      // Gestionar valor anterior
      if (valorAnterior) {
        seleccionados.delete(valorAnterior);
        document.querySelectorAll('.select-idcategorias').forEach(otherSelect => {
          const option = otherSelect.querySelector(`option[value="${valorAnterior}"]`);
          if (option) option.disabled = false;
        });
      }

      // Gestionar nuevo valor
      if (nuevoValor) {
        if (seleccionados.has(nuevoValor)) {
          select.value = valorAnterior || '';
          showToast('Esta categoría ya fue seleccionada', 'warning');
          return;
        }
        
        seleccionados.add(nuevoValor);
        select.dataset.valorPrevio = nuevoValor;
        
        document.querySelectorAll('.select-idcategorias').forEach(otherSelect => {
          if (otherSelect !== select) {
            const option = otherSelect.querySelector(`option[value="${nuevoValor}"]`);
            if (option) option.disabled = true;
          }
        });
      }
    });
  }

  // Agregar nuevo select de categoría
  async function addSelectCategoria() {
    const contenedorCategoria = document.querySelector("#adcategoria");
    const selectId = `select-categoria-${++contadorSelects}`;
    
    const divCategoria = document.createElement("div");
    divCategoria.classList.add("input-group", "mb-3", "categoria");
    divCategoria.innerHTML = `
      <div class="form-floating">
        <select id="${selectId}" name="idcategoria" class="form-control select-idcategorias" required>
          <option value="">Seleccione categoría</option>
        </select>
        <label><i class="bi bi-tag"></i> Categoría</label>
      </div>
      <button type="button" class="btn btn-danger eliminar-subcategoria">
        <i class="bi bi-trash"></i>
      </button>
    `;

    contenedorCategoria.appendChild(divCategoria);
    
    const select = divCategoria.querySelector('.select-idcategorias');
    const cargaExitosa = await cargarCategoriasEnSelect(select);
    
    if (!cargaExitosa || select.options.length <= 1) {
      showToast('Error al cargar categorías', 'error');
      divCategoria.remove();
      return;
    }

    manejarSeleccionCategoria(select);
    
    // Manejador para eliminar categoría
    divCategoria.querySelector(".eliminar-subcategoria").addEventListener("click", () => {
      const valorSeleccionado = select.value;
      if (valorSeleccionado) {
        seleccionados.delete(valorSeleccionado);
        document.querySelectorAll('.select-idcategorias').forEach(otherSelect => {
          const option = otherSelect.querySelector(`option[value="${valorSeleccionado}"]`);
          if (option) option.disabled = false;
        });
      }
      divCategoria.remove();
    });
  }

  // Registrar detalle de marca
  async function registrarDetalle() {
    const categoriasSelects = document.querySelectorAll('.categoria .select-idcategorias');
    ids = Array.from(categoriasSelects)
      .map(select => select.value)
      .filter(value => value !== '');

    if (ids.length === 0) {
      showToast('Debe seleccionar al menos una categoría', 'warning');
      return null;
    }

    const params = new FormData();
    params.append("operation", "addDetallemarca");
    params.append("idmarca", idmarcactegoria.getAttribute("data-id"));
    ids.forEach((id, index) => {
      params.append(`ids[${index}][idcategoria]`, id);
    });

    try {
      const response = await fetch(`../../controller/detallemarca.controller.php`, {
        method: "POST",
        body: params
      });
      return await response.json();
    } catch (error) {
      console.error(error);
      return { success: false, message: "Error al registrar" };
    }
  }

  // Event Listeners
  formRegistrarDetalleMarca.addEventListener("submit", async (event) => {
    event.preventDefault();
    if (await showConfirm("¿Estás seguro de registrar el detalle de la marca?")) {
      const data = await registrarDetalle();
      if (data?.success) {
        showToast(data.message, 'success', 'SUCCESS');
        formRegistrarDetalleMarca.reset();
      } else {
        showToast(data.message || 'Error al registrar', 'error', 'ERROR');
      }
    }
  });

  document.querySelector("#btncategoria").addEventListener("click", addSelectCategoria);

  // Inicializar selects existentes
  document.querySelectorAll('.select-idcategorias').forEach(manejarSeleccionCategoria);
});