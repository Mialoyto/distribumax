document.addEventListener("DOMContentLoaded", () => {
    const contentable = document.querySelector("#table-proveedores tbody");
    
    // Cargar proveedores
    (() => {
        fetch(`../../controller/proveedor.controller.php?operation=getAll`)
            .then(response => response.json())
            .then(datos => {
                datos.forEach(row => {
                    contentable.innerHTML += `
                    <tr>
                        <td>${row.razonsocial}</td>
                        <td>${row.proveedor}</td>
                        <td>${row.contacto_principal}</td>
                        <td>${row.telefono_contacto}</td>
                        <td>${row.email}</td>
                        <td>${row.direccion}</td>
                        <td class="text-center">
                        <button class="btn btn-warning btn-update" 
                                data-id="${row.idproveedor}" 
                                data-bs-toggle="modal" 
                                data-bs-target="#actualizarProveedorModal">
                            <i class="fa fa-edit" style="pointer-events: none;"></i>
                        </button>
                        </td>
                    </tr>
                    `;
                });
            })
            .catch(e => {
                console.error(e);
            });
    })();

    // Función para cargar datos en el modal
    async function cargarDatosActualizar(idproveedor) {
        const params = new URLSearchParams();
        params.append('operation', 'getByID');
        params.append('idproveedor', idproveedor);

        const options = {
            method: 'POST',
            body: params
        };

        try {
            const response = await fetch(`../../controller/proveedor.controller.php`, options);
            const data = await response.json();

            // Llenar el modal con los datos del proveedor
            document.querySelector("#idproveedor_update").value = data.idproveedor;
            document.querySelector("#idempresa_update").value = data.idempresa;
            document.querySelector("#proveedor_update").value = data.proveedor;
            document.querySelector("#contacto_principal_update").value = data.contacto_principal;
            document.querySelector("#telefono_contacto_update").value = data.telefono_contacto;
            document.querySelector("#direccion_update").value = data.direccion;
            document.querySelector("#email_update").value = data.email;
        } catch (e) {
            console.error(e);
        }
    }

    // Evento para abrir el modal y cargar datos
    contentable.addEventListener("click", (event) => {
        if (event.target.closest('.btn-update')) {
            const idproveedor = event.target.closest('.btn-update').getAttribute('data-id');
            cargarDatosActualizar(idproveedor);
        }
    });
});
