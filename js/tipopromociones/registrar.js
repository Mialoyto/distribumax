document.addEventListener("DOMContentLoaded", function () {
  const form = document.querySelector("#form-promocion");

  form.addEventListener("submit", async function (event) {
    event.preventDefault();
    
    // Obtener los valores de los campos del formulario
    const tipopromocion = document.querySelector("#tipopromocion").value;
    const descripcion = document.querySelector("#descripcion").value;
    const estado = document.querySelector("#estado").value;

    // Validar que los campos no estén vacíos
    if (tipopromocion.trim() === "" || descripcion.trim() === "" || estado.trim() === "") {
      alert("Por favor, complete todos los campos.");
      return;
    }

    // Construir el objeto de datos para enviar
    const datos = new URLSearchParams();
    datos.append("tipopromocion", tipopromocion);
    datos.append("descripcion", descripcion);
    datos.append("estado", estado);

    try {
      // Enviar los datos a través de fetch (ajustar la URL a tu controlador)
      const response = await fetch(`../../controller/tipopromociones.controller.php?operation=addTipoPromocion`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded" // Se envía en formato URL encoded
        },
        body: datos.toString() // Convertir los datos a URL encoded
      });

      const result = await response.json();

      if (result.success) {
        alert("Tipo de promoción registrado con éxito.");
        form.reset(); // Limpiar el formulario
      } else {
        alert("Error al registrar el tipo de promoción.");
      }

    } catch (error) {
      console.error("Hubo un error:", error);
      alert("Hubo un error en la comunicación con el servidor.");
    }
  });
});
