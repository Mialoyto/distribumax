async function updateEstado(id,status) {
    const params = new FormData();
    params.append('operation','UpdateEstadoPedido');
    params.append('idpedido',id);
    params.append('estado',status);

    try{
        const response = await fetch(`../../controller/pedido.controller.php`,{
            method : 'POST',
            body   : params
        });
    
        const data = await response.json();
        console.log(data);
        return data;
    }catch(error){
        console.log("error al actualizar el pedido",error);
    }
}