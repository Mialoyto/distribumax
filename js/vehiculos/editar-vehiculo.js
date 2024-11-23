const formulario = document.querySelector("#form-veh");
const idVehiculo = document.querySelector("#editConductor");

const modelo = document.querySelector("#editModelo");
const placa = document.querySelector("#editPlaca");
const capacidad = document.querySelector("#editCapacidad");
const condicion = document.querySelector("#editCondicion");
const btn = document.querySelector(".btn-warning");

async function getVehiculo(id) {
  const params = new URLSearchParams();
  params.append("operation", "getVehiculo");
  params.append("idvehiculo", id);

  try {
    const response = await fetch(
      `../../controller/vehiculo.controller.php?${params}`
    );
    const data = await response.json();
    console.log("Datos obtenidos: ", data);
    return data;
  } catch (e) {
    console.error("Error al obtener el vehículo por ID: ", e);
  }
}

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
    const response = await fetch(
      `../../controller/vehiculo.controller.php?${params}`
    );
    const data = await response.json();
    console.log("Datos obtenidos: ", data);
    return data;
  } catch (error) {
    console.error("Error al actualizar el vehículo: ", error);
  }
}

formulario.addEventListener("submit", async (e) => {
  e.preventDefault();

  const marca = document.querySelector("#editMarca");
  const inputIdVehiculo = idVehiculo.getAttribute("id-vehiculo");
  const inputMarca = marca.value.trim();
  const inputModelo = modelo.value.trim();
  const inputPlaca = placa.value.trim();
  const inputCapacidad = capacidad.value.trim();
  const inputCondicion = condicion.value.trim();

  // Limpiar los errores anteriores
  const danger = document.querySelectorAll(".text-danger");
  danger.forEach((element) => {
    element.remove();
  });
  const invalid = document.querySelectorAll(".is-invalid");
  invalid.forEach((element) => {
    element.classList.remove("is-invalid");
  });

  // Validar los campos
  if (!inputIdVehiculo ||
    !inputMarca ||
    !inputModelo ||
    !inputPlaca ||
    !inputCapacidad ||
    !inputCondicion
  ) {
    if (!inputIdVehiculo) idVehiculo.classList.add("is-invalid");
    if (!inputMarca) marca.classList.add("is-invalid");
    if (!inputModelo) modelo.classList.add("is-invalid");
    if (!inputPlaca) placa.classList.add("is-invalid");
    if (!inputCapacidad) capacidad.classList.add("is-invalid");
    if (!inputCondicion) condicion.classList.add("is-invalid");
    return; // Si hay algún campo vacío, no continuar
  }

  // Confirmar antes de actualizar
  if (showConfirm("¿Deseas actualizar el vehículo?", "VEHÍCULOS")) {
    const data = await updateVehiculo(
      inputIdVehiculo,
      inputMarca,
      inputModelo,
      inputPlaca,
      inputCapacidad,
      inputCondicion
    );
    // Verificar si la actualización fue exitosa
    if (data[0].status === "success") {
      showToast(`${data[0].mensaje}`, "success", "Éxito"); // Usar "success"
      formulario.reset(); // Limpiar el formulario después de la actualización
      await getVehiculo(inputIdVehiculo); // Recargar los datos actualizados del vehículo
    } else {
      // Si no se pudo actualizar, mostrar el mensaje de error
      showToast(`${data[0].mensaje}`, "error", "Error"); // Cambiar "danger" por "error"
      marca.classList.add("is-invalid");
      const span = document.createElement("span");
      span.classList.add("text-danger");
      span.innerHTML = `${data[0].mensaje}`;
      marca.insertAdjacentElement("afterend", span);
    }
  }
});
