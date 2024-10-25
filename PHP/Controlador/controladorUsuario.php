<?php
require_once 'C:\xampp\htdocs\LABART\PHP\Modelo\Usuario.php';
require_once 'C:\xampp\htdocs\LABART\PHP\Modelo/Sexo.php';
require_once 'C:\xampp\htdocs\LABART\PHP\Modelo/Rol.php';


$gestorUsuario = new Usuario();

$sexos = $gestorUsuario->obtenerSexos();
$roles = $gestorUsuario->obtenerRoles();


$elegirAcciones = isset($_POST['Acciones']) ? $_POST['Acciones'] : "Cargar";



if ($elegirAcciones == 'Crear Usuario') {
    // Obtención del último ID
    $ultimoID = $gestorUsuario->obtenerUltimoID();

    if ($ultimoID) {
        if ($ultimoID->num_rows > 0) {
            $fila = $ultimoID->fetch_assoc();
            $nuevoID = (int)$fila['ID_usuario'] + 1; // Incrementar el ID en 1
        } else {
            $nuevoID = 1; // Si no hay registros, el nuevo ID comienza en 1
        }
    } 

    $fechaActual = date('Y-m-d');

    // Agregar usuario
    $gestorUsuario->agregarUsuario(
        $nuevoID,
        $_POST['Nombre_usuario'],
        $_POST['Contraseña'],
        $_POST['Correo_usuario'],
        $fechaActual,
        isset($_POST['Notificaciones']) ? $_POST['Notificaciones'] : '0',
        isset($_POST['ID_sexo']) ? $_POST['ID_sexo'] : null,
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

elseif ($elegirAcciones == 'Consultar credenciales') {
    $Nombre_usuario = $_POST['Nombre_usuario'];
    $Contraseña = $_POST['Contraseña'];

    // Verificar credenciales
    if ($gestorUsuario->verificarCredenciales($Nombre_usuario, $Contraseña)) {
        // Credenciales correctas
        header("Location: ../../index.php");
        exit();
    } else {
        // Credenciales incorrectas
        header("Location: ../../login/login.php?error=1");
        exit();
    }
}


$resultado = $gestorUsuario->consultarUsuarios();
