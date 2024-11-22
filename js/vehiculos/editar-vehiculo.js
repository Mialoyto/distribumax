async function getVehiculo(id) {
  const params = new URLSearchParams();
  params.append("operation","getVehiculo");
  params.append("idvehiculo", id);

  try{
    const response = await fetch(`../../controller/vehiculo.controller.php?${params}`);
    const data = await response.json();
    console.log(data);
    return data;
  }catch(e){
    console.error(e);
  }
}