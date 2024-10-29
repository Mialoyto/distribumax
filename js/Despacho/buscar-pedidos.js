document.addEventListener("DOMContentLoaded",()=>{
 function $(object = null){return document.querySelector(object)}

  let venta;
 async function getVenta(venta) {
    const params = new  URLSearchParams();
    params.append('operation','buscarventa');
    params.append('item',venta);

    const response = await fetch(`../../controller/ventas.controller.php?${params}`)
    const data = await response.json();
    console.log(data)
 }
 getVenta();

 async function renderDatos() {
    
 }
})