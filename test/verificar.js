$("#registrar-pedido").addEventListener("submit", async (e) => {
  e.preventDefault();
  
  const rows = document.querySelectorAll("#detalle-pedido tr");
  if (rows.length === 0) {
    alert("Debes agregar al menos un producto antes de registrar el pedido.");
    return; // Detener el envío si no hay productos
  }

  if (confirm("Está seguro de guardar los datos?")) {
    let response01 = await getIdPedido(); // Obtener ID del pedido
    idpedido = response01.idpedido;
    
    if (idpedido == -1) {
      alert("No se guardaron los datos");
    } else {
      let response02 = await addDetallePedidos(idpedido); // Agregar detalles
      if (response02.id == -1) {
        showToast('Hubo un error al registrar el pedido', 'error', 'ERROR');
      } else {
        showToast('Pedido registrado con éxito', 'success', 'SUCCESS');
      }
    }
  }
});