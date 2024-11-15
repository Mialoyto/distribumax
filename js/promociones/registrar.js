// Función para registrar una promoción a través del formulario
async function registrarPromocion() {
    e.preventDefault();

    const formData = new FormData(document.querySelector("#form-promocion"));
    formData.append('operation', 'addPromocion');

    try {
        const response = await fetch('../../controller/promocion.controller.php', {
            method: 'POST',
            body: formData
        });
        const result = await response.json();

        if (result.status === 'success') {
            alert("Promoción registrada exitosamente.");
            $('#modalTipoPromocion').modal('hide');
            cargarDatos(); // Recargar la lista de promociones
        } else {
            alert(result.message || "Error al registrar la promoción.");
        }
    } catch (error) {
        console.error("Error en la solicitud:", error);
    }
}

// Cargar tipos de promociones cuando la página esté lista
document.addEventListener("DOMContentLoaded", function() {
    cargarTiposPromociones();
});

document.querySelector("#form-promocion").addEventListener("submit", registrarPromocion);
