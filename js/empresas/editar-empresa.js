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

//FUNCION PARA CARGAR LOS DATOS Y ENVIARLO A LA BASE DE DATOS
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

async function formUpdateEmpresa(id, razonSocial, direccion, email, telefono) {
    const danger = document.querySelectorAll(".text-danger");
    danger.forEach((element) =>{
        element.remove();
    });
    const invalid = document.querySelectorAll(".is-invalid");
    invalid.forEach((element) =>{
        element.classList.remove("is-invalid");
    });
    if(await showConfirm("¿Desea actualizar la empresa?", "EMPRESAS")){
        const data = await updateEmpresa(
            id,
            razonSocial,
            direccion,
            email,
            telefono
        );
        console.log(data);

        const STATUS = data[0].estado;
        if(!STATUS){
            inputEmail.classList.add("is-invalid");
            const span = document.createElement("span");
            span.classList.add("text-danger");
            span.innerHTML = `${data[0].mensaje}`;
            inputEmail.insertAdjacentElement("afterend", span);
        }else{
            showToast(`${data[0].mensaje}`, "success", "SUCCESS");
        }
    }else{
        return;
    }
}