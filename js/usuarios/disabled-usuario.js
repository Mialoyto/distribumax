async function updateEstado(id,status) {
  const params = new URLSearchParams();
  params.append("operation", "updateEstado");
  params.append("idusuario", id);
  params.append("estado", status);
  try{
    const response = await fetch(`../../controller/usuario.controller.php?${params}`);
    const data = await response.json();
    console.log("Datos obtenidos: ", data);
    return data;
  } catch(error){
    console.error("Error al actualizar el estado del usuario", error);
  }
}