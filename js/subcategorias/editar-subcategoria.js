async function updateSubcategoria(idsubcategoria, subcategoria) {

  const params = new URLSearchParams();
  params.append("operation", 'updateSubcategoria');
  params.append("idsubcategoria", idsubcategoria);
  params.append("subcategoria", subcategoria);

  const options = {
    method: 'POST',
    body: params
  };
  try {
    const response = await fetch(`../../controller/subcategoria.controller.php`, options);
    const data = await response.json();
    console.log("Datos obtenidos:", data);
    return data;

  } catch (error) {
    console.error("Error al actualizar la subcategoría:", error);
  }
}



async function updateEstado(idsubcategoria, estado) {
  const params = new FormData();
  params.append("operation", 'updateEstado');
  params.append("idsubcategoria", idsubcategoria);
  params.append("estado", estado);

  const options = {
    method: 'POST',
    body: params
  };
  try {
    const response = await fetch(`../../controller/subcategoria.controller.php`, options);
    const data = await response.json();
    // console.log("Datos obtenidos:", data);
    return data;

  } catch (error) {
    console.error("Error al actualizar el estado de la subcategoría:", error);
  }
}

// updateEstado(3, "0");