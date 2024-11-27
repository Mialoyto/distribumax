document.addEventListener("DOMContentLoaded", () => {

  function $(object = null) {
    return document.querySelector(object);
  }

  const placa = $("#idvehiculo");
  const lista = $("#list-vehiculo");
  const provincia = $("#provincia");
  const tabla = $("#detalle-despacho tbody");

  $("#idvehiculo").addEventListener("input", async () => {
    const idvehiculo = $("#idvehiculo").value;
    console.log(idvehiculo);
    console.log(idvehiculo.length);
    console.log(idvehiculo ? true : false);
    if (!idvehiculo) {
      lista.innerHTML = "";
      $("#modelo").value = '';
      $("#capacidad").value = '';
      $("#placa").value = '';
      $("#conductor").value = '';
      provincia.innerHTML = '';
      provincia.innerHTML = '<option value="" selected>Seleccione una provincia</option>';

    } else {
      const INPUTPLACA = placa.value.trim();
      console.log(INPUTPLACA);
      await mostrarResultados(INPUTPLACA);
    }
  });

  // TODO: FUNCION PARA BUSCAR VEHICULO POR LA PLACA
  async function buscarVehiculo(idvehiculo) {
    const params = new URLSearchParams();
    params.append("operation", "searchVehiculo");
    params.append("item", idvehiculo);

    const option = {
      method: "POST",
      body: params,
    };
    try {
      const response = await fetch(`../../controller/vehiculo.controller.php`, option);
      if (!response.ok) {
        throw new Error("Error en la solicitud al servidor.");
      } else {
        const data = await response.json();
        return data;
      }
    } catch (e) {
      console.error("Error al buscar el vehículo:", e);
      return null; // Retorna null en caso de error
    }
  };

  async function mostrarResultados(placa) {
    const datalist = lista;
    datalist.innerHTML = ""; // Limpia la lista antes de mostrar resultados
    const response = await buscarVehiculo(placa);
    console.log(response.length);
    console.log(response);
    if (response && response.length > 0) {
      lista.style.display = "block"; // Muestra la lista

      response.forEach((element) => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.innerHTML = `${element.placa}`;

        // Agrega evento para seleccionar el vehículo
        li.addEventListener("click", async () => {
          $("#idvehiculo").setAttribute("data-id", element.idvehiculo);
          $("#idvehiculo").value = element.placa;

          // Rellena los detalles del vehículo
          $("#conductor").value = element.conductor || "";
          $("#modelo").value = element.modelo || "";
          $("#capacidad").value = element.capacidad || "";
          $("#placa").value = element.placa || "";
          // ? DESPUES DE SELECCIONAR UN VEHICULO CARGA LAS VENTAS DE LA PROVINCIA
          await renderSelect();
          // Oculta la lista después de seleccionar
          lista.style.display = "none";
          lista.innerHTML = ""; // Limpia la lista después de seleccionar
        });
        lista.innerHTML = ""; // Limpia la lista antes de mostrar resultados
        datalist.appendChild(li); // Añade el ítem a la lista
        // datalist.innerHTML = ""; // Limpia la lista antes de mostrar resultados
      });
    } else {
      const li = document.createElement("li");
      li.classList.add("list-group-item");
      li.innerHTML = `<b>Vehículo no encontrado</b>`;
      datalist.appendChild(li);
      $("#list-vehiculo").style.display = "none"; // Oculta la lista si no hay resultados
    }
  };

  // TODO: FUNCION PARA BUSCAR LAS VENTAS POR PROVINCIA
  async function getProvincias() {
    const params = new URLSearchParams();
    params.append("operation", "listProvinciasVentas");
    try {
      const response = await fetch(`../../controller/despacho.controller.php?${params}`);
      const data = await response.json(); // Obtener datos en JSON
      console.log(data);
      return data;
    } catch (e) {
      console.error("Error al obtener las ventas:", e);
      return null;
    }
  }

  // TODO: FUNCION PARA RENDERIZAR LAS PROVINCIAS EN EL SELECT
  async function renderSelect() {
    const provincias = await getProvincias();
    console.log(provincias);
    const select = $("#provincia");
    provincia.innerHTML = "";
    provincia.innerHTML = '<option value="" selected>Seleccione una provincia</option>';
    provincias.forEach((provincia) => {
      const option = document.createElement("option");
      option.value = provincia.provincia;
      option.textContent = provincia.provincia;
      select.appendChild(option);
    });
  }

  // TODO: FUNCION PARA LISTAR LAS VENTAS POR PROVINCIA
  async function getVentasPendientes(provincia) {
    const params = new URLSearchParams();
    params.append("operation", "listVentasPorProvincia");
    params.append("provincia", provincia);
    try {
      const response = await fetch(`../../controller/despacho.controller.php?${params}`);
      const data = await response.json(); // Obtener datos en JSON
      return data;
    } catch (e) {
      console.error("Error al obtener las ventas:", e);
      return null;
    }
  }




  provincia.addEventListener("change", async () => {
    const provincia = $("#provincia").value;
    console.log(provincia);
    if (provincia) {
      const data = await getVentasPendientes(provincia);
      console.log(data);
      if (data) {
        // LIMPIAR LA TABLA
        tabla.innerHTML = "";
        // RENDERIZAR EN LA TABLA
        data.forEach((element) => {

          const tr = document.createElement("tr");
          tr.innerHTML = `
        <td>${element.codigo}</td>
        <td>${element.producto}</td>
        <td>${element.unidadmedida}</td>
        <td>${element.cantidad_producto}</td>
        <td>${element.total_venta_producto}</td>
        `;
          tabla.appendChild(tr);
        });
      } else {
        console.log('No hay ventas pend');

      }
    } else {
      tabla.innerHTML = "";
      return;
    }
  });
});
