async function getEmpresaById(id) {
    const params = new URLSearchParams();
    params.append("operation", "getEmpresaById");
    params.append("idempresaruc", id);

    try {
        const response = await fetch(`../../controller/empresa.controller.php?${params}`);
        const data = await response.json();
        console.log("Datos obtenidos:", data);
        return data;
    } catch (error) {
        console.error("Error al obtener la empresa por id: ", error);
    }
}

async function cargarDatosModal(id) {
    try {
        const modal = document.querySelector("#edit-empresa");
        const inputRazonSocial = modal.querySelector("#id-empresa-ruc");
        const inputDireccion = modal.querySelector("#id-direccion");
        const inputEmail = modal.querySelector("#id-email");
        const inputTelefono = modal.querySelector("#id-telefono");
        const btn = modal.querySelector(".btn-success");
        inputRazonSocial.classList.remove("is-invalid");
        inputDireccion.classList.remove("is-invalid");
        inputEmail.classList.remove("is-invalid");
        inputTelefono.classList.remove("is-invalid");
        const spanError = modal.querySelector(".text-danger");
        if (spanError) {
            spanError.remove();
        }
        btn.setAttribute("disabled", "true");
        inputRazonSocial.value = "Cargando...";
        inputDireccion.value = "Cargando...";
        inputEmail.value = "Cargando...";
        inputTelefono.value = "Cargando...";

        const data = await getEmpresaById(id);
        console.log("Datos para el modal:", data);
        if (data && data.length > 0) {
            inputRazonSocial.value = data[0].razonsocial;
            inputDireccion.value = data[0].direccion;
            inputEmail.value = data[0].email;
            inputTelefono.value = data[0].telefono;

            btn.removeAttribute("disabled");
        } else {
            console.log("No hay datos disponibles para esta empresa");
        }
    } catch (error) {
        console.error("Error al cargar los datos en el modal:", error);
    }
}

async function updateEmpresa(id, razonSocial, direccion, email, telefono) {
    const params = new URLSearchParams();
    params.append("operation", "updateEmpresa");
    params.append("idempresaruc", id);
    params.append("razonsocial", razonSocial);
    params.append("direccion", direccion);
    params.append("email", email);
    params.append("telefono", telefono);

    try {
        const response = await fetch(`../../controller/empresa.controller.php?${params}`);
        const data = await response.json();
        console.log("Datos obtenidos:", data);
        return data;
    } catch (error) {
        console.error("Error al actualizar la empresa:", error);
    }
}