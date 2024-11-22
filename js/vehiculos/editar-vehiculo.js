const formulario = document.querySelector("form-veh");
const marca = document.querySelector("#marca");
const modelo = document.querySelector("#modelo");
const placa = document.querySelector("#placa");
const capacidad = document.querySelector("#capacidad");
const condicion = document.querySelector("#condicion");

async function getVehiculo(id) {
  const params = new URLSearchParams();
  params.append("operation","getVehiculo");
  params.append("idvehiculo", id);

  try{
    const response = await fetch(`../../controller/vehiculo.controller.php?${params}`);
    const data = await response.json();
    console.log("Datos obteidos: ",data);
    return data;
  }catch(e){
    console.error("Error al tener el vehiculo por ID: ", e);
  }
}

async function updateVehiculo(id, marca, modelo, placa, capacidad, condicion) {
  const params = new URLSearchParams();
  params.append("operation", 'updateVehiculo');
  params.append("idvehiculo", id);
  params.append("marca", marca);
  params.append("modelo", modelo);
  params.append("placa", placa);
  params.append("capacidad", capacidad);
  params.append("condicion", condicion);

  try{
    const response = await fetch(`../../controller/vehiculo.controller.php?${params}`,);
    const data = await response.json();
    console.log("Datos obtenidos: ", data);
    return data;

  } catch(error){
    console.error("Error al actualizar el vehiculo: ", error);
  }
}

formulario.addEventListener("submit", async (e) =>{
  e.preventDefault();
  const inputMarca = marca.value.trim();
  const inputModelo = modelo.value.trim();
  const inputPlaca = placa.value.trim();
  const inputCapacidad = capacidad.value.trim();
  const inputCondicion = condicion.value.trim();

  const danger = document.querySelectorAll('.text-danger');
})