<?php
require_once '../Modelo/Estado.php';


$gestorEstado = new Estado();

$elegirAcciones = isset($_POST['Acciones']) ? $_POST['Acciones'] : "Cargar";

if ($elegirAcciones == 'Crear Estado') {
    $gestorEstado->agregarEstado(
        $_POST['ID_estado'],
        $_POST['Nombre_estado'],
        $_POST['Descripcion_estado']
    );
} elseif ($elegirAcciones == 'Actualizar Estado') {
    $ID_estado = $_POST['ID_estado'];
    $Nombre_estado = $_POST['Nombre_estado'];
    $Descripcion_estado = $_POST['Descripcion_estado'];

    $gestorEstado->actualizarEstado($ID_estado,$Nombre_estado,$Descripcion_estado);

} elseif ($elegirAcciones == 'Borrar Estado') {
    $gestorEstado->borrarEstado($_POST['ID_estado'],'Inexistente');

} elseif ($elegirAcciones == 'Buscar Estado') {
    $resultado = $gestorEstado->consultarEstado($_POST['ID_estado']);
}

$resultado = $gestorEstado->consultarEstados();
include "../Vista/vistaEstado.php";
