document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) { return document.querySelector(object) }


  async function Login() {
    const fomrData = new FormData();
    fomrData.append("operation", "login");
    fomrData.append("nombre_usuario", $("#nombre_usuario").value)
    fomrData.append("password_usuario", $("#inputPassword").value);
    const response = await fetch(`controller/usuario.controller.php`, {
      method: 'POST',
      body: fomrData
    });
    const data = await response.json();
    console.log(data)
    return data;
  }



  $("#form-login").addEventListener("submit", async (event) => {
    event.preventDefault();
    const data = await Login();
    if (!data.estado) {
      showToast(data.status, "error", "ERROR");
    } else {
      console.log(data);
      window.location.href = `http://localhost/distribumax/views/home/`;
    }
  });
});