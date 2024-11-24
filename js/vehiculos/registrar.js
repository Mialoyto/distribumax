document.addEventListener("DOMContentLoaded", () => {
    function $(selector = null) {
        return document.querySelector(selector);
    }

    const listProveedor = $("#list-usuario");
    const idProveedor = $("#idusuario");

    // Función para buscar conductores
    const buscarConductor = async (usuario) => {
        const params = new URLSearchParams();
        params.append('operation', 'searchConductor');
        params.append('item', usuario);

        try {
            const response = await fetch(`../../controller/vehiculo.controller.php`, {
                method: 'POST',
                body: params
            });
            return await response.json();
        } catch (e) {
            console.error("Error al buscar conductor:", e);
        }
    };

    // Renderizar datos en la lista
    const renderData = (data) => {
        listProveedor.innerHTML = ""; // Limpiar lista
        if (data && data.length) {
            listProveedor.style.display = "block";

            data.forEach((item) => {
                const li = document.createElement("li");
                li.classList.add("list-group-item");
                li.textContent = `${item.nombres} ${item.apellidos}`;
                li.addEventListener("click", () => {
                    idProveedor.value = `${item.nombres} ${item.apellidos}`;
                    idProveedor.setAttribute("data-id", item.idusuario);
                    listProveedor.innerHTML = "";
                    listProveedor.style.display = "none";
                });
                listProveedor.appendChild(li);
            });
        } else {
            const li = document.createElement("li");
            li.classList.add("list-group-item");
            li.textContent = "Conductor no encontrado";
            listProveedor.appendChild(li);
        }
    };

    // Evento para buscar conductores cuando se escribe en el input
    idProveedor.addEventListener("input", async () => {
        const query = idProveedor.value.trim();
        if (!query) {
            listProveedor.innerHTML = "";
            listProveedor.style.display = "none";
            return;
        }
        const dataProveedor = await buscarConductor(query);
        renderData(dataProveedor);
    });

    // Validar y registrar vehículo
    const registrarVehiculo = async () => {
        const params = new FormData();
        params.append('operation', 'addVehiculo');
        params.append('idusuario', idProveedor.getAttribute("data-id")); // Aquí tomamos el id del conductor
        params.append('marca_vehiculo', $("#marca_vehiculo").value);
        params.append('modelo', $("#modelo").value);
        params.append('placa', $("#placa").value);
        params.append('capacidad', $("#capacidad").value);
        params.append('condicion', $("#condicion").value);

        try {
            const response = await fetch(`../../controller/vehiculo.controller.php`, {
                method: 'POST',
                body: params
            });
            return await response.json();
        } catch (e) {
            console.error("Error al registrar vehículo:", e);
        }
    };

    // Limpiar formulario
    const limpiarFormulario = () => {
        $("#form-registrar-Vehiculo").reset();
    };

    // Manejo del envío del formulario
    $("#form-registrar-Vehiculo").addEventListener("submit", async (event) => {
        event.preventDefault();
        const resultado = await registrarVehiculo();
        if (resultado) {
            showToast("Vehiculo registrado correctamente", "success", "SUCCESS");
            limpiarFormulario();
        } else {
            showToast("No es posible registrarlo", "warning", "WARNING");
        }
    });

    // Formato automático de placa

});
