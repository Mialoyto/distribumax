async function updateEstado(id, status) {
  const params = new URLSearchParams();
  params.append("operation", 'activeCliente');
  params.append("estado", status);
  params.append("idcliente", id);
  try{
    const response = await fetch(`../../controller/cliente.controller.php`,{
      method: 'POST',
      body: params
    });
    const data = await response.json();
    console.log("Datos obtenidos: ", data);
    return data;
  } catch(error){
    console.error("Error al actualizar el estado del cliente", error);
  }
}