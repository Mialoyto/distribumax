// FUNCION PARA OBTENER EL VEHICULO POR ID
async function getVehiculo(id) {
  const params = new URLSearchParams();
  params.append("operation", "getVehiculo");
  params.append("idvehiculo", id);

  try {
    const response = await fetch(`../../controller/vehiculo.controller.php?${params}`);
    const data = await response.json();
    console.log(data);
    return data;
  } catch (e) {
    console.error("Error al obtener el vehículo por ID: ", e);
  }
}
// FUNCION PARA CARGAR LOS DATOS Y ENVIARLO A LA BASE DE DATOS
async function updateVehiculo(id, marca, modelo, placa, capacidad, condicion) {
  const params = new URLSearchParams();
  params.append("operation", "updateVehiculo");
  params.append("idvehiculo", id);
  params.append("marca_vehiculo", marca);
  params.append("modelo", modelo);
  params.append("placa", placa);
  params.append("capacidad", capacidad);
  params.append("condicion", condicion);

  try {
    const response = await fetch(`../../controller/vehiculo.controller.php?${params}`);
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Error al actualizar el vehículo: ", error);
  }
}
// FUNCION PARA ACTUALIZAR EL VEHICULO CON VALIDACIONES
async function formUpdateVehiculo(id, marca, modelo, placa, capacidad, condicion, inputPlaca, formulario) {
  // removemos el mensaje de error
  const danger = document.querySelectorAll(".text-danger");
  danger.forEach((element) => {
    element.remove();
  });
  // removemos la clase is-invalid de los campos
  const invalid = document.querySelectorAll(".is-invalid");
  invalid.forEach((element) => {
    element.classList.remove("is-invalid");
  });
  if (await showConfirm("¿Desea actualizar el vehículo?", "VEHÍCULOS")) {
    const data = await updateVehiculo(
      id,
      marca,
      modelo,
      placa,
      capacidad,
      condicion
    );
    console.log(data);
    //  VALIDAMOS SI LA ACTUALIZACION FUE EXITOSA
    const STATUS = data[0].estado;
    if (!STATUS) {
      inputPlaca.classList.add("is-invalid");
      // mostramos el mensaje de error debajo del campo
      const span = document.createElement("span");
      span.classList.add("text-danger");
      span.innerHTML = `${data[0].mensaje}`;
      // insertamos el mensaje de error despues del campo
      inputPlaca.insertAdjacentElement("afterend", span);
    } else {
      showToast(`${data[0].mensaje}`, "success", "SUCCESS");
    }
  } else {
    return;
  }
}
// ? FIN CODIGO REFACTORIZADO
