document.addEventListener("DOMContentLoaded", () => {
	function $(object = null) {
		return document.querySelector(object);
	}
	const idproducto = $("#searchProducto");
	let stock = $("#stockactual");
	let datalist = $("#listProductKardex");
	let medida = $("#medida");


	let producto = '';
	// OK ✔️
	idproducto.addEventListener('input', async (event) => {
		producto = event.target.value;
		if (!producto.length == 0) {
			await mostraResultados();
		} else {
			datalist.innerHTML = '';
			stock.value = '';
			medida.textContent = 'Unidad Medida';
			idproducto.removeAttribute('producto');
		}
	});
	// OK ✔️
	const searchProducto = async (producto) => {
		const searchData = new URLSearchParams();
		searchData.append('operation', 'searchProducto');
		searchData.append('_item', producto);
		try {
			const response = await fetch(`../../controller/producto.controller.php?${searchData}`);
			const data = await response.json();
			// console.log("Function SearchProducto",data);
			return data;
		} catch (e) {
			console.error(e);
		}
	};
	// OK ✔️
	const mostraResultados = async () => {
		const response = await searchProducto(producto);
		console.log(response);
		datalist.innerHTML = '';
		if (response.data.length > 0) {
			datalist.style.display = 'block';
			response.data.forEach(item => {
				const li = document.createElement('li');
				li.classList.add('list-group-item');
				li.innerHTML = `<b>${item.codigo}</b>-${item.nombreproducto}
				<h6 class="btn btn-secondary btn-sm h-25 d-inline-block">${item.unidadmedida}</h6> `
				li.setAttribute('data-id', item.idproducto);
				li.addEventListener('click', async () => {
					idproducto.value = item.nombreproducto;
					idproducto.setAttribute('producto', item.idproducto);
					await viewStock(item.stockactual, item.unidadmedida);
					datalist.innerHTML = '';
				});
				datalist.appendChild(li);
			});
			if (response.data.stockactual == 0) {
				alert("Producto sin stock")
			}
		}
	};
	// OK ✔️
	async function viewStock(stockactual, unidaMedida) {
		stock.value = stockactual;
		medida.textContent = unidaMedida
	}


	// PROBANDO EL REGISTRO DE KARDEX 
	let fecha;
	$("#fechaVP").addEventListener('input', () => {
		fecha = $("#fechaVP").value;
		console.log(fecha);
		if (fecha <= new Date().toISOString().split('T')[0]) {
			showToast('La fecha de vencimiento debe ser mayor a la fecha actual', 'warning', 'WARNING', 2500);
			fecha.value = new Date().toISOString().split('T')[0];
			return;
		};
	});
	async function registrarkardex() {
		const params = new FormData();
		params.append('operation', 'add');
		params.append('idusuario', $("#iduser").getAttribute('data-id'));
		params.append('idproducto', idproducto.getAttribute('producto'));
		params.append('fecha_vencimiento', $("#fechaVP").value);
		params.append('numlote', $("#loteP").value);
		params.append('tipomovimiento', $("#tipomovimiento").value);
		params.append('cantidad', $("#cantidad").value);
		params.append('motivo', $("#motivo").value);

		const options = {
			method: 'POST',
			body: params
		}
		try {
			const response = await fetch(`../../controller/kardex.controller.php`, options)
			const data = await response.json()
			console.log(" respuesta de la funcion registrar Kardex", data)
			return data;
		} catch (e) {
			console.error(e)
		}
	}
	// FIN DE PRUEBA DE REGISTRO DE KARDEX


	// EVENTO DE REGISTRO DE KARDEX
	$("#form-registrar-kardex").addEventListener('submit', async (event) => {
		event.preventDefault();
		if (fecha <= new Date().toISOString().split('T')[0]) {
			showToast('La fecha de vencimiento debe ser mayor a la fecha actual', 'warning', 'WARNING', 2500);
			return;
		} else {
			if (await showConfirm('¿Desea registrar el producto en el kardex?', 'Kardex')) {
				const resultado = await registrarkardex();
				if (resultado.estado) {
					showToast('Registro exitoso del producto en el kardex', 'success', 'SUCCESS', 2500,);
					$("#form-registrar-kardex").reset();
				} else {
					showToast('Error al registrar el producto en el kardex', 'error', 'ERROR', 2500);
				}
			} else {
				showToast('Registro cancelado', 'error', 'ERROR', 2500);
			}
		}

	})

	$("#btnCancelar").addEventListener('click', () => {
		$("#form-registrar-kardex").reset();
		$("#medida").textContent = 'Unidad Medida';
	})
	// FIN DE EVENTO DE REGISTRO DE KARDEX
});