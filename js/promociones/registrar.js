document.addEventListener("DOMContentLoaded", () => {
    async function validarDatos() {
        const idTipoPromocion = idtipopromocion.value.trim(); 
        const inputDescripcion = descripcion.value.trim(); 
        const inputFechaInicio = fechaInicio.value.trim(); 
        const inputFechaFin = fechaFin.value.trim(); 
        const inputValorDescuento = valorDescuento.value.trim();

        if (!idTipoPromocion || !inputDescripcion || !inputFechaInicio || !inputFechaFin || !inputValorDescuento) {
            showToast("Todos los campos son obligatorios.", "error", "ERROR");
            return false;
        }

        if (new Date(inputFechaInicio) > new Date(inputFechaFin)) {
            showToast("La fecha de inicio no puede ser posterior a la fecha de fin.", "error", "ERROR");
            return false;
        }
        return true;
    }

    async function registrarPromocion() {
        const idTipoPromocion = idtipopromocion.value.trim(); 
        const inputDescripcion = descripcion.value.trim(); 
        const inputFechaInicio = fechaInicio.value.trim(); 
        const inputFechaFin = fechaFin.value.trim(); 
        const inputValorDescuento = valorDescuento.value.trim();

        // Crea los parámetros para el FormData
        const params = new FormData();
        params.append("operation", "addPromocion");
        params.append("idtipopromocion", idTipoPromocion.getAttribute("data-id")); 
        params.append("descripcion", inputDescripcion);
        params.append("fechainicio", inputFechaInicio);
        params.append("fechafin", inputFechaFin);
        params.append("valor_descuento", inputValorDescuento);

        const options = {
            method: "POST",
            body: params,
        };

        try {
            const response = await fetch(`../../controller/promocion.controller.php`, options);
            const data = await response.json(); 
            console.log(data);
            return data;
        } catch (e) {
            console.error("Error al registrar la promoción:", e);
        }
    }

    formPromocion.addEventListener("submit", async (event) => {
        event.preventDefault();
        
        const data = await validarDatos(); 

        if (!data) {
            return; 
        } else {
            if (await showConfirm("Desea registrar la promoción?", "Promociones")) {
                const data = await registrarPromocion();
                console.log(data[0]?.idpromocion);

                if (data && data[0]?.idpromocion > 0) {
                    showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                    formPromocion.reset(); 
                } else {
                    showToast(`${data[0]?.mensaje || "Error al registrar"}`, "error", "ERROR");
                }
            }
        }
    });
});