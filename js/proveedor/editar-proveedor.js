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

// FUNCION PARA CARGAR LOS DATOS Y ENVIARLO A LA BASE DE DATOS
async function updateProveedor(id, idempresa, proveedor, contacto_principal, telefono_contacto, correo, direccion) {
  const params = new URLSearchParams();
  params.append("operation", "updateProveedor");
  params.append("idproveedor", id);
  params.append("idempresa", idempresa);
  params.append("proveedor", proveedor);
  params.append("contacto_principal", contacto_principal);
  params.append("telefono_contacto", telefono_contacto);
  params.append("correo", correo);
  params.append("direccion", direccion);

  try{
    const response = await fetch(`../../controller/proveedor.controller.php?${params}`);
    const data = await response.json();
    return data;
  } catch(error){
    console.error("Error al actualizar el proveedor: ", error);
  }
}

//FUNCION PARA ACTUALIZAR EL PROVEEDOR CON VALIDACIONES
async function formUpdateProveedor(id, idempresa, proveedor, contacto_principal, telefono_contacto, correo, direccion) {
  const danger = document.querySelector(".text-danger");
  danger.forEach(element => {
    element.classList.remove("is-invalid");
  });
  if(await showConfirm("¿Desea actualizar el proveedor?", "PROVEEDORES")){
    const data = await updateProveedor(
      id,
      idempresa,
      proveedor,
      contacto_principal,
      telefono_contacto,
      correo,
      direccion
    );

    console.log(data);
    //VALIDAMOS SI LA ACTUALIZACIÓN FUE EXITOSA
    const STATUS = data[0].estado;
    if(!STATUS){
      const span = document.createElement("span");
      span.classList.add("text-danger");
      span.innerHTML = `${data[0].mensaje}`;
    }else{
      showToast(`${data[0].mensaje}`, "success", "SUCCESS");
    }
  } else{
    return;
  }
}