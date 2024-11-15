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
    }

    initializeMarcasTable();
});