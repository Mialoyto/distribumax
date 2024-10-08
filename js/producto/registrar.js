document.addEventListener("DOMContentLoaded", () => {
  const optionEmpresa = $("#idmarca");
  const optionsub = $("#idsubcategoria");

  function $(object = null) {
    return document.querySelector(object);
  }


  async function getCategorias() {
    const params = new URLSearchParams();
    params.append('operation', 'getAll');
    try {
      const response = await fetch(`../../controller/categoria.controller.php?${params}`);
      const categorias = await response.json();
      console.log(categorias);
      categorias.forEach(element => {
        const tagOption = document.createElement('option');
        tagOption.value = element.idcategoria;
        tagOption.innerText = element.categoria;
        $("#idcategoria").appendChild(tagOption);
      });

    } catch (e) {
      console.error(e);
    }
  }
  getCategorias();
  $("#idcategoria").addEventListener("change", async () => {

  });

  // Función asincrónica para obtener marcas y subcategorías
  async function obtenerMarcasYSubcategorias() {
    try {
      // Obtener marcas
      const responseMarcas = await fetch(`../../controller/marca.controller.php?operation=getAll`);
      const marcas = await responseMarcas.json();
      marcas.forEach(element => {
        const tagOption = document.createElement('option');
        tagOption.value = element.idmarca;
        tagOption.innerText = element.marca;
        optionEmpresa.appendChild(tagOption);
      });

      // Obtener subcategorías
      const responseSubcategorias = await fetch(`../../controller/subcategoria.controller.php?operation=getAll`);
      const subcategorias = await responseSubcategorias.json();
      console.log(subcategorias);
      subcategorias.forEach(element => {
        const tagOption = document.createElement('option');
        tagOption.value = element.idsubcategoria;
        tagOption.innerText = element.subcategoria;
        optionsub.appendChild(tagOption);
      });
    } catch (e) {
      console.error(e);
    }
  }

  // Llamar a la función para obtener marcas y subcategorías
  obtenerMarcasYSubcategorias();

  async function registrarproducto() {
    const params = new FormData();
    params.append('operation', 'addProducto');
    params.append('idmarca', optionEmpresa.value);
    params.append('idsubcategoria', optionsub.value);
    params.append('nombreproducto', $("#nombreproducto").value);
    params.append('descripcion', $("#descripcion").value);
    params.append('codigo', $("#codigo").value);
    params.append('preciounitario', $("#preciounitario").value);

    const options = {
      method: 'POST',
      body: params
    };

    const response = await fetch(`../../controller/producto.controller.php`, options);
    return response.json()
    // .catch(e => { console.error(e) });
  }

  $("#formRegistrarProducto").addEventListener("submit", async (event) => {
    event.preventDefault();
    const resultado = await registrarproducto();

    if (resultado) {
      alert("Registro exitoso");
    }
  });
});
