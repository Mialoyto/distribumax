async function updateProveedor(idproveedor, proveedor, contacto_principal) {
  const params = new URLSearchParams();
  params.append("operation", "updateProveedor");
  params.append("idproveedor", idproveedor);
  params.append("proveedor", proveedor);
  params.append("contacto_principal", contacto_principal);

  const options = {
    method: "POST",
    body: params,
  };

  try {
    const response = await fetch(`../../controller/proveedor.controller.php`, options);
    const data = await response.json();
    console.log("Datos obtenidos al actualizar el proveedor:", data);
    return data;
  } catch (error) {
    console.error("Error al actualizar el proveedor:", error);
  }
}

async function updateEstadoProveedor(idproveedor, estado) {
  const params = new FormData();
  params.append("operation", "updateEstado");
  params.append("idproveedor", idproveedor);
  params.append("estado", estado);

  const options = {
    method: "POST",
    body: params,
  };

  try {
    const response = await fetch(`../../controller/proveedor.controller.php`, options);
    const data = await response.json();
    console.log("Datos obtenidos al actualizar el estado del proveedor:", data);
    return data;
  } catch (error) {
    console.error("Error al actualizar el estado del proveedor:", error);
  }
}
