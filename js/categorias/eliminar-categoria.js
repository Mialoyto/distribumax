// document.addEventListener("DOMContentLoaded", function () {
//   window.borrarCategoria = async(idcategoria, nombreCategoria) =>{
//     const confirmacion = await ask("¿Estas seguro de eliminar la categoria?");
//     if(confirmacion){
//       try{
//         const response = await fetch('../../controller/categoria.controller.php',{
//           method: "POST",
//           body: new
//           URLSearchParams({
//             operation: 'deleteCategoria',
//             idcategoria: 'idcategoria' 
//           })
//         });

//         const result = await response.json();
//         if(result.status === 'success'){
//           showToast("Categoria eliminado correctamente", "SUCCESS");
//           await loadCategorias();
//         }else{
//           showToast("Error al intentar eliminar categoria: " + error.message,"ERROR");
//         }
//       }
//     };
//   }
// })