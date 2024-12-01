document.addEventListener('DOMContentLoaded',()=>{


    function $(object = null) {return document.querySelector(object)}
    async function cargarclientes() {
          const params = new URLSearchParams();
          params.append('operation', 'activos');
        const response = await fetch(`../controller/cliente.controller.php?${params}`);
        const data = await response.json();
          $("#totalClientesActivos").textContent=data[0].cli_activos;
            console.log(data);
          
        return data;
    }
    cargarclientes();

    ( async()=>{
        try{
            const response = await fetch('../controller/pedido.controller.php?operation=pediosDay');
            const data = await response.json();
            $("#pendientes").textContent=data[0].pendientes;
            $("#enviados").textContent=data[0].enviados;
            $("#cancelados").textContent=data[0].cancelados;
            console.log(data);
        }catch(e){
            console.log(e);
        }
    })();

    (async()=>{
        try{
            const response = await fetch('../controller/lotes.controller.php?operation=Agotados_vencidos');
            const data = await response.json();
                const table = $("#table-body");
                table.innerHTML="";
                let classestado="";
                data.forEach(element => {

                    switch (element.estado) {
                        case 'Por vencer':
                            classestado="text-warning";
                           
                            break;
                        case 'Por agotarse':

                            classestado="text-info";
                            break;
                        case 'Agotado':
                            classestado="text-danger";
                            
                        break;
                        
                    }
                    table.innerHTML+=`
                    <tr>
                        <td>${element.nombreproducto}</td>
                        <td>${element.numlote}</td>
        
                        <td>${element.fecha_vencimiento}</td>
                         <td>${element.stockactual}</td>
                        <td><strong class="${classestado}">${element.estado}</strong></td>
                    </tr>
                    `;
                });
            console.log(data);
        }catch(e){
            console.log(e);
        }
    
   })();

   (async()=>{
    try{
        const response = await fetch('../controller/pedido.controller.php?operation=pedidosProvincia');
        const data = await response.json();
            const table = $("#pedidos-body");
            table.innerHTML="";
            data.forEach(element => {
                table.innerHTML+=`
                <tr>
                    <td>${element.distrito}</td>
                    <td>${element.provincia}</td>
                    <td>${element.total_pedidos}</td>
        
                </tr>
                `;
            });
        console.log(data);
    }catch(e){
        console.log(e);
    }
   })();
});