async function updateEstadoVehiculo(id, status) {
  const params = new URLSearchParams();
  params.append("operation", 'updateEstadoVehiculo');
  params.append("idvehiculo", id);
  params.append("estado", status);
  try{
    const response = await fetch(`../../controller/vehiculo.controller.php?${params}`);
    const data = await response.json();
    console.log("Datos obtenidos: ", data);
    return data;
  } catch (error){
    console.error("Error al actualizar el estado del vehiculo: ", error);
  }
}