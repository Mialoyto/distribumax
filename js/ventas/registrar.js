document.addEventListener("DOMContentLoaded", () => {
    function $(selector = null) {
        return document.querySelector(selector);
    }

    window.onload = function() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0'); 
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        const minDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
        document.getElementById('fecha_venta').setAttribute('min', minDateTime);
    };

    const optionMe = $("#idmetodopago");
    const optionCo = $("#idtipocomprobante");

    (() => {
        fetch(`../../controller/metodoP.controller.php?operation=getAll`)
            .then(response => response.json())
            .then(data => {
                data.forEach(metodo => {
                    const tagOption = document.createElement('option');
                    tagOption.value = metodo.idmetodopago;
                    tagOption.innerText = metodo.metodopago;
                    optionMe.appendChild(tagOption);
                });
            })
            .catch(e => console.error(e));
    })();

    (() => {
        fetch(`../../controller/comprobante.controller.php?operation=getAll`)
            .then(response => response.json())
            .then(data => {
                data.forEach(comprobante => {
                    const tagOption = document.createElement('option');
                    tagOption.value = comprobante.idtipocomprobante;
                    tagOption.innerText = comprobante.comprobantepago;
                    optionCo.appendChild(tagOption);
                });
            })
            .catch(e => console.error(e));
    })();

    const buscarPedido = async () => {
        const params = new URLSearchParams();
        params.append('operation', 'searchPedido');
        params.append('_idpedido', $("#idpedido").value.trim());

        try {
            const response = await fetch(`../../controller/pedido.controller.php?${params}`);
            return await response.json();
        } catch (e) {
            console.error(e);
        }
    };

    const mostraResultados = async () => {
        const datalist = $("#datalistProducto");
        datalist.innerHTML = '';
        const response = await buscarPedido();

        if (response.length > 0) {
            response.forEach(item => {
                const option = document.createElement('option');
                option.value = `${item.idpedido}`;
                
                datalist.appendChild(option);
            });
            datalist.style.display = 'block';
        } else {
            datalist.style.display = 'none';
        }
    };

    const CargarPedido = async (idpedido) => {
        const params = new URLSearchParams();
        params.append('operation', 'getById');
        params.append('idpedido', idpedido);

        try {
            const response = await fetch(`../../controller/pedido.controller.php?${params}`);
            const data = await response.json();

            const tbody = $("#productosTabla tbody");
            tbody.innerHTML = ''; // Limpiar la tabla antes de añadir los nuevos resultados
            let subtotal = 0;
            let descuentoTotal = 0; // Variable para acumular el descuento total

            data.forEach(pedido => {
                const row = document.createElement('tr');
                const cantidad_producto = parseFloat(pedido.cantidad_producto);
                const preciounitario = parseFloat(pedido.preciounitario);
                const total_producto = cantidad_producto * preciounitario; // Calcular total por producto
                
                row.innerHTML = `
                    <td>${pedido.nombreproducto}</td>
                    <td>${cantidad_producto}</td>
                    <td>${preciounitario.toFixed(2)}</td>
                    <td>${pedido.precio_descuento}</td>
                    <td>${total_producto.toFixed(2)}</td>
                `;
                tbody.appendChild(row);
                
                // Sumar al subtotal y al descuento total
                subtotal += total_producto;
                descuentoTotal += parseFloat(pedido.precio_descuento);
            });

            // Actualizar los totales
            const igv = subtotal * 0.18; 
            subtotal=subtotal-igv;
            const total_venta = subtotal + igv - descuentoTotal;
            $("#subtotal").value = subtotal.toFixed(2);
            $("#igv").value = igv.toFixed(2);
            $("#total_venta").value = total_venta.toFixed(2);
            $("#descuento").value = descuentoTotal.toFixed(2);
            
        } catch (e) {
            console.error(e);
        }
    };

    async function RegistrarVenta() {
        const params = new FormData();
        params.append('operation', 'addVentas');
        params.append('idpedido', $("#idpedido").value);
        params.append('idmetodopago', optionMe.value);
        params.append('idtipocomprobante', optionCo.value);
        params.append('fecha_venta', $("#fecha_venta").value);
        params.append('subtotal', $("#subtotal").value);
        params.append('descuento', $("#descuento").value);
        params.append('igv', $("#igv").value);
        params.append('total_venta', $("#total_venta").value);

        const options = {
            method: 'POST',
            body: params
        };

        const response = await fetch(`../../controller/ventas.controller.php`, options);
        return response.json()
            .catch(e => { console.error(e); });
    }

    $("#idpedido").addEventListener('input', async () => {
        const idpedido = $("#idpedido").value.trim();
        await mostraResultados();

        if (idpedido) {
            await CargarPedido(idpedido);
        }
    });

    $("#form-venta-registrar").addEventListener("submit", async (event) => {
        event.preventDefault();
        const resultado = await RegistrarVenta();
        if (resultado) {
            alert("Venta registrada exitosamente");
            $("#form-venta-registrar").reset();
            CargarPedido.reset();
        }
    });
});
