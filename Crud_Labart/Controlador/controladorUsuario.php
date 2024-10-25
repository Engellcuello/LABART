<?php
require_once '../Modelo/Usuario.php';
require_once '../Modelo/Sexo.php';
require_once '../Modelo/Rol.php';


$gestorUsuario = new Usuario();

$sexos = $gestorUsuario->obtenerSexos();
$roles = $gestorUsuario->obtenerRoles();


$elegirAcciones = isset($_POST['Acciones']) ? $_POST['Acciones'] : "Cargar";

if ($elegirAcciones == 'Crear Usuario') {

    $gestorUsuario->agregarUsuario(
        $_POST['ID_usuario'],
        $_POST['Nombre_usuario'],
        $_POST['Contraseña'],
        $_POST['Correo_usuario'],
        $_POST['Fecha_usuario'],
        $_POST['Notificaciones'], 
        $_POST['ID_sexo'],
        $_POST['Img_usuario'],
        $_POST['ID_rol'],
        $_POST['Cont_Explicit']
       
    );
} elseif ($elegirAcciones == 'Actualizar Usuario') {
    
        $ID_usuario = $_POST['ID_usuario'];
        $Nombre_usuario = $_POST['Nombre_usuario'];
        $Contraseña = $_POST['Contraseña'];
        $Correo_usuario = $_POST['Correo_usuario'];
        $Fecha_usuario = $_POST['Fecha_usuario'];
        $Notificaciones = $_POST['Notificaciones'];
        $ID_sexo = $_POST['ID_sexo'];
        $Img_usuario = $_POST['Img_usuario'];
        $ID_rol = $_POST['ID_rol'];
        $Cont_Explicit = isset($_POST['Cont_Explicit']) ? $_POST['Cont_Explicit'] : 0;

    $gestorUsuario->actualizarUsuario($ID_usuario, $Nombre_usuario, $Contraseña, $Correo_usuario,$Fecha_usuario,$Notificaciones,$ID_sexo,$Img_usuario,$ID_rol,$Cont_Explicit);

} elseif ($elegirAcciones == 'Borrar Usuario') {
    $gestorUsuario->borrarUsuario($_POST['ID_usuario'], '0');
} elseif ($elegirAcciones == 'Buscar Usuario') {
    $resultado = $gestorUsuario->consultarUsuario($_POST['ID_usuario']);
}


$resultado = $gestorUsuario->consultarUsuarios();


include "../Vista/vistaUsuario.php";
