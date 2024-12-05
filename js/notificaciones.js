$(document).ready(function () {

    // Función para generar una notificación
    function GenerarNotificacion() {
        $.ajax({
            url: '../controller/notificar.controller.php',
            type: 'POST',
            data: { operation: 'generar' },
            dataType: 'json',
            success: function (response) {
                console.log(response);
                if (response) {
                    console.log('Notificación generada correctamente');
                    // Llamar a mostrar notificaciones para actualizar la lista
                    mostrarNotificaciones();
                } else {
                    console.error('Error al generar la notificación:', response);
                }
            },
            error: function (xhr, status, error) {
                console.error('Error en la solicitud AJAX:', error);
            }
        });
    }

    // Función para mostrar las notificaciones
    function mostrarNotificaciones() {
        $.ajax({
            url: '../controller/notificar.controller.php',
            type: 'GET',
            data: { operation: 'getAll' },
            dataType: 'json',
            success: function (data) {
                console.log(data);

                const $notificationMenu = $('#notificationMenu');
                const $notificationCount = $('#notificationCount');

                // Limpiar las notificaciones actuales
                $notificationMenu.empty();

                // Si hay notificaciones, las mostramos
                if (data.length > 0) {
                    $notificationCount.text(data.length); // Actualizar el contador de notificaciones
                    data.forEach(notificacion => {
                        const item = `
                            <li class="dropdown-item d-flex align-items-center">
                                <div class="dropdown-list-image me-3">
                                    <div class="status-indicator bg-success"></div>
                                </div>
                                <div>
                                    <div class="text-truncate leido" data-id="${notificacion.idnotificacion}">${notificacion.mensaje}</div>
                                    <div class="small text-gray-500">${notificacion.fecha}</div>
                                </div>
                            </li>
                        `;
                        $notificationMenu.append(item);
                    });

                    // Agregar eventos para marcar como leído
                    $('.leido').on('click', function (e) {
                        e.preventDefault();
                        const idnotificacion = $(this).data('id');
                        console.log('ID de notificación:', idnotificacion);
                        Leido(1, idnotificacion); // Marcar como leído
                    });
                } else {
                    $notificationCount.text(0);
                    $notificationMenu.html('<li><a class="dropdown-item text-center" href="#">No hay notificaciones</a></li>');
                }
            },
            error: function (xhr, status, error) {
                console.error('Error al obtener notificaciones:', error);
            }
        });
    }

    // Función para marcar una notificación como leída
    function Leido(estado, idnotificacion) {
 
        $.ajax({
            url: '../controller/notificar.controller.php',
            type: 'POST',
            data: { operation: 'leido', leido: estado, idnotificacion: idnotificacion },
            dataType: 'json',
            success: function (response) {
                console.log(response);
                if (response) {
                    console.log('Notificación marcada como leída');
                    // Actualizar las notificaciones después de marcar como leída
                    // mostrarNotificaciones();
                } else {
                    console.error('Error al marcar como leído:', response);
                }
            },
            error: function (xhr, status, error) {
                console.error('Error en la solicitud AJAX:', error);
            }
        });
    }

    // Llamar a generar notificación y mostrar notificaciones al cargar la página
    GenerarNotificacion();
    mostrarNotificaciones();
  
});
