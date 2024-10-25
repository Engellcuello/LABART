<?php
require_once '../Modelo/Rol.php';
require_once '../Modelo/Estado.php';

$gestorRol = new Rol();

$estados = $gestorRol->obtenerEstado(); // Aquí corregimos la variable

$elegirAcciones = isset($_POST['Acciones']) ? $_POST['Acciones'] : "Cargar";

if ($elegirAcciones == 'Crear Rol') {
    $gestorRol->agregarRol(
        $_POST['ID_rol'],
        $_POST['Nombre_rol'],
        $_POST['Descripcion_rol'],
        $_POST['ID_estado']
    );
} elseif ($elegirAcciones == 'Actualizar Rol') {
    $ID_rol = $_POST['ID_rol'];
    $Nombre_rol = $_POST['Nombre_rol'];
    $Descripcion_rol = $_POST['Descripcion_rol'];
    $ID_estado = $_POST['ID_estado'];

    $gestorRol->actualizarRol($ID_rol, $Nombre_rol, $Descripcion_rol, $ID_estado);
} elseif ($elegirAcciones == 'Borrar Rol') {
    $gestorRol->borrarRol($_POST['ID_rol'], 'Rol Inexistente');
} elseif ($elegirAcciones == 'Buscar Rol') {
    $resultado = $gestorRol->consultarRol($_POST['ID_rol']);
}

$resultado = $gestorRol->consultarRoles();

// Pasamos $estados a la vista
include "../Vista/vistaRol.php";
