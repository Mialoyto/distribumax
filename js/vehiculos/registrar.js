document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) {
        return document.querySelector(object);
    }

    const buscarConductor = async () => {
        const params = new URLSearchParams();
        params.append('operation', 'searchConductor');
        params.append('item', $("#idusuario").value);

        try {
            const response = await fetch(`../../controller/vehiculo.controller.php?${params}`);
            return await response.json();
        } catch (e) {
            console.error(e);
        }
    }

    const mostraResultados = async () => {
        const datalist = $("#datalistConductor");
        datalist.innerHTML = '';
        const response = await buscarConductor();
        
        if (response.length > 0) {
            response.forEach(item => {
                const option = document.createElement('option');
                option.value = `${item.nombres} ${item.apellidos}`; // Asegúrate de usar las propiedades correctas
                datalist.appendChild(option);
            });
            datalist.style.display = 'block';
        } else {
            datalist.style.display = 'none';
        }
    };

    $("#idusuario").addEventListener('input', async () => {
        const idusuario = $("#idusuario").value;
        if (idusuario) {
            await mostraResultados();
        }
    });

    // Si deseas buscar al cargar la página, puedes dejar esto, de lo contrario puedes eliminarlo.
    // buscarConductor();
});
