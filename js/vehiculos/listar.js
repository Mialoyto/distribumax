document.addEventListener("DOMContentLoaded",()=>{
    function $( object= null){ return document.querySelector(object)}

    let dtvehiculo;

    async function CargarDatos() {
        const dtvehiculos=$("#table-vehiculos tbody");
        const reponse = await fetch(`../../controller/vehiculo.controller.php?operation=getAll`)
        const data = await  reponse.json();
        console.log(data)
        dtvehiculos.innerHTML='';
        if(data.length>0){
            data.forEach(element => {
                dtvehiculos.innerHTML+=
                `
                <tr>
              
                <td>${element.datos}</td>
                <td>${element.marca_vehiculo}</td>
                <td>${element.modelo}</td>
                <td>${element.placa}</td>
                <td>${element.capacidad}</td>
                <td>${element.condicion}</td>
                <td>
                <a hrf='#' class='btn btn-warning'>Editar</a>
                <a hrf='#' class='btn btn-danger'>Delete</a>
                </td>
                </tr>
                `
            });
        }
        if(dtvehiculo){
            dtvehiculo.destroy();
        }
        RenderTable();
    }
  

    async function RenderTable() {
        dtvehiculo= new DataTable("#table-vehiculos",{
            language: {
                lengthMenu: "Mostrar _MENU_ registros por página",
                zeroRecords: "No se encontraron registros",
                info: false,
                infoEmpty: false,
                //infoFiltered: "(filtrado de _MAX_ registros totales)",
                search: "Buscar:",
                
            },
            info:false,
            ordering:  false
        })
    }

    async function UpdateVehiculo(idvehiculo) {
        
    }

    CargarDatos();
})