async function GetMarcaById(id) {
  const params = new URLSearchParams();
  params.append("operation", "getMarcaById");
  params.append("idmarca", id);

  try {
    const response = await fetch(
      `../../controller/marca.controller.php?${params}`
    );
    const data = await response.json();
    console.log("Datos obtenidos:", data);
    return data;
  } catch (error) {
    console.error("Error al obtener la marca por id: ", error);
  }
}

async function cargarDatosModal(id) {
  try {
    const modal = document.querySelector("#edit-marca");
    const inputMarca = modal.querySelector("#id-marca");
    const btn = modal.querySelector(".btn-success");
    inputMarca.classList.remove("is-invalid");
    const spanError = modal.querySelector(".text-danger");
    if (spanError) {
      spanError.remove();
    }
    btn.setAttribute("disabled", "true");
    inputMarca.value = "Cargando...";

    const data = await GetMarcaById(id);
    console.log("Datos para el modal:", data);
    if (data && data.length > 0) {
      inputMarca.value = data[0].marca;

      btn.removeAttribute("disabled");
    } else {
      console.log("No hay datos disponibles para esta marca");
    }
  } catch (error) {
    console.error("Error al cargar los datos en el modal:", error);
  }
}

async function updateMarca(id, marca) {
  const params = new URLSearchParams();
  params.append("operation", "updateMarca");
  params.append("idmarca", id);
  params.append("marca", marca);

  try{
    const response = await fetch(`../../controller/marca.controller.php?${params}`);
    const data = await response.json();
    console.log("Datos obtenidos:", data);
    return data;
  } catch(error){
    console.error("Error al actualizar la marca:", error);
  }
}
