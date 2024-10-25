let productos = [];

const contenedorProductos = document.getElementById("contenedor-productos");
const botonesCategorias = document.querySelectorAll(".boton-categoria");
const tituloPrincipal = document.querySelector("#titulo-principal");
let botonesAgregar = document.querySelectorAll(".producto-agregar");
const numerito = document.querySelector("#numerito");


const botonTodos = document.querySelector("#todos");

botonTodos.addEventListener("click", () => {
    window.location.href = "../index.php";
});