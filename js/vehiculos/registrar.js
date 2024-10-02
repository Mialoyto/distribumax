document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) {
        return document.querySelector(object);
    };


    const buscarConductor = async () => {
        const params = new URLSearchParams();
        params.append('operation', 'searchConductor');
        params.append('item', $("#idusuario").value);
        const option ={
            method : 'POST',
            body:params
        }
        try {
            const response = await fetch(`../../controller/vehiculo.controller.php`,option);
            return await response.json();
            
        } catch (e) {
            console.error(e);
        }
    };
    
    const mostraResultados = async () => {
        const datalist = $("#datalistConductor");
        datalist.innerHTML = '';
        const response = await buscarConductor();
        
        if (response.length > 0) {
            response.forEach(item => {
                const option = document.createElement('option');
                option.value = ` ${item.nombres} ${item.apellidos} ${item.idusuario}`; // Asegúrate de usar las propiedades correctas
                datalist.appendChild(option);
              
            });
            datalist.style.display = 'block';
        } else {
            datalist.style.display = 'none';
        }
    };
    const ObtenerIdusuario =async(idusuario)=>{
        const params = new URLSearchParams();
        params.append('operation','getById_usuarioVe');
        params.append('idusuarioVe',idusuario);
        const option ={
            method : 'POST',
            body:params
        }
       const response =await fetch(`../../controller/vehiculo.controller.php`,option);
       const data = await response.json()
       console.log(await data)
    }
    $("#idusuario").addEventListener('input', async () => {
        const idusuario = $("#idusuario").value;
        if (idusuario) {
            await mostraResultados();
            await ObtenerIdusuario(idusuario);
            console.log(idusuario)
        }
    });
     
    async function registrarVehiculo() {
      const params = new FormData();
      params.append('operation','addVehiculo');
      params.append('idususario',$("#idusuario").value);
      params.append('marca_vehiculo',$("#marca_vehiculo").value);
      params.append('modelo',$("#modelo").value);
      params.append('placa',$("#placa").value);
      params.append('capacidad',$("#capacidad").value);
      params.append('condicion',$("#condicion").value);

      const option ={
        method : 'POST',
        body : params
      }

      const response = await fetch (`../../controller/vehiculo.controller.php`,option)
      const data = await response.json()
      console.log(data);
    };
     
    $("#form-registrar-Vehiculo").addEventListener("submit", async(event)=>{
        event.preventDefault();
        const resultado = await registrarVehiculo();
        if(resultado){
            alert("Registro exitoso")
        }
        
    })
    // Si deseas buscar al cargar la página, puedes dejar esto, de lo contrario puedes eliminarlo.
    // buscarConductor();
});
