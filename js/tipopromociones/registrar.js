// Función para cargar tipos de promociones y agregar opciones al select
document.addEventListener("DOMContentLoaded", () => {
  async function addTipoPromocion() {
    const tipopromocion = document.querySelector("#tipopromocion");
    const descripcion = document.querySelector("#descripcion");
    const inputPromocion = tipopromocion.value.trim();
    const inputDescripcion = descripcion.value.trim();

    const params = new FormData();
    params.append("operation", "addTipoPromocion");
    params.append("tipopromocion", inputPromocion);
    params.append("descripcion", inputDescripcion);
    const options = {
      method: "POST",
      body: params,
    };
    try {
      const response = await fetch(
        `../../controller/tipopromociones.controller.php`,
        options
      );
      const data = await response.json();
      console.log(data);
      return data;
    } catch (e) {
      console.error("Error al registrar la promoción:", e);
    }
  }

  const formTipoPromocion = document.querySelector("#add-tipo-promocion");
  formTipoPromocion.addEventListener("submit", async function (e) {
    e.preventDefault();

    if (await showConfirm("Desea registrar", "Tipo de promoción")) {
      const data = await addTipoPromocion();
      if (data[0].id > 0){
        showToast(`${data[0].mensaje}`,"success", "SUCCESS")
      }else{
        showToast(`${data[0].mensaje}`,"error", "ERROR")
      }
    }
  });
});
