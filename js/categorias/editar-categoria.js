
async function GetCategoriaById(id) {
  const params = new URLSearchParams();
  params.append("operation", 'getCategoriaById');
  params.append("idcategoria", id);


  try {
    const response = await fetch(`../../controller/categoria.controller.php?${params}`);
    const data = await response.json();
    console.log("Datos obtenidos:", data);
    return data;

  } catch (error) {
    console.error("Error al obtener la categoría por ID:", error);
  }
}


async function cargarDatosModal(id) {
  try {
    // formUpdateCategoria.reset();
    const modal = document.querySelector("#edit-categoria");
    const inputCategoria = modal.querySelector("#id-categoria");
    const btn = modal.querySelector(".btn-success");
    inputCategoria.classList.remove("is-invalid");
    const spanError = modal.querySelector(".text-danger");
    if (spanError) {
      spanError.remove();
    }
    btn.setAttribute("disabled", "true");
    inputCategoria.value = "Cargando...";

    const data = await GetCategoriaById(id);
    console.log("Datos para el modal:", data);
    if (data && data.length > 0) {

      inputCategoria.value = data[0].categoria;

      btn.removeAttribute("disabled");
    } else {
      console.log("No hay datos disponibles para esta categoría.");
    }
  } catch (error) {
    console.error("Error al cargar los datos en el modal:", error);
  }
}


async function updateCategoria(id, categoria) {
  const params = new URLSearchParams();
  params.append("operation", 'updateCategoria');
  params.append("idcategoria", id);
  params.append("categoria", categoria);



  try {
    const response = await fetch(`../../controller/categoria.controller.php?${params}`,);
    const data = await response.json();
    console.log("Datos obtenidos:", data);
    return data;

  } catch (error) {
    console.error("Error al actualizar la categoría:", error);
  }
}


// updateCategoria(1, "Nueva categoría")