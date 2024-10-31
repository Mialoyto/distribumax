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
     console.log(response)
   }
    getVenta();
   async function renderData() {
     $("#list-venta").innerHTML = "";
     const response = await getVenta(venta); // Llama a getVenta con el valor de 'venta'
 
     if ( response.length > 0) {
       $("#list-venta").style.display = "block";
 
       response.forEach((item) => {
         const li = document.createElement("li");
         li.classList.add("list-group-item");
         li.innerHTML = `${item.idventa} <h6 class="btn btn-secondary btn-sm h-25 d-inline-block">${item.idpedido}</h6>`;
         
         li.addEventListener("click", () => {
           $("#idventa").setAttribute("data-id", item.idventa);
           $("#idventa").value = item.idventa;
 
           // Limpiar el cuerpo de la tabla
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
              <td><button class="btn btn-danger btn-sm">Eliminar</button></td>
            `;
            renderdatos.appendChild(tr); // Agregar fila a la tabla
     
           // Crear filas para cada producto en el detalle
           
         });
 
         $("#list-venta").appendChild(li); // Agregar elemento a la lista
       });
     } else {
       const li = document.createElement("li");
       li.classList.add("list-group-item");
       li.innerHTML = `<b>Proveedor no encontrado</b>`;
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
 });
 