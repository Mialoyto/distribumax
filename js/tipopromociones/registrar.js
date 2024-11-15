// Función para cargar tipos de promociones y agregar opciones al select
async function cargarTiposPromociones() {
    try {
        const response = await fetch('../../controller/tipopromociones.controller.php?operation=getAll');
        const tipos = await response.json();

        const selectElement = document.getElementById("idtipopromocion");

        // Limpiar el select antes de agregar opciones
        selectElement.innerHTML = '<option value="">Seleccione un tipo de promoción</option>';

        tipos.forEach(tipo => {
            const option = document.createElement("option");
            option.value = tipo.idtipopromocion;  // Asegúrate que coincida con el nombre de la columna de ID
            option.textContent = tipo.tipopromocion;  // Asegúrate que coincida con el nombre de la columna de descripción
            selectElement.appendChild(option);
        });
    } catch (error) {
        console.error("Error al cargar los tipos de promociones:", error);
    }
}

async function addTipoPromocion() {
    const tipopromocion = document.querySelector("#tipopromocion")
    const descripcion = document.querySelector("#descripcion")
    const inputPromocion = tipopromocion.value.trim();
    const inputDescripcion = descripcion.value.trim();

    const params = new FormData();
    params.append("operation", "addTipoPromocion");
    params.append("tipopromocion", inputPromocion);
    params.append("descripcion", inputDescripcion);
    const options = {
        method: "POST",
        body: params,
    };
    try{
        const response = await fetch(`../../controller/tipopromociones.controller.php`, options);
        const data = await response.json();
        console.log(data);
        return data;
    }catch(e){
        console.error('Error al registrar la promoción:', e);
    } 
}

const formPromocion = document.querySelector("#form-promocion");
formPromocion.addEventListener("submit", async function (e) {
    e.preventDefault();

   if(await showConfirm("Desea registrar", "Tipo de promoción")){
    const data = await addTipoPromocion();
    if(data.status === 'success'){
        alert("Tipo de promoción registrado exitosamente.");
        $('#modalTipoPromocion').modal('hide');
        cargarTiposPromociones();
    }else{
        alert(data.message || "Error al registrar el tipo de promoción.");
    }

   }
});
