<?php
require_once '../Modelo/Pqrs.php';
require_once '../Modelo/Estado.php';
require_once '../Modelo/Usuario.php';

$gestorPqrs = new Pqrs();

$estados = $gestorPqrs->obtenerEstado(); // Aquí corregimos la variable
$usuarios = $gestorPqrs->obtenerUsuario(); // Aquí corregimos la variable

$elegirAcciones = isset($_POST['Acciones']) ? $_POST['Acciones'] : "Cargar";

if ($elegirAcciones == 'Crear Pqrs') {
    $gestorPqrs->agregarPqrs(
        $_POST['ID_pqrs'],
        $_POST['Fecha_pqrs'],
        $_POST['Contenido_pqrs'],
        $_POST['ID_estado'],
        $_POST['ID_usuario']
    );
} elseif ($elegirAcciones == 'Actualizar Pqrs') {
    $ID_pqrs= $_POST['ID_pqrs'];
    $Fecha_pqrs = $_POST['Fecha_pqrs'];
    $Contenido_pqrs = $_POST['Contenido_pqrs'];
    $ID_estado = $_POST['ID_estado'];
    $ID_usuario = $_POST['ID_usuario'];

    $gestorPqrs->actualizarPqrs($ID_pqrs, $Fecha_pqrs, $Contenido_pqrs, $ID_estado, $ID_usuario);
} elseif ($elegirAcciones == 'Borrar Pqrs') {
    $gestorPqrs->borrarPqrs($_POST['ID_pqrs'], 'Contenido No Existente');
} elseif ($elegirAcciones == 'Buscar Pqrs') {
    $resultado = $gestorPqrs->consultarPqr($_POST['ID_pqrs']);
}

$resultado = $gestorPqrs->consultarPqrs();

// Pasamos $estados a la vista
include "../Vista/vistaPqrs.php";
