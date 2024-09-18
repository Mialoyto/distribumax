document.addEventListener("DOMContentLoaded", () => {
    const ruc = document.querySelector("#idempresaruc");
    const formactualizar = document.querySelector("#form-actualizar-empresa");
    const contentable = document.querySelector("#table-empresas tbody");
    //const btnactualizar=document.querySelector("#btnactualizar");
    
    const iddistrito = document.querySelector("#searchDistrito");
    const datalist   = document.querySelector("#datalistDistrito");
    (() => {
        fetch(`../../controller/empresa.controller.php?operation=getAll`)
            .then(response => response.json())
            .then(datos => {
                datos.forEach(row => {
                   // Obtener el estado actual de la empresa
                    contentable.innerHTML += `
                    <tr>
                        <td>${row.idempresaruc}</td>
                        <td>${row.razonsocial}</td>
                        <td>${row.distrito}</td>
                        <td>${row.direccion}</td>
                        <td>${row.email}</td>
                        <td>${row.telefono}</td>
            
                        <td class="text-center">
                            <button class="btn btn-warning btn-update" 
                            data-id="${row.idempresaruc}" 
                            data-bs-toggle="modal" 
                            data-bs-target="#actualizarEmpresaModal">
                                <i class="fa fa-edit" style="pointer-events: none;"></i>
                            </button>

                            <button class="btn btn-danger btn-inactive" 
                            data-id="${row.idempresaruc}" 
                            >
                                <i class="fa fa-times" style="pointer-events: none;"></i>
                            </button>
                        </td>
                    </tr>
                    `
                    ;
                });

                // Asignar eventos a los botones de actualizar
                const btnsActualizar = document.querySelectorAll(".btn-update");
                

                btnsActualizar.forEach(btn => {
                    btn.addEventListener("click", (event) => {
                        const empresaId = event.target.getAttribute('data-id');
                        cargarDatosEmpresa(empresaId); // Llamada a la función con el ID de la empresa
                    });
                });

                // Asignar eventos a los botones de eliminar (cambiar estado)
         //      btnEstado.forEach(element => {
          //           element.addEventListener("click", (event) => {
          //               const idempresa = event.target.getAttribute('data-id');
          //               const estadoActual = event.target.getAttribute('data-estado');
          //                
          //               var nuevoEstado = (estadoActual === "1") ? "0" : "1"; // Alternar entre 0 y 1
          //               actualizarEstado(idempresa,nuevoEstado);
           //              if(estadoActual==0){

           //                  estadoActual==1
                            
            //             }else{
             //                estadoActual==0;
            //              
             //            }
             //        });
            //     });
            })
            .catch(e => {
                console.error(e);
            });
    })();
    function actualizarEstado(idempresa, nuevoEstado) {
        const params = new FormData();
        params.append('operation', 'upEstado');
        params.append('estado', nuevoEstado); // Enviamos el nuevo estado
        params.append('idempresaruc', idempresa);

        const options = {
            method: 'POST',
            body: params
        };

        fetch(`../../controller/empresa.controller.php`, options)
            .then(response => response.json())
            .then(data => {
                alert("Estado de la empresa actualizado correctamente.");
                location.reload(); // Recargar la página para reflejar los cambios
            })
            .catch(e => {
                console.error(e);
            });
    }
    
    function cargarDatosEmpresa(idEmpresa) {
        const params = new FormData();
        params.append('operation', 'getByID');
        params.append('idempresaruc', idEmpresa );

        const options = {
            method: 'POST',
            body: params
        };
          
        fetch(`../../controller/empresa.controller.php`, options)
            .then(response => response.json())
            .then(data => {
                document.querySelector("#idempresaruc-update").value=data.idempresaruc;
                document.querySelector("#razonsocial-update").value = data.razonsocial;
                document.querySelector("#direccion-update").value = data.direccion;
                document.querySelector("#email-update").value = data.email;
                document.querySelector("#telefono-update").value = data.telefono;
                document.querySelector("#searchDistrito").value = data.distrito;
            })
            .catch(e => {
                console.error(e);
            });
    };
    
    let distrito='';
    if(iddistrito){
        iddistrito.addEventListener('input',event=>{
            distrito=event.target.value;
            mostraResultados();
        })
    };
    const searchDistrito = async ()=>{
        let searchData = new FormData();
        searchData.append('operation','searchDistrito');
        searchData.append('distrito',distrito);
        const option={
            method : 'POST',
            body:searchData
        }
        try{
            const response= await fetch(`../../controller/distrito.controller.php`,option)
            return response.json();
        }catch(e){
            console.error(e);
        }
    };

    const mostraResultados =()=>{
        searchDistrito()
        .then(response=>{
            datalist.innerHTML='';
            response.forEach(item => {
                const option = document.createElement('option');
                option.setAttribute('data-id', item.iddistrito)
                option.innerText=item.distrito;
                datalist.appendChild(option);
            })
            console.log(response);
        })
    };
    let selectedId;
    iddistrito.addEventListener('change',event=>{
        const selectedDistrito =event.target.value;
        const options =datalist.children;
        
        for(let i =0; i<options.length;i++){
            if(options[i].value===selectedDistrito){
                selectedId=options[i].getAttribute('data-id');
                console.log(selectedId);
                break;
            }
        }
    });
   
    
    

    // Actualizar empresa
    formactualizar.addEventListener("submit", (event) => {
        event.preventDefault(); // Prevenir el comportamiento por defecto del formulario

        const params = new FormData();
        params.append('operation', 'upEmpresa'); // Cambia la operación a 'update'
        params.append('iddistrito',document.querySelector("#searchDistrito").value);
        params.append('razonsocial',document.querySelector("#razonsocial-update").value);
        params.append('direccion',document.querySelector("#direccion-update").value);
        params.append('email',document.querySelector("#email-update").value);
        params.append('telefono',document.querySelector("#telefono-update").value);
        params.append('idempresaruc',document.querySelector("#idempresaruc-update").value);

        const options = {
            method: 'POST',
            body: params
        };

        fetch(`../../controller/empresa.controller.php`, options)
            .then(response => response.text())
            .then(datos => {
                alert("Empresa actualizada correctamente.");
                location.reload(); // Recargar la página para reflejar los cambios
            })
            .catch(e => {
                console.error(e);
            });
    });

    
     

});