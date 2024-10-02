document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) {
        return document.querySelector(object);
    }
    const idproducto = document.querySelector("#searchProducto");
    const datalist = document.querySelector("#datalistProducto");

    let producto = '';

    if (idproducto) {
        idproducto.addEventListener('input', event => {
            producto = event.target.value;
            console.log(producto);
            mostraResultados();
        })
    };
    const searchProducto = async () => {
        const searchData = new URLSearchParams();

        searchData.append('operation', 'searchProducto');
        searchData.append('_item', producto);

        try {
            const response = await fetch(`../../controller/producto.controller.php?${searchData}`);
            const data = await response.json();
            console.log(data);
            return data;
        } catch (e) {
            console.error(e);
        }
    };

    const mostraResultados = () => {
        searchProducto()

            .then(response => {
                datalist.innerHTML = '';
                response.forEach(item => {
                    const option = document.createElement('option');
                    option.setAttribute('data-id', item.idproducto)
                    option.innerText = item.nombreproducto;
                    datalist.appendChild(option);
                })

            })
    };
    let selectedId;

    idproducto.addEventListener('change', async event => {
        const selectedDistrito = event.target.value;
        const options = datalist.children;

        for (let i = 0; i < options.length; i++) {
            if (options[i].value === selectedDistrito) {
                selectedId = options[i].getAttribute('data-id');
                // ERROR
                // await cargarStock();
                break;
            }
        }
    });

    async function registrarkardex() {
        const params = new FormData();
        params.append('operation', 'add');
        params.append('idusuario', $("#idusuario").value);
        params.append('idproducto', selectedId);
        params.append('stockactual', $("#stockactual").value);
        params.append('tipomovimiento', $("#tipomovimiento").value);
        params.append('cantidad', $("#cantidad").value);
        params.append('motivo', $("#motivo").value)

        const options = {
            method: 'POST',
            body: params
        }
        const response = await fetch(`../../controller/kardex.controller.php`, options)
        return response.json()
            .catch(e => { console.error(e) })
    }


    const formkardex = $("#form-registrar-kardex").addEventListener('submit', async (event) => {
        event.preventDefault();

        const resultado = await registrarkardex();
        if (resultado) {
            alert("exitoso!")
            formkardex.reset();
        } else {
            alert("No se puede")
        }
    })
});