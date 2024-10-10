document.addEventListener("DOMContentLoaded", function () {
  const form = document.querySelector("#form-promocion");

  async function addPromocion() {
    // Obtener los valores de los campos del formulario
    const tipopromocion = document.querySelector("#tipopromocion").value;
    const descripcion = document.querySelector("#descripcion").value;

    if (tipopromocion.trim() === "" || descripcion.trim() === "") {
      alert("Por favor, complete todos los campos.");
      return;
    }

    // Construir el objeto de datos para enviar
    const datos = new FormData();
    datos.append("operation", "addTipoPromocion");
    datos.append("tipopromocion", tipopromocion);
    datos.append("descripcion", descripcion);

    const url = {
      method: "POST",
      body: datos
    };

    try {
      const response = await fetch(`../../controller/tipopromociones.controller.php`, url);
      return response.json();
    } catch (e) {
      console.error("Hubo un error:", e);
    }
  }

  form.addEventListener("submit", async function (event) {
    event.preventDefault();
    const data = await addPromocion();
    console.log(data[0].id);
    if (data[0].id > 0) {
      alert("Registro exitoso");
      // Limpiar formulario
      form.reset();
    } else {
      alert("Error al registrar");
    }
  });
});
