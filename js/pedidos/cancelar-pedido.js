async function cancelarPedidoAll(idpedido) {
  const params = new FormData();
  params.append('operation', 'cancelarPedidoAll');
  params.append('idpedido', idpedido);

  params.forEach((value, key) => {
    console.log(key, value);
  });

  const options = {
    method: 'POST',
    body: params
  }

  try {
    const response = await fetch(`../../controller/pedido.controller.php`, options);
    const data = await response.json();
    console.log(data);
    console.log(data.message);
    if (data.success) {
      showToast(`${data.message}`, 'success', 'SUCCESS');
      return true;
    } else {
      showToast(`${data.message}`, 'error', 'ERROR');
      return true;
    }

  } catch (error) {
    console.error(error);
    // return false;
  }

}