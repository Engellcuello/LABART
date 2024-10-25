<?php
require_once '../Modelo/Sexo.php';


$gestorSexo = new Sexo();

$elegirAcciones = isset($_POST['Acciones']) ? $_POST['Acciones'] : "Cargar";

if ($elegirAcciones == 'Crear Sexo') {
    $gestorSexo->agregarSexo(
        $_POST['ID_sexo'],
        $_POST['Descripcion_sexo'],
        $_POST['Nombre_sexo']
    );
} elseif ($elegirAcciones == 'Actualizar Sexo') {
    $ID_sexo = $_POST['ID_sexo'];
    $Descripcion_sexo = $_POST['Descripcion_sexo'];
    $Nombre_sexo = $_POST['Nombre_sexo'];

    $gestorSexo->actualizarSexo($ID_sexo,$Descripcion_sexo,$Nombre_sexo);

} elseif ($elegirAcciones == 'Borrar Sexo') {
    $gestorSexo->borrarSexo($_POST['ID_sexo'],'Indefinido');

} elseif ($elegirAcciones == 'Buscar Sexo') {
    $resultado = $gestorSexo->consultarSexo($_POST['ID_sexo']);
}

$resultado = $gestorSexo->consultarSexos();
include "../Vista/vistaSexo.php";
