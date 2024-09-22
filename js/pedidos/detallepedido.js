document.addEventListener("DOMContentLoaded", () => {
 function $(object = null) {
   return document.querySelector(object);
 }

 const getIdPedio = require('./pedidos');

 getIdPedio().then((idPedido) => {
   console.log(idPedido);
 });

});