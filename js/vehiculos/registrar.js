document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) {
        return document.querySelector(object);
    }

    const buscarConductor = async () => {
        const params = new URLSearchParams();
        params.append('operation', 'searchConductor');
        params.append('item', $("#idusuario").value);

        const option = {
            method: 'POST',
            body: params
        };

        try {
            const response = await fetch(`../../controller/vehiculo.controller.php`, option);
            return await response.json();
        } catch (e) {
            console.error(e);
        }
    };

    const mostrarResultados = async () => {
        const datalist = $("#datalistConductor");
        datalist.innerHTML = ''; // Limpiar resultados anteriores
        const response = await buscarConductor();

        if (response && response.length > 0) {
            response.forEach(item => {
                const option = document.createElement('option');
                option.value = item.idusuario; // Asigna el ID del usuario como valor del 'option'
                option.textContent = `${item.nombres} ${item.apellidos}`; // Muestra nombres y apellidos
                datalist.appendChild(option);
            });
            datalist.style.display = 'block';
        } else {
            datalist.style.display = 'none';
        }
    };

    // Evento para cuando se ingresa texto en el input de idusuario
    $("#idusuario").addEventListener('input', async () => {
        const idusuario = $("#idusuario").value;

        if (idusuario) {
            await mostrarResultados();
            console.log(idusuario);
        }
    });
    // Evento para agregar un guion -
    $("#placa").addEventListener('input', function (event) {
        let input = event.target;
        let value = input.value;
        
        // Cuando el input tiene 3 caracteres, agregamos el guion si aún no está presente
        if (value.length === 3 && !value.includes('-')) {
            input.value = value + '-';
        }
        if (value.length === 4 && value.includes('-') && event.inputType === 'deleteContentBackward') {
            input.value = value.slice(0, -1); // Borra el guion si lo tiene
        }
    });
    async function registrarVehiculo() {
        const params = new FormData();
        params.append('operation', 'addVehiculo');
        params.append('idusuario', $("#idusuario").value); // Aquí se usa 'idusuario' correctamente
        params.append('marca_vehiculo', $("#marca_vehiculo").value);
        params.append('modelo', $("#modelo").value);
        params.append('placa', $("#placa").value);
        params.append('capacidad', $("#capacidad").value);
        params.append('condicion', $("#condicion").value);

        const option = {
            method: 'POST',
            body: params
        };

        try {
            const response = await fetch(`../../controller/vehiculo.controller.php`, option);
            const data = await response.json();
            console.log(data);
            return data;
        } catch (e) {
            console.error(e);
        }
    }

    // Manejo del evento de envío del formulario
    $("#form-registrar-Vehiculo").addEventListener("submit", async (event) => {
        event.preventDefault(); // Prevenir comportamiento por defecto
        const resultado = await registrarVehiculo();

        if (resultado) {
            alert("Registro exitoso");
        } else {
            alert("Error al registrar el vehículo");
        }
    });
    
       
});
