document.addEventListener("DOMContentLoaded", () => {
    const optionDis = document.querySelector("#iddistrito");
    const optionDis2=document.querySelector("#iddistrito-update")
    const formempresa = document.querySelector("#form-registrar-empresa");
    const formactualizar = document.querySelector("#form-actualizar-empresa");
    const ruc = document.querySelector("#idempresaruc");
    const razon = document.querySelector("#razonsocial");
    const direccion = document.querySelector("#direccion");
    const email = document.querySelector("#email");
    const telefono = document.querySelector("#telefono");
    const estado = document.querySelector("#estado");
    const contentable = document.querySelector("#table-empresas tbody");
    
     distrito(optionDis);
     distrito(optionDis2);
    // Obtener distritos para el select
    function distrito(iddistrito){
        fetch(`../../controller/distrito.controller.php?operation=getAll`)
        .then(response => response.json())
        .then(data => {
            data.forEach(element => {
                const tagOption = document.createElement('option');
                tagOption.value = element.iddistrito;
                tagOption.innerText = element.distrito;
                iddistrito.appendChild(tagOption);
            });
        })
        .catch(e => {
            console.error(e);
        });
    }
   

    // Obtener empresas y agregar botones de actualizar y cambiar estado
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
                        <td>${row.direccion}</td>
                        <td>${row.email}</td>
                        <td>${row.telefono}</td>
                        <td>${row.distrito}</td>
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
                const btnEstado = document.querySelectorAll(".btn-inactive");

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

    // Función para cambiar el estado de la empresa
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
                document.querySelector("#razonsocial-update").value = data.razonsocial;
                document.querySelector("#direccion-update").value = data.direccion;
                document.querySelector("#email-update").value = data.email;
                document.querySelector("#telefono-update").value = data.telefono;
            })
            .catch(e => {
                console.error(e);
            });
    }
    
    function cargarDatosEmpresa(idEmpresa) {
            
        const params = new FormData();
        params.append('operation', 'getByID');
        params.append('idempresaruc',idEmpresa );
         console.log(idEmpresa);
        const options = {
            method: 'POST',
            body: params
        };
          
        fetch(`../../controller/empresa.controller.php`, options)
            .then(response => response.json())
            .then(data => {
                console.log(data);

                document.querySelector("#razonsocial-update").value=data.razonsocial;
                document.querySelector("#direccion-update").value = data.direccion;
                document.querySelector("#email-update").value = data.email;
                document.querySelector("#telefono-update").value = data.telefono;
                console.log(razonsocial);
                
            })
            .catch(e => {
                console.error(e);
            });
    };
    // Registrar empresa
    formempresa.addEventListener("submit", (event) => {
        event.preventDefault(); // Evitar el comportamiento por defecto de recargar la página

        const params = new FormData();
        params.append('operation', 'add');
        params.append('idempresaruc', ruc.value);
        params.append('iddistrito', optionDis.value);
        params.append('razonsocial', razon.value);
        params.append('direccion', direccion.value);
        params.append('email', email.value);
        params.append('telefono', telefono.value);

        const options = {
            method: 'POST',
            body: params
        };

        fetch(`../../controller/empresa.controller.php`, options)
            .then(response => response.json())
            .then(datos => {
                if (confirm("¿Desea guardar los datos?")) {
                    location.reload(); // Recargar la página
                }
            })
            .catch(e => {
                console.error(e);
            });
    });

    // Actualizar empresa
    formactualizar.addEventListener("submit", (event) => {
        event.preventDefault(); // Prevenir el comportamiento por defecto del formulario

        const params = new FormData(formactualizar);
        params.append('operation', 'upEmpresa'); // Cambia la operación a 'update'

        const options = {
            method: 'POST',
            body: params
        };

        fetch(`../../controller/empresa.controller.php`, options)
            .then(response => response.json())
            .then(datos => {
                alert("Empresa actualizada correctamente.");
                location.reload(); // Recargar la página para reflejar los cambios
            })
            .catch(e => {
                console.error(e);
            });
    });
     

});