<?php
require_once __DIR__ . '/../Modelo/Publicaciones.php';

$gestorPublicacion = new publicaciones();

$elegirAcciones = isset($_POST['Acciones']) ? $_POST['Acciones'] : "Cargar";

if ($elegirAcciones == 'Crear Publicacion') {
    $gestorPublicacion->agregarPublicacion(
        $_POST['ID_publicacion'],
        $_POST['Fecha_publicacion'],
        $_POST['Descripcion_publicacion'],
        $_POST['Img_publicacion'],
        $_POST['Cont_Explicit_publi'],
        $_POST['ID_usuario']
    );
} elseif ($elegirAcciones == 'Actualizar Publicacion') {
    $gestorPublicacion->actualizarPublicacion(
        $_POST['ID_publicacion'],
        $_POST['Fecha_publicacion'],
        $_POST['Descripcion_publicacion'],
        $_POST['Img_publicacion'],
        $_POST['Cont_Explicit_publi'],
        $_POST['ID_usuario']
    );
} 
elseif ($elegirAcciones == 'Borrar Publicacion') {
    $gestorPublicacion->borrarPublicacion($_POST['ID_publicacion']);
} 
elseif ($elegirAcciones == 'Buscar Publicacion') {
    $resultado = $gestorPublicacion->consultarPublicacion($_POST['ID_publicacion']);
}


// Obtener todas las publicaciones
$resultado = $gestorPublicacion->consultarPublicaciones();

// Guardar todas las publicaciones en un array temporal
$publicaciones = [];

while ($publicacion = $resultado->fetch_assoc()) {
    $publicaciones[] = $publicacion;
}

// Ordenar las publicaciones del último al primero
$publicaciones = array_reverse($publicaciones);

// Agrupaciones por defecto (5 columnas)
$agrupados_5 = [
    1 => [],
    2 => [],
    3 => [],
    4 => [],
    5 => [],
];

foreach ($publicaciones as $publicacion) {
    $id = $publicacion['ID_publicacion'];
    $grupo = ($id - 1) % 5 + 1;
    $agrupados_5[$grupo][] = $publicacion;
}

// Código adicional para 4 columnas
$agrupados_4 = [
    1 => [],
    2 => [],
    3 => [],
    4 => [],
];

foreach ($publicaciones as $publicacion) {
    $id = $publicacion['ID_publicacion'];
    $grupo = ($id - 1) % 4 + 1;
    $agrupados_4[$grupo][] = $publicacion;
}

// Código adicional para 3 columnas
$agrupados_3 = [
    1 => [],
    2 => [],
    3 => [],
];

foreach ($publicaciones as $publicacion) {
    $id = $publicacion['ID_publicacion'];
    $grupo = ($id - 1) % 3 + 1;
    $agrupados_3[$grupo][] = $publicacion;
}

// Código adicional para 2 columnas
$agrupados_2 = [
    1 => [],
    2 => [],
];

foreach ($publicaciones as $publicacion) {
    $id = $publicacion['ID_publicacion'];
    $grupo = ($id - 1) % 2 + 1;
    $agrupados_2[$grupo][] = $publicacion;
}

$agrupados_1 = [
    1 => [], // Solo un grupo
];

// Agrupar publicaciones
foreach ($publicaciones as $publicacion) {
    $agrupados_1[1][] = $publicacion; // Todas las publicaciones van al grupo 1
}

