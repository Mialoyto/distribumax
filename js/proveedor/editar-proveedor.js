//FUNCION PARA OBTENER EL PROVEEDOR POR ID
async function getProveedor(id) {
  const params = new URLSearchParams();
  params.append("operation", "getProveedor");
  params.append("idproveedor", id);

  try{
    const response = await fetch(`../../controller/proveedor.controller.php?${params}`);
    const data = await response.json();
    console.log(data);
    return data;
  } catch(e){
    console.error("Error al obtener el proveedor por ID: ", e);
  }
}
//FUNCION PARA CARGAR LOS DATOS Y ENVIARLO A LA BASE DE DATOS
async function updateProveedor(idproveedor, idempresa, proveedor, contacto_principal, telefono_contacto, direccion, email) {
  const params = new URLSearchParams();
  params.append("operation", "updateProveedor");
  params.append("idproveedor", idproveedor);
  params.append("idempresa", idempresa);
  params.append("proveedor", proveedor);
  params.append("contacto_principal", contacto_principal);
  params.append("telefono_contacto", telefono_contacto);
  params.append("direccion", direccion);
  params.append("email", email);

  try{
    const response = await fetch(`../../controller/proveedor.controller.php?${params}`);
    const data = await response.json();
    return data;
  } catch(error){
    console.error("Error al actualizar el proveedor: ", error);
  }
}

async function formUpdateProveedor(idproveedor, idempresa, proveedor, contacto_principal,telefono_contacto,direccion, email, inputCorreo) {
  const danger = document.querySelectorAll(".text-danger");
  danger.forEach((element) =>{
    element.remove();
  });
  const invalid = document.querySelectorAll(".is-invalid");
  invalid.forEach((element) =>{
    element.classList.remove("is-invalid");
  });
  if(await showConfirm("¿Desea actualizar el proveedor?", "PROVEEDORES")){
    const data = await updateProveedor(
      idproveedor,
      idempresa,
      proveedor,
      contacto_principal,
      telefono_contacto,
      direccion,
      email
    );
    console.log(data);

    const STATUS = data[0].estado;
    if(!STATUS){
      inputCorreo.classList.add("is-invalid");
      const span = document.createElement("span");
      span.classList.add("text-danger");
      span.innerHTML = `${data[0].mensaje}`;
      inputCorreo.insertAdjacentElement("afterend", span);
    }else{
      showToast(`${data[0].mensaje}`, "success", "SUCCESS");
    }
  }else{
    return;
  }
}