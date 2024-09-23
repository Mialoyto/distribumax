document.addEventListener("DOMContentLoaded", () => {
    function $(selector = null) {
        return document.querySelector(selector);
    }

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
        const response = await buscarPedido();
        const datalist = $("#datalistProducto");
        datalist.innerHTML = '';

        if (response && response.length > 0) {
            response.forEach(item => {
                const option = document.createElement('option');
                option.value = `${item.idpedido}`;
                option.textContent = `${item.idpedido}`;
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

            data.forEach(pedido => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${pedido.nombreproducto}</td>
                    <td>${pedido.cantidad_producto}</td>
                    <td>${pedido.preciounitario}</td>
                    <td>${pedido.subtotal}</td>
                    
                `;
                tbody.appendChild(row);
                subtotal += parseFloat(pedido.subtotal); // Sumar al subtotal
            });

            // Actualizar los totales
            $("#subtotal").value = subtotal.toFixed(2);
            const igv = subtotal * 0.18; // Suponiendo un IGV del 18%
            $("#igv").value = igv.toFixed(2);
            $("#total_venta").value = (subtotal + igv).toFixed(2);

        } catch (e) {
            console.error(e);
        }
    };

    $("#idpedido").addEventListener('input', async () => {
        const idpedido = $("#idpedido").value.trim();
        //console.log("Valor de idpedido:", idpedido);
        await mostraResultados();

        if (idpedido) {
            await CargarPedido(idpedido);
        }
    });
});


