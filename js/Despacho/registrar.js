document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) {
    return document.querySelector(object);
  }
  
 
  function generarFechaActual() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day}T${hours}:${minutes}`;
  }
  async function Validarfecha() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const minDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
    document.getElementById('fecha_despacho').setAttribute('min', minDateTime);
  }
  generarFechaActual();
  Validarfecha();
  const buscarVehiculo = async () => {
    const params = new URLSearchParams();
    params.append("operation", "searchVehiculo");
    params.append("item", $("#idvehiculo").value);
  
    const option = {
      method: "POST",
      body: params,
    };
  
    try {
      const response = await fetch(`../../controller/vehiculo.controller.php`, option);
      if (!response.ok) {
        throw new Error("Error en la solicitud al servidor.");
      }
      return await response.json();
    } catch (e) {
      console.error("Error al buscar el vehículo:", e);
      return null; // Retorna null en caso de error
    }
  };
  
  const mostrarResultados = async () => {
    const datalist = $("#list-vehiculo");
    datalist.innerHTML = ""; // Limpia la lista antes de mostrar resultados
  
    const response = await buscarVehiculo();
    if (response && response.length > 0) {
      $("#list-vehiculo").style.display = "block"; // Muestra la lista
  
      response.forEach((element) => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.innerHTML = `${element.marca_vehiculo} - ${element.modelo} - ${element.placa}`;
  
        // Agrega evento para seleccionar el vehículo
        li.addEventListener("click", () => {
          $("#idvehiculo").setAttribute("data-id", element.idvehiculo);
          $("#idvehiculo").value = element.placa;
  
          // Rellena los detalles del vehículo
          $("#datos").value = element.datos || "";
          $("#modelo").value = element.modelo || "";
          $("#capacidad").value = element.capacidad || "";
          $("#placa").value = element.placa || "";
  
          // Oculta la lista después de seleccionar
          $("#list-vehiculo").style.display = "none";
        });
  
        datalist.appendChild(li); // Añade el ítem a la lista
      });
    } else {
      const li = document.createElement("li");
      li.classList.add("list-group-item");
      li.innerHTML = `<b>Vehículo no encontrado</b>`;
      datalist.appendChild(li);
      $("#list-vehiculo").style.display = "none"; // Oculta la lista si no hay resultados
    }
  };
  

  $("#idvehiculo").addEventListener("input", async () => {
    const idvehiculo = $("#idvehiculo").value;
    if (idvehiculo == "") {
      $("#modelo").value='';
      $("#capacidad").value='';
      $("#placa").value='';
      $("#datos").value='';
      $("#btnGetAll").setAttribute("disabled",true);
 
    } else {
        await mostrarResultados();
        $("#btnGetAll").removeAttribute("disabled");
    }
  });

  function desactivarCampos() {
    $("#modelo").setAttribute("disabled", true);
    $("#capacidad").setAttribute("disabled", true);
    $("#placa").setAttribute("disabled", true);
    $("#datos").setAttribute("disabled", true);
    // $("#idventa").setAttribute("disabled", true);
    $("#btnGetAll").setAttribute("disabled", true);
  }
  desactivarCampos();

  let venta;

  // async function getVenta(venta) {
  //   const params = new URLSearchParams();
  //   params.append("operation", "buscarventa");
  //   params.append("item", venta);

  //   const response = await fetch(`../../controller/ventas.controller.php?${params}`);
  //   return response.json(); // Retorna la promesa resuelta
  // }

  async function getAll(provincia) {
    const params = new URLSearchParams();
    params.append("operation", "getventas");
    params.append("provincia", provincia);
    const response = await fetch(`../../controller/ventas.controller.php?${params}`);
    const data = await response.json(); // Obtener datos en JSON
    console.log(data);
    return data;
    // const renderdatos = document.querySelector("#detalle-ventas tbody");
    // renderdatos.innerHTML = ""; // Limpiar la tabla

    // data.forEach(venta => {
    //   const tr = document.createElement("tr");
    //   tr.innerHTML = `
    //     <td>${venta.idventa}</td>
    //     <td>${venta.nombreproducto}</td>
    //     <td>${venta.cantidad_producto}</td>
    //     <td>${venta.unidad_medida}</td>
    //     <td>${venta.precio_unitario}</td>
    //     <td>${venta.subtotal}</td>
    //     <td>${venta.descuento}</td>
    //     <td>${venta.total_venta}</td>
    //     <td><button class="btn btn-danger btn-sm eliminar-fila">Eliminar</button></td>
    //   `;
    //   tr.querySelector(".eliminar-fila").addEventListener("click", () => {
    //     tr.remove();
    //   })
    //   renderdatos.appendChild(tr);
    // });

    
  }

  const listprovincia = $("#list-provincias");
  const idprovincia = $("#provincia");

  async function renderData(provincia) {
    $("#list-provincias").innerHTML = "";
    //const response = await getAll(provincia); // Llama a getVenta con el valor de 'venta'
      listprovincia.innerHTML="";
      if(provincia && provincia.length){
        listprovincia.style.display='block';
       provincia.forEach(item => {
          const li = document.createElement("li");
          li.classList.add("list-group-item");
          li.textContent=`${item.provincia}`;
          li.addEventListener("click",()=>{
            idprovincia.value=`${item.provincia}`;
            idprovincia.setAttribute("data-id",item.provincia);
            listprovincia.innerHTML="";
            listprovincia.style.display="none";
          });
          listprovincia.appendChild(li);
        });
      }else{
        const li =document.createElement("li");
        li.classList.add("list-group-item");
        li.textContent="No hay registros con esta provincia";
        listprovincia.appendChild(li);
      }
   
  }

  

  idprovincia.addEventListener("input",async()=>{
    const query=idprovincia.value.trim();
    if(!query){
      listprovincia.innerHTML="";
      listprovincia.style.display="none";
      return;
    }else{
      const dataprovincia = await getAll(query);
      renderData(dataprovincia);
    }
  })
  // async function RegistrarDespacho(idventa) {
  //   const params = new FormData();
  //   params.append('operation','add');
  //   params.append('idventa',idventa);
  //   params.append('idvehiculo',$("#idvehiculo").value);
  //   params.append('idusuario',$("#idusuario").value);
  //   params.append('fecha_despacho',$('#fecha_despacho').value);
  //   const options={
  //     method : 'POST',
  //     body   : params
  //   }

  //   const response = await fetch(`../../controller/despacho.controller.php`,options);
  //   const data = await response.json();
  //   console.log(data);
  //   return data;
  
  // }
  
  // //aqui es donde se agregara mas de una venta
  // async function RegistrarDetalledespacho(iddespacho) {
  //   let dataventa=[];
  //   const  params= new FormData();
  //   params.append('operation','add');
  //   params.append('idventa',dataventa);
  //   params.append('iddespacho',iddespacho)
  // }
});
