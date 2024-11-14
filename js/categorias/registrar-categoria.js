document.addEventListener("DOMContentLoaded", () => {

    const formcategoria = document.querySelector("#form-categoria")
    const categoria = document.querySelector("#categoria")


    async function registrarCategoria(inputCategoria) {
        const params = new FormData();
        params.append('operation', 'addCategoria');
        params.append('categoria', inputCategoria);

        const options = {
            method: 'POST',
            body: params
        };
        try {
            const response = await fetch(`../../controller/categoria.controller.php`, options);
            const data = await response.json();
            console.log(data);
            return data;

        } catch (error) {
            console.log(error);
        }
    }

    formcategoria.addEventListener("submit", async (e) => {
        e.preventDefault();
        const inputCategoria = categoria.value.trim();
        const danger = document.querySelectorAll('.text-danger');
        danger.forEach((element) => {
            element.remove();
        });
        const invalid = document.querySelectorAll('.is-invalid');
        invalid.forEach((element) => {
            element.classList.remove('is-invalid');
        });

        categoria.classList.remove("is-invalid");
        if (inputCategoria === "") {
            categoria.classList.add("is-invalid");
            return;
        }
        if (showConfirm("¿Desea registrar la categoria?", "CATEGORIA")) {
            const data = await registrarCategoria(inputCategoria);
            console.log(data[0].mensaje);
            if (data[0].idcategoria > 0) {
                showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                formcategoria.reset();
            } else {
                // showToast(`${data[0].mensaje}`, "error", "ERROR");
                categoria.classList.add("is-invalid");
                const span = document.createElement("span");
                span.classList.add("text-danger");
                span.innerHTML = `${data[0].mensaje}`;
                categoria.insertAdjacentElement("afterend", span);
            }
        }
    })


})