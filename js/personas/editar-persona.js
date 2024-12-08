// FUNCION PARA OBTENER LA PERSONA POR ID
async function getPersona(id) {
    const params = new URLSearchParams();
    params.append("operation", "getPersona");
    params.append("idpersonanrodoc", id);

    try {
        const response = await fetch(`../../controller/persona.controller.php?${params}`);
        const data = await response.json();
        return data;
    } catch (e) {
        console.error("Error al obtener la persona por ID: ", e);
    }
}

// FUNCION PARA CARGAR LOS DATOS Y ENVIARLO A LA BASE DE DATOS
async function updatePersona(id, dni, nombres, appaterno, apmaterno, telefono, direccion, distrito) {
    const params = new URLSearchParams();
    params.append("operation", "updatePersona");
    params.append("idpersonanrodoc", id);
    params.append("idtipodocumento", dni);
    params.append("nombres", nombres);
    params.append("appaterno", appaterno);
    params.append("apmaterno", apmaterno);
    params.append("telefono", telefono);
    params.append("direccion", direccion);
    params.append("distrito", distrito);

    try {
        const response = await fetch(`../../controller/persona.controller.php?${params}`);
        const data = await response.json();
        console.log(data);
        return data;
    } catch (error) {
        console.error("Error al actualizar la persona: ", error);
    }
}

// FUNCION PARA ACTUALIZAR LA PERSONA CON VALIDACIONES
async function formUpdatePersona(id, dni, nombres, appaterno, apmaterno, telefono, direccion, distrito, inputDNI) {
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
    if (await showConfirm("¿Desea actualizar la persona?", "PERSONAS")) {
        const data = await updatePersona(
            id,
            dni,
            nombres,
            appaterno,
            apmaterno,
            telefono,
            direccion,
            distrito
        );
        //  VALIDAMOS SI LA ACTUALIZACION FUE EXITOSA
        const STATUS = data[0].estado;
        if (!STATUS) {
            inputDNI.classList.add("is-invalid");
            showToast(`${data[0].mensaje}`, "error", "ERROR");
        } else {
            showToast(`${data[0].mensaje}`, "success", "SUCCESS");
        }
    }
}
// ? FIN DEL CODIGO REFACTORIZADO