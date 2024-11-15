document.addEventListener("DOMContentLoaded", function () {
    const $ = (selector) => document.querySelector(selector);
    let marcasTable = null;

    const languageConfig = {
        // ... configuración anterior ...
    };

    function initializeMarcasTable() {
        marcasTable = new DataTable("#table-marcas", {
            ajax: {
                url: "../../controller/marcas.ssp.php",
                type: "POST",
            },
        });

        // Manejador de eventos...
        document.querySelector('#table-marcas tbody').addEventListener('click', function (e) {
            // ... código anterior de eventos ...
        });
    }

    initializeMarcasTable();
});