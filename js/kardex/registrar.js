document.addEventListener("DOMContentLoaded", () => {
	function $(object = null) {
		return document.querySelector(object);
	}
	const idproducto = $("#searchProducto");
	let stock = $("#stockactual");
	let datalist = $("#listProductKardex");
	let medida = $("#medida");


	let producto = '';

	if (idproducto) {
		idproducto.addEventListener('input', event => {
			producto = event.target.value;
			console.log("soy la linea 24", producto.length);
			if (!producto.length == 0) {
				mostraResultados();
			} else {
				datalist.innerHTML = '';
				console.log("la longitud es:", producto.length);

			}

		})
	};
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

	const mostraResultados = async () => {
		const response = await searchProducto(producto);
		console.log("soy la linea 35", response.data);
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

					await viewStock(item.stockactual,item.unidadmedida);
					datalist.innerHTML = '';
				});
				datalist.appendChild(li);
				// datalist.style.display = 'block';
			});
		}
	};

	async function viewStock(stockactual, unidaMedida) {
		stock.value = stockactual;
		medida.textContent = unidaMedida
	}


	let selectedId;
	idproducto.addEventListener('change', async event => {
		const selectedDistrito = event.target.value;
		const options = datalist.children;

		for (let i = 0; i < options.length; i++) {
			if (options[i].value === selectedDistrito) {
				selectedId = options[i].getAttribute('data-id');
				// ERROR
				// await cargarStock();
				break;
			}
		}
	});

	async function registrarkardex() {
		const params = new FormData();
		params.append('operation', 'add');
		params.append('idusuario', $("#idusuario").value);
		params.append('idproducto', selectedId);
		params.append('stockactual', $("#stockactual").value);
		params.append('tipomovimiento', $("#tipomovimiento").value);
		params.append('cantidad', $("#cantidad").value);
		params.append('motivo', $("#motivo").value)

		const options = {
			method: 'POST',
			body: params
		}
		const response = await fetch(`../../controller/kardex.controller.php`, options)
		return response.json()
			.catch(e => { console.error(e) })
	}


	const formkardex = $("#form-registrar-kardex").addEventListener('submit', async (event) => {
		event.preventDefault();

		const resultado = await registrarkardex();
		if (resultado) {
			alert("exitoso!")
			formkardex.reset();
		} else {
			alert("No se puede")
		}
	})
});