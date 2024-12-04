document.addEventListener("DOMContentLoaded", () => {

    async function mostrarNotificaciones() {
        try {
            const res = await fetch('../controller/notificar.controller.php?operation=getAll');
            const data = await res.json();
            console.log(data);

            const notificationMenu = document.getElementById('notificationMenu');
            const notificationCount = document.getElementById('notificationCount');

            // Limpiar las notificaciones actuales
            notificationMenu.innerHTML = '';

            // Si hay notificaciones, las mostramos
            if (data.length > 0) {
                notificationCount.textContent = data.length; // Actualizar el contador de notificaciones
                data.forEach(notificacion => {
                    const item = document.createElement('li');
                    item.classList.add('dropdown-item', 'd-flex', 'align-items-center');

                    item.innerHTML = `
                        <div class="dropdown-list-image me-3">
                            <div class="status-indicator bg-success"></div>
                        </div>
                        <div>
                            <div class="text-truncate leido" data-id="${notificacion.idnotificacion}">${notificacion.mensaje}</div>
                            <div class="small text-gray-500">${notificacion.fecha}</div>
                        </div>
                    `;

                    notificationMenu.appendChild(item);
                });

                // Manejar el clic en las notificaciones
                const btnDesactivar = document.querySelectorAll(".leido");
                btnDesactivar.forEach((btn) => {
                    btn.addEventListener("click", async (e) => {
                        try {
                            e.preventDefault();
                            const idnotificacion = e.currentTarget.getAttribute("data-id");
                            await Leido(1, idnotificacion);  // Marca la notificación como leída
                        } catch (error) {
                            console.error("Error al marcar la notificación como leída:", error);
                        }
                    });
                });

            } else {
                notificationCount.textContent = 0;
                notificationMenu.innerHTML = '<li><a class="dropdown-item text-center" href="#">No hay notificaciones</a></li>';
            }
        } catch (error) {
            console.log(error);
        }
    }

    // Llamada para cargar las notificaciones cuando la página se carga
    mostrarNotificaciones();

    async function Leido(estado, idnotificacion) {
        const params = new FormData();
        params.append('operation', 'leido');
        params.append('leido', estado);
        params.append('idnotificacion', idnotificacion);
        try {
            const res = await fetch('../controller/notificar.controller.php', {
                method: 'POST',
                body: params
            });
            const data = await res.json();
            console.log(data);
        } catch (error) {
            console.log(error);
        }
    }

});
