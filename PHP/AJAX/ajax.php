<?php
// archivo ajax_detalles_publicacion.php
if (isset($_POST['ID_publicacion'])) {
    require_once '../Controlador/controladorPublicaciones.php';

    // Obtén el ID de la publicación desde el POST
    $ID_publicacion = $_POST['ID_publicacion'];

    // Usa el controlador para consultar la publicación
    $resultado = $gestorPublicacion->consultarPublicacion($ID_publicacion);

    // Verifica si hay resultados
    if ($resultado->num_rows > 0) {
        $publicacion = $resultado->fetch_assoc();

        // Prepara los datos para enviarlos de vuelta como JSON
        $response = [
            'id' => $publicacion['ID_publicacion'],
            'imagen' => $publicacion['Img_publicacion'],
            'titulo' => $publicacion['Titulo_publicacion'],
            'descripcion' => $publicacion['Descripcion_publicacion'],
            'fechaCreacion' => $publicacion['Fecha_publicacion'],
            'usuario' => $publicacion['Nombre_usuario'] // El nombre del usuario obtenido desde la tabla Usuario
        ];

        // Devuelve los datos en formato JSON
        echo json_encode($response);
    } else {
        // Si no se encuentra la publicación
        echo json_encode(['error' => 'Publicación no encontrada']);
    }
}