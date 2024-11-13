document.addEventListener("DOMContentLoaded", function() {
    function $(selector) { return document.querySelector(selector); }
    let dtempresas;

    async function CargarDatosEmpresas() {
        const TablaEmpresas = $("#table-empresas tbody");

        try {
            const response = await fetch(`../../controller/empresa.controller.php?operation=getAll`);
            if (!response.ok) {
                throw new Error('Error en la respuesta de la API');
            }
            const data = await response.json();

            // Verificar que el dato contenga una lista
            if (!Array.isArray(data)) {
                throw new Error('Los datos no son un arreglo');
            }

            TablaEmpresas.innerHTML = ''; // Limpiar tabla
            data.forEach(element => {
                const row = document.createElement('tr');

                row.innerHTML = `
                    <td>${element.razonsocial || 'N/A'}</td>
                    <td class="text-start">${element.direccion || 'N/A'}</td>
                    <td>${element.email || 'N/A'}</td>
                    <td>${element.telefono || 'N/A'}</td>
                    <td>
                        <a href="#" class="btn btn-warning" onclick="editEmpresa(${element.idempresaruc})" aria-label="Editar empresa">
                            <i class="bi bi-pencil-fill"></i>
                        </a>
                        <a href="#" class="btn btn-danger" onclick="deleteEmpresa(${element.idempresaruc})" aria-label="Eliminar empresa">
                            <i class="bi bi-trash-fill"></i>
                        </a>
                    </td>
                `;
                TablaEmpresas.appendChild(row);
            });

            if (dtempresas) {
                dtempresas.destroy();
            }
            RenderDatatableEmpresas();
        } catch (error) {
            console.error('Error al cargar los datos de las empresas:', error);
            alert('Ocurrió un error al cargar los datos de las empresas.');
        }
    }

    function RenderDatatableEmpresas() {
        dtempresas = new DataTable("#table-empresas", {
            columnDefs: [
                { width: "15%", targets: 0 }, 
                { width: "15%", targets: 1 }, 
                { width: "25%", targets: 2 },
                { width: "25%", targets: 3 },
                { width: "20%", targets: 4 }
            ],
            language: {
                "sEmptyTable": "No hay datos disponibles en la tabla",
                "info": "",
                "sInfoFiltered": "(filtrado de _MAX_ entradas en total)",
                "sLengthMenu": "Filtrar: _MENU_",
                "sLoadingRecords": "Cargando...",
                "sProcessing": "Procesando...",
                "sSearch": "Buscar:",
                "sZeroRecords": "No se encontraron resultados",
                "oPaginate": {
                    "sFirst": "Primero",
                    "sLast": "Último",
                    "sNext": "Siguiente",
                    "sPrevious": "Anterior"
                },
                "oAria": {
                    "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
                    "sSortDescending": ": Activar para ordenar la columna de manera descendente"
                }
            }
        });
    }

    // Función para abrir el modal y cargar los datos de la empresa para edición
    window.editEmpresa = function(idempresaruc) {
        fetch(`../../controller/empresa.controller.php?operation=getByID`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ idempresaruc })
        })
            .then(response => response.json())
            .then(data => {
                $("#editEmpresaId").value = data.idempresaruc;
                $("#editEmpresaRazonSocial").value = data.razonsocial;
                $("#editEmpresaDireccion").value = data.direccion;
                $("#editEmpresaEmail").value = data.email;
                $("#editEmpresaTelefono").value = data.telefono;

                // Abrir el modal de edición
                new bootstrap.Modal(document.getElementById('editEmpresaModal')).show();
            })
            .catch(error => console.error("Error al cargar la empresa:", error));
    };

    // Manejar la actualización de la empresa
    $("#editEmpresaForm").addEventListener("submit", function(event) {
        event.preventDefault();
        
        const formData = new FormData(this);
        formData.append("operation", "upEmpresa");

        fetch('../../controller/empresa.controller.php', {
            method: "POST",
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert("Empresa actualizada correctamente");
                CargarDatosEmpresas();
                bootstrap.Modal.getInstance(document.getElementById('editEmpresaModal')).hide();
            } else {
                alert("Error al actualizar la empresa");
            }
        })
        .catch(error => console.error("Error al actualizar la empresa:", error));
    });

    // Función para eliminar la empresa
    window.deleteEmpresa = function(idempresaruc) {
        if (confirm("¿Estás seguro de eliminar esta empresa?")) {
            fetch(`../../controller/empresa.controller.php?operation=delete&idempresaruc=${idempresaruc}`, {
                method: "POST"
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert("Empresa eliminada correctamente");
                    CargarDatosEmpresas();
                } else {
                    alert("Error al eliminar la empresa");
                }
            })
            .catch(error => console.error("Error al eliminar la empresa:", error));
        }
    };

    CargarDatosEmpresas();
});
