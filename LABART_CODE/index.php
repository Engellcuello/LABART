<?php
require_once 'PHP/Controlador/controladorPublicaciones.php';
?>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="style.css" />
    <link rel="stylesheet" href="rs.css">
    <!-- FRAMEWORKS -->
    <script src="https://kit.fontawesome.com/7a51261991.js" crossorigin="anonymous"></script>
    <!-- FIN FRAMEWORKS -->
    <title>LABART</title>
    <link rel="icon" href="img/solo_logo.png" type="image/x-icon">
</head>


<body>
    <div class="container_all">
        <nav class="menu_nav">
            <div class="menu">

                <div class="logo">
                    <img class="img_logo" src="img/concepto_logo.png" alt="">
                </div>
                <div class="options_menu">
                    <div class="opciones indicador_actual">
                        <div class="indicador_opcion "></div>
                        <i class="icon_selected fa-solid fa-house"></i>
                        <h4 class="text_selected">Inicio</h4>
                    </div>
                    <a href="seccions/Explorar/explorar.php" class="opciones">
                        <i class="fa-regular fa-compass" style="color: #545454;"></i>
                        <h4>Explorar</h4>
                    </a>
                    <a href="seccions/ia/ia.html" class="opciones">
                        <i class="icons fa-regular fa-lightbulb" style="color: #545454;"></i>
                        <h4>IA</h4>
                    </a>
                    <a href="seccions/paint/Paint.html" class="opciones">
                        <i class="icons fa-solid fa-palette" style="color: #545454;"></i>
                        <h4>Crea Tu Arte</h4>
                    </a>
                    <div class="opciones" onclick="abrir_guardados()">
                        <i class="icons fa-regular fa-bookmark" style="color: #545454;"></i>
                        <h4>Publicaciones Guardadas</h4>
                    </div>
                    <h3>Settings</h3>
                    <a href="seccions/perfil/perfil.html" class="opciones">
                        <i class="icons fa-regular fa-user" style="color: #545454;"></i>
                        <h4>Mi Perfil</h4>
                    </a>
                    <div class="opciones" onclick="mostrar_ajustes()">
                        <i class="icons fa-solid fa-gear" style="color: #545454;"></i>
                        <h4>Configuraciones</h4>
                    </div>
                </div>
                <div class="box">
                    <div class="ayuda">
                        <div class="overlap-group">
                            <img class="primary-button" src="img/primary-button.svg" />
                        </div>
                    </div>
                </div>
            </div>
        </nav>
        <section>
            <div class="home" id="home">
                <div class="cabeza_home">
                    <div class="cabeza_texto">
                        <h1>
                            Bienvenido a LABART
                        </h1>
                        <p>
                            Hola [USUARIO]
                        </p>
                    </div>
                    <div class="cabeza_buscador">
                        <div class="buscador">
                            <form action="#" method="GET">
                                <button class="icon_buscar" type="submit">
                                    <i class=" fa-solid fa-magnifying-glass" style="color: #000000af;"></i>
                                </button>
                                <input class="buscar" type="search" name="q" placeholder="Buscar" maxlength="28">
                                <i class="icon_setting fa-solid fa-sliders" style="color: #000000af;"></i>
                            </form>
                        </div>
                    </div>
                    <div class="cabeza_acciones">
                        <div class="icono_cabeza mensajes">
                            <i class="fa-regular fa-comments"></i>
                        </div>
                        <div class="icono_centro icono_cabeza notificacion">
                            <i class="fa-regular fa-bell"></i>
                        </div>
                        <a href="seccions/perfil/perfil.html">
                            <div class="icono_cabeza icon_user">
                                <img src="img/fotos_usuario/personas-controladoras-wide_webp.webp" alt="">
                            </div>
                        </a>
                    </div>
                </div>

                <div class="contenedor_buttonera">

                    <div class="tarjeta_home">
                        <div class="">
                            <h2 class="titulo_home">Crea, Explora y Publica Arte</h2>
                            <p class="texto_home">
                                Explora tu creatividad, crea obras únicas y compártelas con el mundo en nuestra plataforma dedicada al arte.
                            </p>
                            <div class="">
                                <button class="btn_home btn_home1">
                                    <a href="seccions/Explorar/explorar.html" class="btn_home btn_home2">Explorar Arte</a>
                                </button>

                                <button class="btn_home btn_home2" onclick="mostrar_publicar()">Publica Tu Arte</button>

                                <button class="btn_home btn_home3">
                                    <a href="seccions/paint/paint.html" class="btn_home btn_home3">Crea Tu Arte</a>
                                </button>
                            </div>
                        </div>
                    </div>



                    <div class="tarjeta_contenido ">
                        <div class="contenido_titulo">
                            <h1 class="text_contenido titulo_home">
                                Mi Contenido
                            </h1>
                            <i class="icon_rocket fa-solid fa-rocket" style="color: #ffffff;"></i>
                        </div>
                        <div class="contenido_divicion">
                            <div class="contenido_publicaciones">
                                <p class="texto_contenido">
                                    Publicaciones
                                </p>
                                <p class="texto_contenido">
                                    45
                                </p>
                            </div>
                            <div class="contenido_interacciones">
                                <p class="texto_contenido">
                                    Interacciones
                                </p>
                                <p class="texto_contenido">
                                    1118
                                </p>
                            </div>
                        </div>
                        <div class="boton_detalles flex items-center justify-between">
                            <p class="texto_detalles">
                                Ver Todos Los Detalles
                            </p>
                            <i class="icon_flecha fa-solid fa-arrow-right" style="color: #ffffff;"></i>
                        </div>
                    </div>

                </div>

                <div class="contenedor_todo_2">

                    <div class="contenedor_publicaciones">
                        <div class="titulo_publicaciones">
                            <h2 class="texto_publicaciones">
                                Todas las publicaciones
                            </h2>
                        </div>
                        <div class="titulo_actividad">
                            <h2 class="texto_actividad">
                                Usuarios Recomendados
                            </h2>
                        </div>
                    </div>


                    <div class="tajeta_actividad">
                        <div class="actividad_usuario">
                            <div class="img_actividad_usuario">

                            </div>
                            <div class="detalles_actividad_usuario">
                                <h3 class="nombre_actividad_usuario">
                                    Elena Ortiz
                                </h3>
                                <h4 class="pais_actividad_usuario">
                                    Argentina
                                </h4>
                            </div>
                            <div class="tiempo_actividad_usuario">
                                <h4 class="tiempo_usuario">
                                    48 publicaciones
                                </h4>
                            </div>
                        </div>
                        <div class="actividad_usuario">
                            <div class="img_actividad_usuario">

                            </div>
                            <div class="detalles_actividad_usuario">
                                <h3 class="nombre_actividad_usuario">
                                    Santiago Rodriguez Rodriguez
                                </h3>
                                <h4 class="pais_actividad_usuario">
                                    Brazil
                                </h4>
                            </div>
                            <div class="tiempo_actividad_usuario">
                                <h4 class="tiempo_usuario">
                                    45 publicaciones
                                </h4>
                            </div>
                        </div>
                        <div class="actividad_usuario">
                            <div class="img_actividad_usuario">

                            </div>
                            <div class="detalles_actividad_usuario">
                                <h3 class="nombre_actividad_usuario">
                                    SantiArt
                                </h3>
                                <h4 class="pais_actividad_usuario">
                                    chile
                                </h4>
                            </div>
                            <div class="tiempo_actividad_usuario">
                                <h4 class="tiempo_usuario">
                                    42 publicaciones
                                </h4>
                            </div>
                        </div>
                        <div class="actividad_usuario">
                            <div class="img_actividad_usuario">

                            </div>
                            <div class="detalles_actividad_usuario">
                                <h3 class="nombre_actividad_usuario">
                                    Jull Mendez Barbosa
                                </h3>
                                <h4 class="pais_actividad_usuario">
                                    Colombia
                                </h4>
                            </div>
                            <div class="tiempo_actividad_usuario">
                                <h4 class="tiempo_usuario">
                                    28 publicaciones
                                </h4>
                            </div>
                        </div>
                        <div class="actividad_usuario">
                            <div class="img_actividad_usuario">

                            </div>
                            <div class="detalles_actividad_usuario">
                                <h3 class="nombre_actividad_usuario">
                                    Laura Fernandez Figueroa
                                </h3>
                                <h4 class="pais_actividad_usuario">
                                    Argentina
                                </h4>
                            </div>
                            <div class="tiempo_actividad_usuario">
                                <h4 class="tiempo_usuario">
                                    31 publicaciones
                                </h4>
                            </div>
                        </div>
                        <div class="actividad_usuario">
                            <div class="img_actividad_usuario">

                            </div>
                            <div class="detalles_actividad_usuario">
                                <h3 class="nombre_actividad_usuario">
                                    Sandra Figueroa
                                </h3>
                                <h4 class="pais_actividad_usuario">
                                    Mexico
                                </h4>
                            </div>
                            <div class="tiempo_actividad_usuario">
                                <h4 class="tiempo_usuario">
                                    12 publicaciones
                                </h4>
                            </div>
                        </div>
                        <div class="actividad_usuario">
                            <div class="img_actividad_usuario">

                            </div>
                            <div class="detalles_actividad_usuario">
                                <h3 class="nombre_actividad_usuario">
                                    Laura Acuña
                                </h3>
                                <h4 class="pais_actividad_usuario">
                                    Chile
                                </h4>
                            </div>
                            <div class="tiempo_actividad_usuario">
                                <h4 class="tiempo_usuario">
                                    34 publicaciones
                                </h4>
                            </div>
                        </div>

                        <div class="actividad_usuario">
                            <div class="img_actividad_usuario">

                            </div>
                            <div class="detalles_actividad_usuario">
                                <h3 class="nombre_actividad_usuario">
                                    Adriana Sandobal
                                </h3>
                                <h4 class="pais_actividad_usuario">
                                    Argentina
                                </h4>
                            </div>
                            <div class="tiempo_actividad_usuario">
                                <h4 class="tiempo_usuario">
                                    22 publicaciones
                                </h4>
                            </div>
                        </div>
                        <hr class="linea">
                    </div>

                    <div class="home_columnas home_columnas_5c">
                        <?php for ($i = 1; $i <= 5; $i++): ?>
                            <div class="columnas columna<?php echo $i; ?>">
                                <div class="tarjetas">
                                    <div id="grupo_<?php echo $i; ?>">
                                        <?php foreach ($agrupados_5[$i] as $publicacion): ?>
                                            <div class="tarjeta">
                                                <img src="<?php echo $publicacion['Img_publicacion']; ?>" alt="" onclick="mostrar(<?php echo $publicacion['ID_publicacion']; ?>)">
                                            </div>
                                        <?php endforeach; ?>
                                    </div>
                                </div>
                            </div>
                        <?php endfor; ?>
                    </div>

                    <div class="home_columnas home_columnas_4c">
                        <?php for ($i = 1; $i <= 4; $i++): ?>
                            <div class="columnas columna<?php echo $i; ?>">
                                <div class="tarjetas">
                                    <div id="grupo_<?php echo $i; ?>">
                                        <?php foreach ($agrupados_4[$i] as $publicacion): ?>
                                            <div class="tarjeta">
                                                <img src="<?php echo $publicacion['Img_publicacion']; ?>" alt="" onclick="mostrar(<?php echo $publicacion['ID_publicacion']; ?>)">
                                            </div>
                                        <?php endforeach; ?>
                                    </div>
                                </div>
                            </div>
                        <?php endfor; ?>
                    </div>

                    <div class="home_columnas home_columnas_3c">
                        <?php for ($i = 1; $i <= 3; $i++): ?>
                            <div class="columnas columna<?php echo $i; ?>">
                                <div class="tarjetas">
                                    <div id="grupo_<?php echo $i; ?>">
                                        <?php foreach ($agrupados_3[$i] as $publicacion): ?>
                                            <div class="tarjeta">
                                                <img src="<?php echo $publicacion['Img_publicacion']; ?>" alt="" onclick="mostrar(<?php echo $publicacion['ID_publicacion']; ?>)">
                                            </div>
                                        <?php endforeach; ?>
                                    </div>
                                </div>
                            </div>
                        <?php endfor; ?>
                    </div>

                    <div class="home_columnas home_columnas_2c">
                        <?php for ($i = 1; $i <= 2; $i++): ?>
                            <div class="columnas columna<?php echo $i; ?>">
                                <div class="tarjetas">
                                    <div id="grupo_<?php echo $i; ?>">
                                        <?php foreach ($agrupados_2[$i] as $publicacion): ?>
                                            <div class="tarjeta">
                                                <img src="<?php echo $publicacion['Img_publicacion']; ?>" alt="" onclick="mostrar(<?php echo $publicacion['ID_publicacion']; ?>)">
                                            </div>
                                        <?php endforeach; ?>
                                    </div>
                                </div>
                            </div>
                        <?php endfor; ?>
                    </div>

                    <div class="home_columnas home_columnas_1c">
                        <?php for ($i = 1; $i <= 1; $i++): ?>
                            <div class="columnas columna<?php echo $i; ?>">
                                <div class="tarjetas">
                                    <div id="grupo_<?php echo $i; ?>">
                                        <?php foreach ($agrupados_1[$i] as $publicacion): ?>
                                            <div class="tarjeta">
                                                <img src="<?php echo $publicacion['Img_publicacion']; ?>" alt="" onclick="mostrar(<?php echo $publicacion['ID_publicacion']; ?>)">
                                            </div>
                                        <?php endforeach; ?>
                                    </div>
                                </div>
                            </div>
                        <?php endfor; ?>
                    </div>
                </div>
            </div>
        </section>
    </div>


    <div class="contenedor_detalles" id="contenedor_detalles" onclick="nomostrar()">
        <div class="tarjeta_detalles" onclick="event.stopPropagation();">
            <div class="first_part_detalles">
                <div class="half half-left">
                    <div class="img_descripcion">
                        <img src="" alt="" id="miImagen">
                    </div>
                    <div class="buton_img">
                        <button class="botones_imagen">
                            Descargar
                        </button>
                        <button class="botones_imagen">
                            Compartir
                        </button>
                    </div>
                    <div class="contenedor_part_detalles_img">
                        <div class="half half-left detall">
                            <div class="div_detall">
                                <p class="tittel_descrip">Resolucion</p>
                                <p class="text_descrip" id="resolucionImagen"></p>
                            </div>
                            <div class="div_detall">
                                <p class="tittel_descrip">Derechos de Autor</p>
                                <p class="text_descrip">Ningunor</p>
                            </div>
                        </div>
                        <div class="half half-right detall">
                            <div class="div_detall">
                                <p class="tittel_descrip">Creado</p>
                                <p class="text_descrip" id="fechaCreacion"></p>
                            </div>
                            <div class="div_detall">
                                <p class="tittel_descrip">Adicionales</p>
                                <p class="text_descrip">Tecnicas, pinturas, etc.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="half half-right">
                    <div class="buton_cerrar">
                        <a href="seccions/page_user/page_user.html" class="direccion_user">
                            <div class="icon_user_detalles">
                                <img src="img/fotos_usuario/personas-arrogantes-wide.jpg" alt="">
                                <p id="userName"></p>
                            </div>
                        </a>
                        <div class="icon_saves">
                            <i class="fa-regular fa-bookmark"></i>
                        </div>
                        <button class="boton_tarjeta" onclick="nomostrar()">
                            X
                        </button>
                    </div>
                    <div class="tittle_descripcion">
                        <h2 id="tituloPublicacion">
                            Titulo Publicacion
                        </h2>
                        <hr>
                    </div>
                    <div class="scrool_detalles">
                        <div class="descripcion_card">
                            <h3>
                                Descripcion de la Publicacion
                            </h3>
                            <div class="container_description">
                                <div class="descripcion_tarjeta_texto">
                                    <p id="descripcionPublicacion">
                                        Lorem ipsum dolor sit amet consectetur, adipisicing elit. Facere placeat aut
                                        exercitationem? Eaque quod illum atque suscipit quas ipsam magnam veritatis a.
                                        Ex
                                        qui accusamus beatae sunt, molestiae aliquid enim!
                                        Lorem ipsum dolor sit amet consectetur adipisicing elit. Minima corrupti
                                        reprehenderit sequi animi vel delectus repellendus tempore qui earum, soluta
                                        provident quidem, tenetur hic ullam quasi. Sequi architecto dicta minus.
                                    </p>
                                </div>
                                <div class="categorias_descripcion">
                                    <button>Realismo</button>
                                    <button>paisaje</button>
                                    <button>fotografia</button>
                                </div>
                            </div>
                        </div>
                        <div class="detales_card">
                            <div class="container_description container_comentarios">
                                <div class="titulo_comentarios">
                                    <h2>Comentarios</h2>
                                    <i class="fa-solid fa-angle-down"></i>
                                </div>
                                <div class="categorias_descripcion">
                                    <div class="tarjeta_comentarios">
                                        <div class="icon_comentario">
                                            <img src="img/fotos_usuario/personas-arrogantes-wide.jpg" alt="">
                                        </div>
                                        <div class="contenedor_contenido_reaccion">
                                            <div class="conenido_comentario">
                                                <a href="seccions/page_user/page_user.html" class="direccion_user">
                                                    <div class="titulo_nombre_comentario">
                                                        <h3 class="">Carolina</h3>
                                                    </div>
                                                </a>
                                                <div class="texto_contenido_comentario">
                                                    <h3>Hermosa la imagen asdas asd asd as asda asdsadasd </h3>
                                                </div>
                                            </div>
                                            <div class="detalles_comentario">
                                                <p>6 meses</p>
                                                <p class="texto_centro_comentario">Responder</p>
                                                <i class="fa-regular fa-heart"></i>
                                                <i class="fa-solid fa-bug icono_reporte">
                                                    <span class="texto_reaccion reporte_comentario">
                                                        Reportar comentario
                                                    </span>
                                                </i>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="tarjeta_comentarios">
                                        <div class="icon_comentario">
                                            <img src="img/fotos_usuario/personas-arrogantes-wide.jpg" alt="">
                                        </div>
                                        <div class="contenedor_contenido_reaccion">
                                            <div class="conenido_comentario">
                                                <a href="seccions/page_user/page_user.html" class="direccion_user">
                                                    <div class="titulo_nombre_comentario">
                                                        <h3 class="">Carolina</h3>
                                                    </div>
                                                </a>
                                                <div class="texto_contenido_comentario">
                                                    <h3>Hermosa la imagen asdas asd asd as asda asdsadasd </h3>
                                                </div>
                                            </div>
                                            <div class="detalles_comentario">
                                                <p>6 meses</p>
                                                <p class="texto_centro_comentario">Responder</p>
                                                <i class="fa-regular fa-heart"></i>
                                                <i class="fa-solid fa-bug icono_reporte">
                                                    <span class="texto_reaccion reporte_comentario">
                                                        Reportar comentario
                                                    </span>
                                                </i>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="tarjeta_comentarios">
                                        <div class="icon_comentario">
                                            <img src="img/fotos_usuario/personas-arrogantes-wide.jpg" alt="">
                                        </div>
                                        <div class="contenedor_contenido_reaccion">
                                            <div class="conenido_comentario">
                                                <a href="seccions/page_user/page_user.html" class="direccion_user">
                                                    <div class="titulo_nombre_comentario">
                                                        <h3 class="">Carolina</h3>
                                                    </div>
                                                </a>
                                                <div class="texto_contenido_comentario">
                                                    <h3>Hermosa la imagen asdas asd asd as asda asdsadasd </h3>
                                                </div>
                                            </div>
                                            <div class="detalles_comentario">
                                                <p>6 meses</p>
                                                <p class="texto_centro_comentario">Responder</p>
                                                <i class="fa-regular fa-heart"></i>
                                                <i class="fa-solid fa-bug icono_reporte">
                                                    <span class="texto_reaccion reporte_comentario">
                                                        Reportar comentario
                                                    </span>
                                                </i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="publicacion_comentarios">
                        <div class="primera_publicacion">
                            <div class="left_publicacion">
                                <h2># Comentarios</h2>
                            </div>
                            <div class="right_publicacion">
                                <i class="fa-solid fa-heart"></i>
                                <i class="fa-solid fa-thumbs-up"></i>
                                <i class="fa-solid fa-thumbs-down"></i>
                                <h3>75</h3>
                            </div>
                            <div class="boton_reaccion_publicacion" id="boton_publicacion_reaccion">
                                <i class="fa-regular fa-heart"></i>
                                <span class="texto_reaccion">
                                    Reaccionar
                                </span>
                                <span class="tooltip" id="tooltip">
                                    <i class="fa-solid fa-thumbs-up"></i>
                                    <i class="fa-solid fa-heart"></i>
                                    <i class="fa-solid fa-thumbs-down"></i>
                                </span>
                            </div>
                        </div>
                        <div class="segunda_publicacion">
                            <div class="icon_comentario">
                                <img src="img/fotos_usuario/personas-arrogantes-wide.jpg" alt="">
                            </div>
                            <form action="#" method="POST">
                                <input type="text" class="input_publicar_comentario" placeholder="Añade un comentario">
                                <button type="submit" class="boton_enviar_comentario">
                                    <i class="fa-solid fa-paper-plane"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>


            <div class="second_part_detalles">
                <div class="contenedor_part_detalles">
                    <div class="buton_cerrar texto_detalles_mas">
                        <div class="icon_user_detalles texto_related">
                            <h1>Imagenes Relacionadas</h1>
                        </div>
                        <button class="boton_tarjeta boton_ver_mas">
                            Ver Mas
                        </button>
                    </div>
                    <div class="fila_detalles">
                        <div class="celda_detalles"><img src="img/publicaciones/img10.jpg" alt="Imagen 1"></div>
                        <div class="celda_detalles"><img src="img/publicaciones/img1.jpg" alt="Imagen 2"></div>
                        <div class="celda_detalles"><img src="img/publicaciones/img2.jpg" alt="Imagen 3"></div>
                        <div class="celda_detalles"><img src="img/publicaciones/img3.jpg" alt="Imagen 4"></div>
                    </div>
                    <div class="fila_detalles">
                        <div class="celda_detalles"><img src="img/publicaciones/img10.jpg" alt="Imagen 1"></div>
                        <div class="celda_detalles"><img src="img/publicaciones/img1.jpg" alt="Imagen 2"></div>
                        <div class="celda_detalles"><img src="img/publicaciones/img2.jpg" alt="Imagen 3"></div>
                        <div class="celda_detalles"><img src="img/publicaciones/img3.jpg" alt="Imagen 4"></div>
                    </div>
                    <div class="fila_detalles">
                        <div class="celda_detalles"><img src="img/publicaciones/img10.jpg" alt="Imagen 1"></div>
                        <div class="celda_detalles"><img src="img/publicaciones/img1.jpg" alt="Imagen 2"></div>
                        <div class="celda_detalles"><img src="img/publicaciones/img2.jpg" alt="Imagen 3"></div>
                        <div class="celda_detalles"><img src="img/publicaciones/img3.jpg" alt="Imagen 4"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="contenedor_detalles contenedor_new_publicacion" id="contenedor_new_publicacion"
        onclick="verificarYOcultar()">
        <div class="tarjeta_detalles tarjeta_subir_publicacion" onclick="event.stopPropagation();">
            <div class="first_part_detalles">
                <div class="half half-left">
                    <div class="contenedor_subir_publicacion" id="contenedor_subir_publicacion">
                        <div class="estilo_input_archivo">
                            <div class="contenedor_primeras_partes_publicando">
                                <div class="centro_input_archivo" id="centro_input_archivo">
                                    <div class="icono_upload_input">
                                        <i class="fa-solid fa-cloud-arrow-up"></i>
                                    </div>
                                    <div class="abajo_icon_input">
                                        <p>Elige un archivo o arrástralo y suéltalo aquí</p>
                                    </div>
                                </div>
                                <div class="info_input_archivo" id="info_input_archivo">
                                    <div>
                                        <p>Se recomiendan archivos tipo .jpg menor a 20MB o archivos .mp4 que pesen menos de 200MB</p>
                                    </div>
                                </div>
                            </div>
                            <input class="input_subir_archivo" id="input_subir_archivo" type="file" accept=".jpg,.jpeg,.png,.mp4,.mov,.avi">
                            <img class="img_subir_archivo" id="img_subir_archivo" src="/img/publicaciones/img10.jpg" alt="" style="display: none;">
                            <div class="close_img_archivo" id="close_img_archivo" style="display: none;">
                                <i class="fa-regular fa-circle-xmark"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="half half-right parte_derecha_new_publicacion">
                    <div class="parte_cerrar_publicacion">
                        <div>
                            <button class="boton_tarjeta" onclick="nomostrar_publicar()">
                                X
                            </button>
                        </div>
                    </div>
                    <div class="informacion_new_publicacion">
                        <div class="titulo_new_publicacion">
                            <p>
                                Titulo
                            </p>
                            <input class="input_nueva_publicacion" type="text" maxlength="58"
                                placeholder="Añade un titulo">
                        </div>
                        <div class="descripcion_new_publicacion">
                            <p>
                                Descripcion
                            </p>
                            <textarea class="input_nueva_publicacion" maxlength="160" type="text"
                                placeholder="Añade una descripcion detallada"></textarea>
                        </div>
                        <div class="tecnicas_new_publicacion">
                            <p>Tecnicas utilizadas</p>
                            <textarea class="input_nueva_publicacion input_descripcion_publicacion" type="text"
                                placeholder="Añade tecnicas utilizadas"></textarea>
                        </div>
                        <div class="half half-left izquierdo_izquierdo_publicacion">
                            <div class="permitir_comentarios_new_publicacion">
                                <p>
                                    Permitir comentarios
                                </p>
                                <div class="toggle-button-cover boton_desplazable">
                                    <div class="button r" id="button-3">
                                        <input type="checkbox" class="checkbox">
                                        <div class="knobs"></div>
                                        <div class="layer"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="half half-right derecho_derecho_publicacion">
                            <div class="derechos_autor_new_publicacion">
                                <p>
                                    Derechos de autor
                                </p>
                                <div class="toggle-button-cover boton_desplazable">
                                    <div class="button r" id="button-3">
                                        <input type="checkbox" class="checkbox">
                                        <div class="knobs"></div>
                                        <div class="layer"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="categoria_new_publicacion">
                            <button class="boton_mostrar_categorias_publicacion" onclick="mostrar_publicar_categoria()">
                                Seleccionar una o varias categorias
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="fondo_borroso" id="fondo_borroso" onclick="verificarYOcultar()">
                <div class="seleccionar_categorias_new_publicacion" id="seleccionar_categorias_new_publicacion" onclick="event.stopPropagation();">
                    <div class="close_select_categoria_publicacion">
                        <i class="fa-regular fa-circle-xmark" onclick="nomostrar_publicar_categoria()"></i>
                    </div>
                    <div class="contenido_seleccionar_categoria">
                        <select name="language" class="custom-select" multiple>
                            <option value="html">HTML</option>
                            <option value="css">CSS</option>
                            <option value="javascript">JavaScript</option>
                            <option value="python">Python</option>
                            <option value="sql">SQL</option>
                            <option value="kotlin">Kotlin</option>
                        </select>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="contenedor_detalles " id="contenedor_ajustes" onclick="nomostrar_ajustes()">

        <div class="tarjeta_detalles tarjeta_settings detalles_home" onclick="event.stopPropagation();">

            <div class="tittle_settings">
                <div class="parte_left_tittle_ajustes">
                    <i class="fa-solid fa-gear icono_settings_set"></i>
                    <h2 class="titulo_ajustes">
                        AJUSTES
                    </h2>
                </div>

                <div class="parte_right_tittle_ajustes">
                    <button class="boton_tarjeta" onclick="nomostrar_ajustes()">
                        X
                    </button>
                </div>
            </div>

            <div class="ajustes_cuenta">
                <div class="tittle_detalles_cuenta">
                    <i class="fa-regular fa-user icono_user_setting"></i>
                    <h2 class="titulo_detalles_cuenta">
                        Cuenta
                    </h2>

                </div>
                <hr class="linea_separadora_ajustes">
                <div class="contenid_ajustes_cuenta">
                    <div class="contenido_editar_perfil">
                        <div class="texto_contenido_editar_perfil">
                            <p class="texto_ajustes_cuenta">
                                Editar Perfil
                            </p>
                        </div>
                        <div class="flecha_editar_perfil">
                            <i class="fa-solid fa-greater-than"></i>
                        </div>
                    </div>
                    <div class="contenido_editar_perfil">
                        <div class="texto_contenido_editar_perfil">
                            <p class="texto_ajustes_cuenta">
                                Cambiar Contraseña
                            </p>
                        </div>
                        <div class="flecha_editar_perfil">
                            <i class="fa-solid fa-greater-than"></i>
                        </div>
                    </div>
                    <div class="contenido_editar_perfil">
                        <div class="texto_contenido_editar_perfil">
                            <p class="texto_ajustes_cuenta">
                                Tus preferencias
                            </p>
                        </div>
                        <div class="flecha_editar_perfil">
                            <i class="fa-solid fa-greater-than"></i>
                        </div>
                    </div>
                </div>
            </div>


            <div class="ajustes_cuenta">

                <div class="tittle_detalles_cuenta">
                    <i class="fa-regular fa-bell"></i>
                    <h2 class="titulo_detalles_cuenta">
                        NOTIFICACIONES
                    </h2>
                </div>

                <hr class="linea_separadora_ajustes">

                <div class="contenido_ajustes_cuenta">
                    <div class="contenido_editar_perfil">
                        <div class="texto_contenido_editar_perfil">
                            <p class="texto_ajustes_cuenta">
                                Mostrar Notificaciones
                            </p>
                        </div>
                        <div class="toglle_notifications">
                            <label class="toggle-switch">
                                <input type="checkbox">
                                <div class="toggle-switch-background">
                                    <div class="toggle-switch-handle"></div>
                                </div>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ajustes_cuenta">

                <div class="tittle_detalles_cuenta">
                    <i class="fa-regular fa-bell"></i>
                    <h2 class="titulo_detalles_cuenta">
                        OTROS AJUSTES
                    </h2>
                </div>

                <hr class="linea_separadora_ajustes">

                <div class="contenido_ajustes_cuenta contenedor_idiomas">
                    <div class="contenido_editar_perfil">
                        <div class="ajustes_lenguajes">
                            <button class="cssbuttons-io-button">
                                Cambiar Lenguaje
                                <div class="icon" id="chose_language" onclick="mostrar_ajustes_lenguaje()">
                                    <svg
                                        height="24"
                                        width="24"
                                        viewBox="0 0 24 24"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <path d="M0 0h24v24H0z" fill="none"></path>
                                        <path
                                            d="M16.172 11l-5.364-5.364 1.414-1.414L20 12l-7.778 7.778-1.414-1.414L16.172 13H4v-2z"
                                            fill="currentColor"></path>
                                    </svg>
                                </div>
                            </button>

                        </div>
                    </div>

                </div>

            </div>

        </div>

    </div>


    <div class="contenedor_detalles contenedor_detalles_ajustes" id="contenedor_ajustes_2" onclick="verificarYOcultar_detalles()">

        <div class="tarjeta_detalles tarjeta_settings contenedor_ajustes_id_detale" id="contenedor_ajustes_id_detale" onclick="event.stopPropagation();">

            <div class="contenido_detalles_lenguaje">

                <div class="tittle_settings">
                    <div class="parte_left_tittle_ajustes">
                        <i class="icono_cambio_lenguaje fa-solid fa-earth-americas"></i>
                        <h2 class="titulo_ajustes">
                            Cambiar Lenguaje
                        </h2>
                    </div>

                    <div class="parte_right_tittle_ajustes">
                        <button class="boton_tarjeta" onclick="nomostrar_ajustes_lenguaje()">
                            X
                        </button>
                    </div>
                </div>
                <div class="band_settings">
                    <div class="uband banderas" id="language_english" onclick="cambiarIdioma('en')">
                        <img src="img/banderas/band_eeuu.png" alt="">
                        <h3>
                            ENGLISH
                        </h3>
                    </div>
                    <div class="banderas">
                        <img src="img/banderas/band_spain.png" cambiarIdioma('es') alt="">
                        <h3>
                            ESPAÑOL
                        </h3>
                    </div>
                    <div class="banderas">
                        <img src="img/banderas/band_portugal.png" alt="">
                        <h3>
                            PORTUGUES
                        </h3>
                    </div>
                    <div class="banderas">
                        <img src="img/banderas/band_francia.png" alt="">
                        <h3>
                            FRANCES
                        </h3>
                    </div>
                </div>
            </div>

        </div>



    </div>

    <div id="google_translate_element" style="display:none;"></div>

    <script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
    <script src="../labart/index.js"></script>
</body>

</html>