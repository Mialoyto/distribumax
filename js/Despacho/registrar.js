document.addEventListener("DOMContentLoaded",()=>{
    function $(object = null ){return document.querySelector(object)}

    const buscarVehiculo =async()=> {
        const params = new  URLSearchParams();
        params.append('operation','searchVehiculo');
        params.append('item',$("#idvehiculo").value);
         
        const option ={
            method :'POST',
            body :params
        }
        try {
            const response = await fetch(`../../controller/vehiculo.controller.php`, option);
            return await response.json();
        } catch (e) {
            console.error(e);
        }
      //  console.log(data)
    }


    const mostrarResultados = async ()=> {
        const datalist =$("#datalistVehiculo");
        datalist.innerHTML='';
        const response = await buscarVehiculo();

        if(response.length > 0){
            response.forEach(element => {
                const option =document.createElement('option');
                option.textContent=`${element.marca_vehiculo}-${element.modelo}-${element.placa}`;
                //option.innerHTML=`${element.modelo}`;
                option.value=`${element.idvehiculo}`;
                datalist.appendChild(option);
            });
            datalist.style.display='block';
        }else{
            datalist.style.display='none';
        }
    }

    $("#idvehiculo").addEventListener('input',async()=>{
        const idvehiculo =$("#idvehiculo").value;
        if(idvehiculo){}
        await mostrarResultados();
    })
})