/* funcion para cargar datos tipo de documentos */
export async function cargarTipoDoc(element) {
  try {
    const response = await fetch(`../../controller/documento.controller.php`);
    const data = await response.json();
    data.forEach(item => {
      const tagOption = document.createElement('option');
      tagOption.value = item.idtipodocumento;
      tagOption.innerText = item.documento;
      element.appendChild(tagOption);
    });
    return data;
  } catch (error) {
    console.error("Error al cargar los tipos de documentos :", error);
  }
}


