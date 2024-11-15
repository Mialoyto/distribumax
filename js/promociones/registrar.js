/* document.addEventListener("DOMContentLoaded", function () {
  async function cargarTiposPromociones() {
    try {
      const response = await fetch(
        "../../controller/tipopromociones.controller.php?operation=getAll"
      );
      const tipos = await response.json();

      const selectElement = document.getElementById("idtipopromocion");

      // Limpiar el select antes de agregar opciones
      selectElement.innerHTML =
        '<option value="">Seleccione un tipo de promoción</option>';

      tipos.forEach((tipo) => {
        const option = document.createElement("option");
        option.value = tipo.idtipopromocion; // Asegúrate que coincida con el nombre de la columna de ID
        option.textContent = tipo.tipopromocion; // Asegúrate que coincida con el nombre de la columna de descripción
        selectElement.appendChild(option);
      });
    } catch (error) {
      console.error("Error al cargar los tipos de promociones:", error);
    }
  }
  cargarTiposPromociones();

  const formPromocion = document.querySelector("#form-promocion");
  async function registrarPromocion() {
    formData.append("operation", "addPromocion");

    try {
      const response = await fetch(
        "../../controller/promocion.controller.php",
        {
          method: "POST",
          body: formData,
        }
      );
      const result = await response.json();

      if (result.status === "success") {
        alert("Promoción registrada exitosamente.");
        $("#modalTipoPromocion").modal("hide");
        cargarDatos(); // Recargar la lista de promociones
      } else {
        alert(result.message || "Error al registrar la promoción.");
      }
    } catch (error) {
      console.error("Error en la solicitud:", error);
    }
  }

  formPromocion.addEventListener("submit", async function (e) {
    e.preventDefault();
    registrarPromocion();
  });
});
 */