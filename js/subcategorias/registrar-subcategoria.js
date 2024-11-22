document.addEventListener("DOMContentLoaded", () => {

  const selectCategoria = document.querySelector("#select-categoria");
  const formAddSubcategoria = document.querySelector("#addSubcategoria");
  let subcategoria;


  async function AddSubcategorias() {
    const inputSubcategoria = document.querySelectorAll(".inputSubcategoria");
    const idCategoria = selectCategoria.value;
    const subcategorias = [];
    const inputSubcategorias = inputSubcategoria

    inputSubcategorias.forEach((item) => {
      subcategoria = item.value.trim();
      subcategorias.push(subcategoria);
    });
    console.log(subcategorias);

    const params = new FormData();
    params.append("operation", "addSubcategoria");
    params.append("idcategoria", idCategoria);
    subcategorias.forEach((subcategoria, index) => {
      params.append(`subcategorias[${index}][subcategoria]`, subcategoria);
    });
    params.forEach((value, key) => {
      console.log(key, value);
    });

    const options = {
      method: "POST",
      body: params,
    };

    try {
      const response = await fetch(`../../controller/subcategoria.controller.php`, options);
      const data = await response.json();
      console.log(data);
      return data;
    } catch (error) {
      console.error(error);

    }
  }

  function duplicados(inputSubcategoria) {
    const valores = [];
    let duplicado = false;

    inputSubcategoria.forEach((item) => {
      const valor = item.value.trim().toUpperCase();
      if (valores.includes(valor)) {
        item.classList.add("is-invalid");
        duplicado = true;
      }
      valores.push(valor);
    });
    return duplicado;
  }

  function verificarInput() {
    const inputSubcategoria = document.querySelectorAll(".inputSubcategoria");
    if (inputSubcategoria.length === 0) {
      showToast("Agregue al menos una subcategoría", "info");
      return false;
    }
    return true;

  }

  async function validar() {
    const inputSubcategoria = document.querySelectorAll(".inputSubcategoria");
    let valid = true;

    inputSubcategoria.forEach(item => {
      item.classList.remove("is-invalid");
    })

    inputSubcategoria.forEach((item) => {
      if (item.value.trim() === "") {
        item.classList.add("is-invalid");
        valid = false;
      }
    });

    if (duplicados(inputSubcategoria)) {
      showToast("Las subcategorías no pueden estar duplicadas", "info");
      valid = false;
    }

    if (!verificarInput()) {
      return false;
    }
    return valid;
  }

  formAddSubcategoria.addEventListener("submit", async (e) => {
    e.preventDefault();
    const data = await validar();
    console.log(data);
    if (!await validar()) {
      return;
    }

    if (await showConfirm("¿Desea registrar la subcategoría?", "Subcategoría")) {
      const data = await AddSubcategorias();
      console.log(data);
    }

  });

});
