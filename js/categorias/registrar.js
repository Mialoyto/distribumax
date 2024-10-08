document.addEventListener("DOMContentLoaded", () => {


    async function registrarcategoria() {
        const params = new FormData();
        params.append('operation', 'addCategoria');
        params.append('categoria', categoria.value);

        const options = {
            method: 'POST',
            body: params
        };

        const response = await fetch(`../../controller/categoria.controller.php`, options)
        return response.json()
            .catch(e => { console.error(e) })
    }

    formcategoria.addEventListener("submit", async (event) => {
        event.preventDefault();
        const resultado = await registrarcategoria();
        if (resultado) {
            alert("Registro exitoso");
            formcategoria.reset();
        }
    })
})