document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) {
    return document.querySelector(object);
  }

  let venta;

  async function getVenta(venta) {
    const params = new URLSearchParams();
    params.append("operation", "buscarventa");
    params.append("item", venta);

    const response = await fetch(`../../controller/ventas.controller.php?${params}`);
    return response.json(); // Retorna la promesa resuelta
  }

  async function getAll() {
    const params = new URLSearchParams();
    params.append("operation", "getventas");
    const response = await fetch(`../../controller/ventas.controller.php?${params}`);
    const data = await response.json(); // Obtener datos en JSON

    const renderdatos = document.querySelector("#detalle-ventas tbody");
    renderdatos.innerHTML = ""; // Limpiar la tabla

    data.forEach(venta => {
      const tr = document.createElement("tr");
      tr.innerHTML = `
        <td>${venta.idventa}</td>
        <td>${venta.nombreproducto}</td>
        <td>${venta.cantidad_producto}</td>
        <td>${venta.unidad_medida}</td>
        <td>${venta.precio_unitario}</td>
        <td>${venta.subtotal}</td>
        <td>${venta.descuento}</td>
        <td>${venta.total_venta}</td>
        <td><button class="btn btn-danger btn-sm eliminar-fila">Eliminar</button></td>
      `;
      tr.querySelector(".eliminar-fila").addEventListener("click", () => {
        tr.remove();
      })
      renderdatos.appendChild(tr);
    });
  }

  async function renderData() {
    $("#list-venta").innerHTML = "";
    const response = await getVenta(venta); // Llama a getVenta con el valor de 'venta'

    if (response.length > 0) {
      $("#list-venta").style.display = "block";
      response.forEach((item) => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.innerHTML = `${item.idventa} <h6 class="btn btn-secondary btn-sm h-25 d-inline-block">${item.idpedido}</h6>`;

        li.addEventListener("click", () => {
          $("#idventa").setAttribute("data-id", item.idventa);
          $("#idventa").value = item.idventa;

          const renderdatos = document.querySelector("#detalle-ventas tbody");
          renderdatos.innerHTML = ""; // Limpiar la tabla

          const tr = document.createElement("tr");
          tr.innerHTML = `
            <td>${item.idventa}</td>
            <td>${item.nombreproducto}</td>
            <td>${item.cantidad_producto}</td>
            <td>${item.unidad_medida}</td>
            <td>${item.precio_unitario}</td>
            <td>${item.subtotal}</td>
            <td>${item.descuento}</td>
            <td>${item.total_venta}</td>
            <td><button class="btn btn-danger btn-sm eliminar-fila">Eliminar</button></td>
          `;
          tr.querySelector(".eliminar-fila").addEventListener("click", () => {
            tr.remove();
          });
          renderdatos.appendChild(tr); // Agregar fila a la tabla
        });

        $("#list-venta").appendChild(li); // Agregar elemento a la lista
      });
    } else {
      const li = document.createElement("li");
      li.classList.add("list-group-item");
      li.innerHTML = `<b>Venta no encontrada</b>`;
      $("#list-venta").appendChild(li);
    }
  }

  $("#idventa").addEventListener("input", async () => {
    venta = $("#idventa").value.trim();

    if (!venta) {
      $("#list-venta").style.display = "none";
    } else {
      await renderData(); // Llama a renderData
    }
  });

  // Evento para el botón de obtener todas las ventas
  $("#btnGetAll").addEventListener("click", async (event) => {
    event.preventDefault();
    await getAll(); // Llama a getAll para obtener y renderizar todas las ventas
  });

});
