document.addEventListener("DOMContentLoaded", () => {

  function $(object = null) {
    return document.querySelector(object);
  }

  const placa = $("#idvehiculo");
  const lista = $("#list-vehiculo");
  const provincia = $("#provincia");
  const tabla = $("#detalle-despacho tbody");
  const formDespacho = $("#AddDespacho");
  const count = document.querySelectorAll("#detalle-despacho tbody tr");
  console.log(count.length);
  let dtDespacho;
  let idDespacho = -1;

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

  // TODO: RENDERIZA LOS RESULTADOS DE LA BUSQUEDA
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

        // $("#condutor").setAttribute("id-user", element.idusuario);
        // Agrega evento para seleccionar el vehículo
        li.addEventListener("click", async () => {
          $("#idvehiculo").setAttribute("id-veh", element.idvehiculo);
          $("#idvehiculo").value = element.placa;

          // Rellena los detalles del vehículo
          $("#conductor").value = element.conductor;
          $("#conductor").setAttribute("id-user", element.idusuario);
          $("#modelo").value = element.modelo;
          $("#capacidad").value = element.capacidad;
          $("#placa").value = element.placa;
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
      console.log(data);
      return data;
    } catch (e) {
      console.error("Error al obtener las ventas:", e);
      return null;
    }
  }

  // TODO: RENDERIZAR LAS VENTAS PENDIENTES
  async function renderVentasPendientes(provincia) {
    const data = await getVentasPendientes(provincia);
    if (data) {
      // LIMPIAR LA TABLA
      tabla.innerHTML = "";
      // RENDERIZAR EN LA TABLA
      data.forEach((element) => {
        const tr = document.createElement("tr");
        tr.innerHTML = `
        <td id-venta="${element.idventa}" class="ventas" >${element.codigo}</td>
        <td class="productos" id-producto="${element.idproducto}" >${element.producto}</td>
        <td>${element.unidadmedida}</td>
        <td>${element.cantidad_producto}</td>
        <td>${element.total_venta_producto}</td>
        `;
        tabla.appendChild(tr);
      });
    } else {
      console.log("estoy en la linea 169");
      tableContent = `<tr><td colspan="5">No hay ventas pendientes</td></tr>`;
    }
  }

  provincia.addEventListener("change", async (e) => {
    const provincia = e.target.value;
    console.log(provincia);
    console.log(provincia ? true : false);

    if (provincia) {
      await cargarDatos(provincia);

    } else {
      // Destruir DataTable existente
      if (dtDespacho) {
        dtDespacho.destroy();
        tabla.innerHTML = "";
      }
      console.log("No hay provincia seleccionada");
      tabla.innerHTML = `<tr><td colspan="5">No hay ventas pendientes</td></tr>`;
    }
  });

  async function cargarDatos(provincia) {
    try {
      if (dtDespacho) {
        dtDespacho.destroy();
      }

      await renderVentasPendientes(provincia);

      renderDataTable();
    } catch {
      console.log("Error al cargar los datos");
      tabla.innerHTML = `<tr><td colspan="5">Error al cargar los datos</td></tr>`;
    }
  }

  function renderDataTable() {
    dtDespacho = new DataTable("#detalle-despacho", {
      retrieve: true,
      destroy: true,
      ordering: true,
      searching: true,
      columnDefs: [

        { width: "20%", targets: 0 },
        { width: "20%", targets: 1 },
        { width: "20%", targets: 2 },
        { width: "20%", targets: 3 },
        { width: "20%", targets: 4 }
      ],
      language: {
        sEmptyTable: "No hay datos disponibles en la tabla",
        info: "",
        sInfoFiltered: "(filtrado de _MAX_ entradas en total)",
        sLengthMenu: "Filtrar: _MENU_",
        sLoadingRecords: "Cargando...",
        sProcessing: "Procesando...",
        sSearch: "Buscar:",
        sZeroRecords: "No se encontraron resultados",
        oAria: {
          sSortAscending:
            ": Activar para ordenar la columna de manera ascendente",
          sSortDescending:
            ": Activar para ordenar la columna de manera descendente",
        },
      },
    });
  }

  cargarDatos();

  async function addDespacho() {

    const idvehiculo = parseInt($("#idvehiculo").getAttribute("id-veh"));
    const iduser = parseInt($("#conductor").getAttribute("id-user"));
    const fecha = $("#fecha-despacho").value;
    console.log("idvehiculo: ", idvehiculo);
    console.log("idusario: ", iduser);
    console.log("fecha: ", fecha);

    const params = new FormData();
    params.append("operation", "addDespacho");
    params.append("idvehiculo", idvehiculo);
    params.append("idusuario", iduser);
    params.append("fecha_despacho", fecha);

    const options = {
      method: "POST",
      body: params,
    };

    try {
      const response = await fetch(`../../controller/despacho.controller.php`, options);
      const data = await response.json();
      console.log(data);
      return data;
    } catch (e) {
      console.error("Error al agregar el despacho: ", e);
    }
  }

  // TODO: EVENTO PARA AGREGAR EL DESPACHO
  formDespacho.addEventListener("submit", async (e) => {
    e.preventDefault();

    if (!validarTabla()) {
      return;
    }

    if (await showConfirm("¿Está seguro de agregar el despacho?")) {
      const response = await addDespacho();
      console.log(response);
      idDespacho = response.iddespacho;
      // console.log(response);
      if (response.status) {
        showToast(`${response.message}`, "success", "SUCCESS");
        const responseDetalle = await addDetalleDespacho();
        if (responseDetalle.status) {
          showToast(`${responseDetalle.message}`, "success", "SUCCESS");
          location.reload();
        } else {
          showToast(`${responseDetalle.message}`, "error", "ERROR");
          return;
        }

      } else {
        showToast(`${response.message}`, "error", "ERROR");
        return;
      }
    }
  });


  async function addDetalleDespacho() {

    const rows = document.querySelectorAll("#detalle-despacho tbody tr");
    console.log(rows);
    const productos = [];
    let idventa;
    let idproducto;

    rows.forEach((element) => {
      console.log(element);
      idventa = element.querySelector(".ventas").getAttribute("id-venta");
      idproducto = element.querySelector(".productos").getAttribute("id-producto");
      productos.push({
        idventa,
        idproducto,
      });
    });

    // if(idDespacho === -1)

    const params = new FormData();
    params.append("operation", "addDetalleDespacho");
    params.append("iddespacho", idDespacho);
    console.log(idDespacho);
    productos.forEach((producto, index) => {
      params.append(`productos[${index}][idventa]`, producto.idventa);
      params.append(`productos[${index}][idproducto]`, producto.idproducto);
    });

    const options = {
      method: "POST",
      body: params
    };

    try {

      const response = await fetch(`../../controller/detalledespacho.controller.php`, options);
      const data = await response.json();
      console.log(data);
      return data;

    } catch (e) {
      console.error("Error al agregar el detalle del despacho: ", e);
    }
  }


  // Agregar esta función de validación
  function validarTabla() {
    const rows = document.querySelectorAll("#detalle-despacho tbody tr");
    if (rows.length === 0) {
      showToast("No hay productos para despachar", "error", "ERROR");
      return false;
    }

    // Validar que no sea la fila de "No hay ventas pendientes"
    const emptyRow = document.querySelector("#detalle-despacho tbody tr td[colspan='5']");
    if (emptyRow) {
      showToast("No hay productos para despachar, seleccione una provincia", "error", "ERROR");
      return false;
    }

    return true;
  }

});

