// Función para cargar tipos de promociones y agregar opciones al select
async function cargarTiposPromociones() {
    try {
        const response = await fetch('../../controller/tipopromociones.controller.php?operation=getAll');
        const tipos = await response.json();

        const selectElement = document.getElementById("idtipopromocion");

        // Limpiar el select antes de agregar opciones
        selectElement.innerHTML = '<option value="">Seleccione un tipo de promoción</option>';

        tipos.forEach(tipo => {
            const option = document.createElement("option");
            option.value = tipo.idtipopromocion;  // Asegúrate que coincida con el nombre de la columna de ID
            option.textContent = tipo.tipopromocion;  // Asegúrate que coincida con el nombre de la columna de descripción
            selectElement.appendChild(option);
        });
    } catch (error) {
        console.error("Error al cargar los tipos de promociones:", error);
    }
}

document.querySelector("#form-promocion").addEventListener("submit", async function(e) {
  e.preventDefault();

  const formData = new FormData(this);

  try {
      const response = await fetch('../../controller/tipopromociones.controller.php?operation=addTipoPromocion', {
          method: 'POST',
          body: formData
      });
      const result = await response.json();

      if (result.status === 'success') {
          alert("Tipo de Promoción registrado exitosamente.");
          $('#modalTipoPromocion').modal('hide'); // Cierra el modal
          CargarDatos(); // Recarga la tabla de promociones
      } else {
          console.error(result.message);
          alert("Error al registrar el tipo de promoción.");
      }
  } catch (error) {
      console.error("Error en la solicitud:", error);
  }
});
