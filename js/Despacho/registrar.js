document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) {
    return document.querySelector(object);
  }

  const buscarVehiculo = async () => {
    const params = new URLSearchParams();
    params.append("operation", "searchVehiculo");
    params.append("item", $("#idvehiculo").value);

    const option = {
      method: "POST",
      body: params,
    };
    try {
      const response = await fetch(
        `../../controller/vehiculo.controller.php`,
        option
      );
      return await response.json();
    } catch (e) {
      console.error(e);
    }
    //  console.log(data)
  };

  const mostrarResultados = async () => {
    const datalist = $("#list-vehiculo");
    datalist.innerHTML = "";
    const response = await buscarVehiculo();

    if (response.length > 0) {
      $("#list-vehiculo").style.display = "block"; // Show the list

      response.forEach((element) => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.innerHTML = `${element.marca_vehiculo} - ${element.modelo} - ${element.placa}`;

        // Event listener to set vehicle details when clicked
        li.addEventListener("click", () => {
          $("#idvehiculo").setAttribute("data-id", element.idvehiculo);
          $("#idvehiculo").value = element.idvehiculo;

          // Populate vehicle details
          $("#datos").value = element.datos;
          $("#modelo").value = element.modelo;
          $("#capacidad").value = element.capacidad;
          $("#placa").value = element.placa;
        });

        datalist.appendChild(li); // Add item to the list
      });
    } else {
      const li = document.createElement("li");
      li.classList.add("list-group-item");
      li.innerHTML = `<b>Vehículo no encontrado</b>`;
      datalist.appendChild(li);
      $("#list-vehiculo").style.display = "none"; // Hide if no results
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
    $("#idventa").setAttribute("disabled", true);
    $("#btnGetAll").setAttribute("disabled", true);
  }
  desactivarCampos();
});
