

document.addEventListener("DOMContentLoaded",()=>{

   const optionEmp = document.querySelector("#idempresaruc");
   const formproveedor =document.querySelector("#form-registrar-proveedor");
   const proveedor    =document.querySelector("#proveedor");
   const contacto  =document.querySelector("#contacto_principal");
   const telsecundario =document.querySelector("#telefono_contacto");
   const email         =document.querySelector("#email");
   const direccion     =document.querySelector("#direccion");
   const contentable =document.querySelector("#table-proveedores tbody");
    (() =>{
        fetch(`../../controller/empresa.controller.php?operation=getAll`)
            .then(response => response.json())
            .then(data =>{
                data.forEach(element => {
                    const tagOption = document.createElement('option');
                    tagOption.value = element.idempresaruc;
                    tagOption.innerText= element.razonsocial;
                    optionEmp.appendChild(tagOption);
                });
            })
            .catch(e =>{
                console.error(e);
            })
    })();

    (()=>{
        fetch(`../../controller/proveedor.controller.php?operation=getAll`)
        .then(response=>response.json())
        .then(datos=>{
            datos.forEach(row=>{
                contentable.innerHTML+=`
                <tr>
                    <td>${row.idempresa.razonsocial}</td>
                    <td>${row.proveedor}</td>
                    <td>${row.contacto_principal}</td>
                    <td>${row.telefono_contacto}</td>
                    <td>${row.email}</td>
                    <td>${row.direccion}</td>
           
                </tr>
                `
            });
        })
        .catch(e=>{
            console.error(e)
        })
    })();

    formproveedor.addEventListener("submit",(event)=>{
        const params = new FormData();
        params.append('operation','addProveedor');
        params.append('idempresa',optionEmp.value);
        params.append('proveedor',proveedor.value);
        params.append('contacto_principal',contacto.value);
        params.append('telefono_contacto',telsecundario.value);
        params.append('direccion',direccion.value);
        params.append('email',email.value);

        const options ={
            'method': 'POST',
            'body': params
        };

        fetch(`../../controller/proveedor.controller.php`,options)
        .then(response=>response.json())
        .then(datos=>{
            
                Swal.fire({
                    position: 'top-end',
                    icon: 'success',
                    title: 'Proveedor registrado correctamente',
                    showConfirmButton: false,
                    timer: 1000,
                    width: '300px',
                    heitgh:'10px'  // Establece el ancho de la alerta
                     // Reduce el padding interno
                   // Ajusta el tamaño de la imagen si usas una
                });
        })
        .catch(e=>{
            console.error(e)
        })
    });
    

})