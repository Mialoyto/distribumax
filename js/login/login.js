document.addEventListener("DOMContentLoaded", () => {
  document.querySelector("#form-login").addEventListener("submit", (event) => {
      event.preventDefault();
      // Datos a enviar
      const fomrData = new FormData();
      fomrData.append("operation", "login");
      fomrData.append("nombre_usuario", document.querySelector("#nombre_usuario").value);
      fomrData.append("password_usuario", document.querySelector("#inputPassword").value);

      fetch(`controller/usuario.controller.php`,{
          method: 'POST',
          body:fomrData
      })
          .then(response => response.json())
          .then(data => {
              
            //   console.log(data);
            //   alert(data.status);
            //   alert("revisar json");
              if (!data.acceso) {
                  console.log(data);
                  // alert(data.status);
                //   alert("Usuario o contraseña incorrectos");
              } else {
                alert("Bienvenido");
                  console.log(data);
                  window.location.href = `./dashboard.php`;
              }
          });
  });
});