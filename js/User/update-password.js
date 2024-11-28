document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) { return document.querySelector(object); }

    // Función para actualizar la contraseña
    async function UpdatePassword() {
        const params = new FormData();
        params.append('operation', 'updatepassword');
        params.append('idusuario', $("#idusuario").value);
        params.append('password_usuario', $("#password_usuario").value);

        try {
            const response = await fetch(`../../controller/usuario.controller.php`, {
                method: 'POST',
                body: params
            });
            const data = await response.json();
            console.log(data);
            return data;
        } catch (error) {
            console.log('No es posible actualizar la contraseña', error);
        }
    }

    // Función para confirmar la contraseña
    function ConfirmarContraseña() {
        let password_usuario = $("#password_usuario").value;
        let confir_password = $("#confir-password").value;

        // Validación de que las contraseñas coincidan
        if (password_usuario !== confir_password) {
            $("#confir-password").classList.add("is-invalid");
           // $("#password_usuario").classList.add("is-invalid");
        } else {
            $("#confir-password").classList.remove("is-invalid");
            $("#password_usuario").classList.remove("is-invalid");
             UpdatePassword();
        }
    }
   

    // Evento de submit
    $("#form-actualizar-contraseña").addEventListener("submit", async (event) => {
        event.preventDefault();

        // Confirmación de acción
        if (await showConfirm("¿Desea actualizar su contraseña?", "Usuario")) {
            
            ConfirmarContraseña();
            showToast("Contraseña actualizada!", "success", "SUCCESS");
            $("#form-actualizar-contraseña").reset();

        }else{
           
        }
    });

    // Evento para verificar las contraseñas en tiempo real mientras el usuario escribe
    $("#password_usuario").addEventListener("input",()=>{
    });

    $("#confir-password").addEventListener("input", ConfirmarContraseña);
});
