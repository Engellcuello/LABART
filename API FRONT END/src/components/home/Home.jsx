import React from 'react';
import logo from '../../assets/img/concepto_logo.png';
import pribut from '../../assets/img/primary-button.svg';
import imgper from '../../assets/img/fotos_usuario/imgper.webp'
import persoar from '../../assets/img/fotos_usuario/persoar.jpg';

const Home = () => {
  return (
    <div className='contenedor_todo'>
  <div className="container_all">
    <nav className="menu_nav">
      <div className="menu">
        <div className="logo">
          <img className="img_logo" src={logo} />
        </div>
        <div className="options_menu">
          <div className="opciones indicador_actual">
            <div className="indicador_opcion " />
            <i className="icon_selected fa-solid fa-house iconos" />
            <h4 className="text_selected texto_h">Inicio</h4>
          </div>
          <a href="seccions/Explorar/explorar.php" className="opciones texto">
            <i className="fa-regular fa-compass iconos" style={{color: '#545454'}} />
            <h4 className='texto_h'>Explorar</h4>
          </a>
          <a href="seccions/ia/ia.html" className="opciones texto">
            <i className="icons fa-regular fa-lightbulb iconos" style={{color: '#545454'}} />
            <h4 className='texto_h'>IA</h4>
          </a>
          <a href="seccions/paint/Paint.html" className="opciones texto">
            <i className="icons fa-solid fa-palette iconos" style={{color: '#545454'}} />
            <h4 className='texto_h'>Crea Tu Arte</h4>
          </a>
          <div className="opciones" onclick="abrir_guardados()">
            <i className="icons fa-regular fa-bookmark iconos" style={{color: '#545454'}} />
            <h4 className='texto_h'>Publicaciones Guardadas</h4>
          </div>
          <h3 className='posicion_h'>Settings</h3>
          <a href="seccions/perfil/perfil.html" className="opciones texto">
            <i className="icons fa-regular fa-user iconos" style={{color: '#545454'}} />
            <h4 className='texto_h'>Mi Perfil</h4>
          </a>
          <div className="opciones" onclick="mostrar_ajustes()">
            <i className="icons fa-solid fa-gear iconos" style={{color: '#545454'}} />
            <h4 className='texto_h'>Configuraciones</h4>
          </div>
        </div>
        <div className="box">
          <div className="ayuda">
            <div className="overlap-group">
              <img className="primary-button" src={pribut} />
            </div>
          </div>
        </div>
      </div>
    </nav>
    <section>
      <div className="home" id="home">
        <div className="cabeza_home">
          <div className="cabeza_texto">
            <h1>
              Bienvenido a LABART
            </h1>
            <p>
              Hola [USUARIO]
            </p>
          </div>
          <div className="cabeza_buscador">
            <div className="buscador">
              <form action="#" method="GET">
                <button className="icon_buscar" type="submit">
                  <i className=" fa-solid fa-magnifying-glass iconos" style={{color: '#000000af'}} />
                </button>
                <input className="buscar" type="search" name="q" placeholder="Buscar" maxLength={28} />
                <i className="icon_setting fa-solid fa-sliders iconos" style={{color: '#000000af'}} />
              </form>
            </div>
          </div>
          <div className="cabeza_acciones">
            <div className="icono_cabeza mensajes">
              <i className="fa-regular fa-comments iconos" />
            </div>
            <div className="icono_centro icono_cabeza notificacion">
              <i className="fa-regular fa-bell iconos" />
            </div>
            <a href="seccions/perfil/perfil.html" className='texto'>
              <div className="icono_cabeza icon_user">
                <img src={imgper} alt />
              </div>
            </a>
          </div>
        </div>
        <div className="contenedor_buttonera">
          <div className="tarjeta_home">
            <div className>
              <h2 className="titulo_home">Crea, Explora y Publica Arte</h2>
              <p className="texto_home">
                Explora tu creatividad, crea obras únicas y compártelas con el mundo en nuestra plataforma dedicada al arte.
              </p>
              <div className>
                <button className="btn_home btn_home1">
                  <a href="seccions/Explorar/explorar.html" className="btn_home btn_home2 texto">Explorar Arte</a>
                </button>
                <button className="btn_home btn_home2" onclick="mostrar_publicar()">Publica Tu Arte</button>
                <button className="btn_home btn_home3">
                  <a href="seccions/paint/paint.html" className="btn_home btn_home3 texto">Crea Tu Arte</a>
                </button>
              </div>
            </div>
          </div>
          <div className="tarjeta_contenido ">
            <div className="contenido_titulo">
              <h1 className="text_contenido titulo_home">
                Mi Contenido
              </h1>
              <i className="icon_rocket fa-solid fa-rocket iconos" style={{color: '#ffffff'}} />
            </div>
            <div className="contenido_divicion">
              <div className="contenido_publicaciones">
                <p className="texto_contenido">
                  Publicaciones
                </p>
                <p className="texto_contenido">
                  45
                </p>
              </div>
              <div className="contenido_interacciones">
                <p className="texto_contenido">
                  Interacciones
                </p>
                <p className="texto_contenido">
                  1118
                </p>
              </div>
            </div>
            <div className="boton_detalles flex items-center justify-between">
              <p className="texto_detalles">
                Ver Todos Los Detalles
              </p>
              <i className="icon_flecha fa-solid fa-arrow-right iconos" style={{color: '#ffffff'}} />
            </div>
          </div>
        </div>
        <div className="contenedor_todo_2">
          <div className="contenedor_publicaciones">
            <div className="titulo_publicaciones">
              <h2 className="texto_publicaciones">
                Todas las publicaciones
              </h2>
            </div>
            <div className="titulo_actividad">
              <h2 className="texto_actividad">
                Usuarios Recomendados
              </h2>
            </div>
          </div>
          <div className="tajeta_actividad">
            <div className="actividad_usuario">
              <div className="img_actividad_usuario">
              </div>
              <div className="detalles_actividad_usuario">
                <h3 className="nombre_actividad_usuario posicion_h">
                  Elena Ortiz
                </h3>
                <h4 className="pais_actividad_usuario texto_h">
                  Argentina
                </h4>
              </div>
              <div className="tiempo_actividad_usuario texto_h">
                <h4 className="tiempo_usuario">
                  48 publicaciones
                </h4>
              </div>
            </div>
            <div className="actividad_usuario">
              <div className="img_actividad_usuario">
              </div>
              <div className="detalles_actividad_usuario">
                <h3 className="nombre_actividad_usuario posicion_h">
                  Santiago Rodriguez Rodriguez
                </h3>
                <h4 className="pais_actividad_usuario texto_h">
                  Brazil
                </h4>
              </div>
              <div className="tiempo_actividad_usuario">
                <h4 className="tiempo_usuario texto_h">
                  45 publicaciones
                </h4>
              </div>
            </div>
            <div className="actividad_usuario">
              <div className="img_actividad_usuario">
              </div>
              <div className="detalles_actividad_usuario">
                <h3 className="nombre_actividad_usuario posicion_h">
                  SantiArt
                </h3>
                <h4 className="pais_actividad_usuario texto_h">
                  chile
                </h4>
              </div>
              <div className="tiempo_actividad_usuario">
                <h4 className="tiempo_usuario texto_h">
                  42 publicaciones
                </h4>
              </div>
            </div>
            <div className="actividad_usuario">
              <div className="img_actividad_usuario">
              </div>
              <div className="detalles_actividad_usuario">
                <h3 className="nombre_actividad_usuario posicion_h">
                  Jull Mendez Barbosa
                </h3>
                <h4 className="pais_actividad_usuario texto_h">
                  Colombia
                </h4>
              </div>
              <div className="tiempo_actividad_usuario texto_h">
                <h4 className="tiempo_usuario">
                  28 publicaciones
                </h4>
              </div>
            </div>
            <div className="actividad_usuario">
              <div className="img_actividad_usuario">
              </div>
              <div className="detalles_actividad_usuario">
                <h3 className="nombre_actividad_usuario posicion_h">
                  Laura Fernandez Figueroa
                </h3>
                <h4 className="pais_actividad_usuario texto_h">
                  Argentina
                </h4>
              </div>
              <div className="tiempo_actividad_usuario ">
                <h4 className="tiempo_usuario texto_h">
                  31 publicaciones
                </h4>
              </div>
            </div>
            <div className="actividad_usuario">
              <div className="img_actividad_usuario">
              </div>
              <div className="detalles_actividad_usuario">
                <h3 className="nombre_actividad_usuario posicion_h">
                  Sandra Figueroa
                </h3>
                <h4 className="pais_actividad_usuario texto_h">
                  Mexico
                </h4>
              </div>
              <div className="tiempo_actividad_usuario">
                <h4 className="tiempo_usuario texto_h">
                  12 publicaciones
                </h4>
              </div>
            </div>
            <div className="actividad_usuario">
              <div className="img_actividad_usuario">
              </div>
              <div className="detalles_actividad_usuario">
                <h3 className="nombre_actividad_usuario posicion_h">
                  Laura Acuña
                </h3>
                <h4 className="pais_actividad_usuario texto_h">
                  Chile
                </h4>
              </div>
              <div className="tiempo_actividad_usuario">
                <h4 className="tiempo_usuario texto_h">
                  34 publicaciones
                </h4>
              </div>
            </div>
            <div className="actividad_usuario">
              <div className="img_actividad_usuario">
              </div>
              <div className="detalles_actividad_usuario">
                <h3 className="nombre_actividad_usuario posicion_h">
                  Adriana Sandobal
                </h3>
                <h4 className="pais_actividad_usuario texto_h">
                  Argentina
                </h4>
              </div>
              <div className="tiempo_actividad_usuario">
                <h4 className="tiempo_usuario texto_h">
                  22 publicaciones
                </h4>
              </div>
            </div>
            <hr className="linea" />
          </div>
          <div className="home_columnas home_columnas_5c">
            {/*?php for ($i = 1; $i <= 5; $i++): ?*/}
            <div className="columnas columna<?php echo $i; ?>">
              <div className="tarjetas">
                <div id="grupo_<?php echo $i; ?>">
                  {/*?php foreach ($agrupados_5[$i] as $publicacion): ?*/}
                  <div className="tarjeta">
                    <img src="<?php echo $publicacion['Img_publicacion']; ?>" alt onclick="mostrar(<?php echo $publicacion['ID_publicacion']; ?>)" />
                  </div>
                  {/*?php endforeach; ?*/}
                </div>
              </div>
            </div>
            {/*?php endfor; ?*/}
          </div>
          <div className="home_columnas home_columnas_4c">
            {/*?php for ($i = 1; $i <= 4; $i++): ?*/}
            <div className="columnas columna<?php echo $i; ?>">
              <div className="tarjetas">
                <div id="grupo_<?php echo $i; ?>">
                  {/*?php foreach ($agrupados_4[$i] as $publicacion): ?*/}
                  <div className="tarjeta">
                    <img src="<?php echo $publicacion['Img_publicacion']; ?>" alt onclick="mostrar(<?php echo $publicacion['ID_publicacion']; ?>)" />
                  </div>
                  {/*?php endforeach; ?*/}
                </div>
              </div>
            </div>
            {/*?php endfor; ?*/}
          </div>
          <div className="home_columnas home_columnas_3c">
            {/*?php for ($i = 1; $i <= 3; $i++): ?*/}
            <div className="columnas columna<?php echo $i; ?>">
              <div className="tarjetas">
                <div id="grupo_<?php echo $i; ?>">
                  {/*?php foreach ($agrupados_3[$i] as $publicacion): ?*/}
                  <div className="tarjeta">
                    <img src="<?php echo $publicacion['Img_publicacion']; ?>" alt onclick="mostrar(<?php echo $publicacion['ID_publicacion']; ?>)" />
                  </div>
                  {/*?php endforeach; ?*/}
                </div>
              </div>
            </div>
            {/*?php endfor; ?*/}
          </div>
          <div className="home_columnas home_columnas_2c">
            {/*?php for ($i = 1; $i <= 2; $i++): ?*/}
            <div className="columnas columna<?php echo $i; ?>">
              <div className="tarjetas">
                <div id="grupo_<?php echo $i; ?>">
                  {/*?php foreach ($agrupados_2[$i] as $publicacion): ?*/}
                  <div className="tarjeta">
                    <img src="<?php echo $publicacion['Img_publicacion']; ?>" alt onclick="mostrar(<?php echo $publicacion['ID_publicacion']; ?>)" />
                  </div>
                  {/*?php endforeach; ?*/}
                </div>
              </div>
            </div>
            {/*?php endfor; ?*/}
          </div>
          <div className="home_columnas home_columnas_1c">
            {/*?php for ($i = 1; $i <= 1; $i++): ?*/}
            <div className="columnas columna<?php echo $i; ?>">
              <div className="tarjetas">
                <div id="grupo_<?php echo $i; ?>">
                  {/*?php foreach ($agrupados_1[$i] as $publicacion): ?*/}
                  <div className="tarjeta">
                    <img src="<?php echo $publicacion['Img_publicacion']; ?>" alt onclick="mostrar(<?php echo $publicacion['ID_publicacion']; ?>)" />
                  </div>
                  {/*?php endforeach; ?*/}
                </div>
              </div>
            </div>
            {/*?php endfor; ?*/}
          </div>
        </div>
      </div>
    </section>
  </div>
  <div className="contenedor_detalles" id="contenedor_detalles" onclick="nomostrar()">
    <div className="tarjeta_detalles" onclick="event.stopPropagation();">
      <div className="first_part_detalles">
        <div className="half half-left">
          <div className="img_descripcion">
            <img src alt id="miImagen" />
          </div>
          <div className="buton_img">
            <button className="botones_imagen">
              Descargar
            </button>
            <button className="botones_imagen">
              Compartir
            </button>
          </div>
          <div className="contenedor_part_detalles_img">
            <div className="half half-left detall">
              <div className="div_detall">
                <p className="tittel_descrip">Resolucion</p>
                <p className="text_descrip" id="resolucionImagen" />
              </div>
              <div className="div_detall">
                <p className="tittel_descrip">Derechos de Autor</p>
                <p className="text_descrip">Ningunor</p>
              </div>
            </div>
            <div className="half half-right detall">
              <div className="div_detall">
                <p className="tittel_descrip">Creado</p>
                <p className="text_descrip" id="fechaCreacion" />
              </div>
              <div className="div_detall">
                <p className="tittel_descrip">Adicionales</p>
                <p className="text_descrip">Tecnicas, pinturas, etc.</p>
              </div>
            </div>
          </div>
        </div>
        <div className="half half-right">
          <div className="buton_cerrar">
            <a href="seccions/page_user/page_user.html" className="direccion_user texto">
              <div className="icon_user_detalles">
                <img src="img/fotos_usuario/personas-arrogantes-wide.jpg" alt />
                <p id="userName" />
              </div>
            </a>
            <div className="icon_saves">
              <i className="fa-regular fa-bookmark iconos" />
            </div>
            <button className="boton_tarjeta" onclick="nomostrar()">
              X
            </button>
          </div>
          <div className="tittle_descripcion">
            <h2 id="tituloPublicacion">
              Titulo Publicacion
            </h2>
            <hr />
          </div>
          <div className="scrool_detalles">
            <div className="descripcion_card">
              <h3 className='posicion_h'>
                Descripcion de la Publicacion
              </h3>
              <div className="container_description">
                <div className="descripcion_tarjeta_texto">
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
                <div className="categorias_descripcion">
                  <button>Realismo</button>
                  <button>paisaje</button>
                  <button>fotografia</button>
                </div>
              </div>
            </div>
            <div className="detales_card">
              <div className="container_description container_comentarios">
                <div className="titulo_comentarios">
                  <h2>Comentarios</h2>
                  <i className="fa-solid fa-angle-down iconos" />
                </div>
                <div className="categorias_descripcion">
                  <div className="tarjeta_comentarios">
                    <div className="icon_comentario">
                      <img src="img/fotos_usuario/personas-arrogantes-wide.jpg" alt />
                    </div>
                    <div className="contenedor_contenido_reaccion">
                      <div className="conenido_comentario">
                        <a href="seccions/page_user/page_user.html" className="direccion_user texto">
                          <div className="titulo_nombre_comentario">
                            <h3 className='posicion_h'>Carolina</h3>
                          </div>
                        </a>
                        <div className="texto_contenido_comentario">
                          <h3 className='posicion_h'>Hermosa la imagen asdas asd asd as asda asdsadasd </h3>
                        </div>
                      </div>
                      <div className="detalles_comentario">
                        <p>6 meses</p>
                        <p className="texto_centro_comentario">Responder</p>
                        <i className="fa-regular fa-heart iconos" />
                        <i className="fa-solid fa-bug icono_reporte iconos">
                          <span className="texto_reaccion reporte_comentario">
                            Reportar comentario
                          </span>
                        </i>
                      </div>
                    </div>
                  </div>
                  <div className="tarjeta_comentarios">
                    <div className="icon_comentario">
                      <img src={persoar} alt />
                    </div>
                    <div className="contenedor_contenido_reaccion">
                      <div className="conenido_comentario">
                        <a href="seccions/page_user/page_user.html" className="direccion_user texto">
                          <div className="titulo_nombre_comentario">
                            <h3 className='posicion_h'>Carolina</h3>
                          </div>
                        </a>
                        <div className="texto_contenido_comentario">
                          <h3 className='posicion_h'>Hermosa la imagen asdas asd asd as asda asdsadasd </h3>
                        </div>
                      </div>
                      <div className="detalles_comentario">
                        <p>6 meses</p>
                        <p className="texto_centro_comentario">Responder</p>
                        <i className="fa-regular fa-heart iconos" />
                        <i className="fa-solid fa-bug icono_reporte iconos">
                          <span className="texto_reaccion reporte_comentario">
                            Reportar comentario
                          </span>
                        </i>
                      </div>
                    </div>
                  </div>
                  <div className="tarjeta_comentarios">
                    <div className="icon_comentario">
                      <img src="img/fotos_usuario/personas-arrogantes-wide.jpg" alt />
                    </div>
                    <div className="contenedor_contenido_reaccion">
                      <div className="conenido_comentario">
                        <a href="seccions/page_user/page_user.html" className="direccion_user texto">
                          <div className="titulo_nombre_comentario">
                            <h3 className='posicion_h'>Carolina</h3>
                          </div>
                        </a>
                        <div className="texto_contenido_comentario">
                          <h3 className='posicion_h'>Hermosa la imagen asdas asd asd as asda asdsadasd </h3>
                        </div>
                      </div>
                      <div className="detalles_comentario">
                        <p>6 meses</p>
                        <p className="texto_centro_comentario">Responder</p>
                        <i className="fa-regular fa-heart iconos" />
                        <i className="fa-solid fa-bug icono_reporte iconos">
                          <span className="texto_reaccion reporte_comentario">
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
          <div className="publicacion_comentarios">
            <div className="primera_publicacion">
              <div className="left_publicacion">
                <h2># Comentarios</h2>
              </div>
              <div className="right_publicacion">
                <i className="fa-solid fa-heart iconos" />
                <i className="fa-solid fa-thumbs-up iconos" />
                <i className="fa-solid fa-thumbs-down iconos" />
                <h3 className='posicion_h'>75</h3>
              </div>
              <div className="boton_reaccion_publicacion" id="boton_publicacion_reaccion">
                <i className="fa-regular fa-heart" />
                <span className="texto_reaccion">
                  Reaccionar
                </span>
                <span className="tooltip" id="tooltip">
                  <i className="fa-solid fa-thumbs-up iconos" />
                  <i className="fa-solid fa-heart iconos" />
                  <i className="fa-solid fa-thumbs-down iconos" />
                </span>
              </div>
            </div>
            <div className="segunda_publicacion">
              <div className="icon_comentario">
                <img src="img/fotos_usuario/personas-arrogantes-wide.jpg" alt />
              </div>
              <form action="#" method="POST">
                <input type="text" className="input_publicar_comentario" placeholder="Añade un comentario" />
                <button type="submit" className="boton_enviar_comentario">
                  <i className="fa-solid fa-paper-plane iconos" />
                </button>
              </form>
            </div>
          </div>
        </div>
      </div>
      <div className="second_part_detalles">
        <div className="contenedor_part_detalles">
          <div className="buton_cerrar texto_detalles_mas">
            <div className="icon_user_detalles texto_related">
              <h1>Imagenes Relacionadas</h1>
            </div>
            <button className="boton_tarjeta boton_ver_mas">
              Ver Mas
            </button>
          </div>
          <div className="fila_detalles">
            <div className="celda_detalles"><img src="img/publicaciones/img10.jpg" alt="Imagen 1" /></div>
            <div className="celda_detalles"><img src="img/publicaciones/img1.jpg" alt="Imagen 2" /></div>
            <div className="celda_detalles"><img src="img/publicaciones/img2.jpg" alt="Imagen 3" /></div>
            <div className="celda_detalles"><img src="img/publicaciones/img3.jpg" alt="Imagen 4" /></div>
          </div>
          <div className="fila_detalles">
            <div className="celda_detalles"><img src="img/publicaciones/img10.jpg" alt="Imagen 1" /></div>
            <div className="celda_detalles"><img src="img/publicaciones/img1.jpg" alt="Imagen 2" /></div>
            <div className="celda_detalles"><img src="img/publicaciones/img2.jpg" alt="Imagen 3" /></div>
            <div className="celda_detalles"><img src="img/publicaciones/img3.jpg" alt="Imagen 4" /></div>
          </div>
          <div className="fila_detalles">
            <div className="celda_detalles"><img src="img/publicaciones/img10.jpg" alt="Imagen 1" /></div>
            <div className="celda_detalles"><img src="img/publicaciones/img1.jpg" alt="Imagen 2" /></div>
            <div className="celda_detalles"><img src="img/publicaciones/img2.jpg" alt="Imagen 3" /></div>
            <div className="celda_detalles"><img src="img/publicaciones/img3.jpg" alt="Imagen 4" /></div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div className="contenedor_detalles contenedor_new_publicacion" id="contenedor_new_publicacion" onclick="verificarYOcultar()">
    <div className="tarjeta_detalles tarjeta_subir_publicacion" onclick="event.stopPropagation();">
      <div className="first_part_detalles">
        <div className="half half-left">
          <div className="contenedor_subir_publicacion" id="contenedor_subir_publicacion">
            <div className="estilo_input_archivo">
              <div className="contenedor_primeras_partes_publicando">
                <div className="centro_input_archivo" id="centro_input_archivo">
                  <div className="icono_upload_input">
                    <i className="fa-solid fa-cloud-arrow-up iconos" />
                  </div>
                  <div className="abajo_icon_input">
                    <p>Elige un archivo o arrástralo y suéltalo aquí</p>
                  </div>
                </div>
                <div className="info_input_archivo" id="info_input_archivo">
                  <div>
                    <p>Se recomiendan archivos tipo .jpg menor a 20MB o archivos .mp4 que pesen menos de 200MB</p>
                  </div>
                </div>
              </div>
              <input className="input_subir_archivo" id="input_subir_archivo" type="file" accept=".jpg,.jpeg,.png,.mp4,.mov,.avi" />
              <img className="img_subir_archivo" id="img_subir_archivo" src="/img/publicaciones/img10.jpg" alt style={{display: 'none'}} />
              <div className="close_img_archivo" id="close_img_archivo" style={{display: 'none'}}>
                <i className="fa-regular fa-circle-xmark iconos" />
              </div>
            </div>
          </div>
        </div>
        <div className="half half-right parte_derecha_new_publicacion">
          <div className="parte_cerrar_publicacion">
            <div>
              <button className="boton_tarjeta" onclick="nomostrar_publicar()">
                X
              </button>
            </div>
          </div>
          <div className="informacion_new_publicacion">
            <div className="titulo_new_publicacion">
              <p>
                Titulo
              </p>
              <input className="input_nueva_publicacion" type="text" maxLength={58} placeholder="Añade un titulo" />
            </div>
            <div className="descripcion_new_publicacion">
              <p>
                Descripcion
              </p>
              <textarea className="input_nueva_publicacion" maxLength={160} type="text" placeholder="Añade una descripcion detallada" defaultValue={""} />
            </div>
            <div className="tecnicas_new_publicacion">
              <p>Tecnicas utilizadas</p>
              <textarea className="input_nueva_publicacion input_descripcion_publicacion" type="text" placeholder="Añade tecnicas utilizadas" defaultValue={""} />
            </div>
            <div className="half half-left izquierdo_izquierdo_publicacion">
              <div className="permitir_comentarios_new_publicacion">
                <p>
                  Permitir comentarios
                </p>
                <div className="toggle-button-cover boton_desplazable">
                  <div className="button r" id="button-3">
                    <input type="checkbox" className="checkbox" />
                    <div className="knobs" />
                    <div className="layer" />
                  </div>
                </div>
              </div>
            </div>
            <div className="half half-right derecho_derecho_publicacion">
              <div className="derechos_autor_new_publicacion">
                <p>
                  Derechos de autor
                </p>
                <div className="toggle-button-cover boton_desplazable">
                  <div className="button r" id="button-3">
                    <input type="checkbox" className="checkbox" />
                    <div className="knobs" />
                    <div className="layer" />
                  </div>
                </div>
              </div>
            </div>
            <div className="categoria_new_publicacion">
              <button className="boton_mostrar_categorias_publicacion" onclick="mostrar_publicar_categoria()">
                Seleccionar una o varias categorias
              </button>
            </div>
          </div>
        </div>
      </div>
      <div className="fondo_borroso" id="fondo_borroso" onclick="verificarYOcultar()">
        <div className="seleccionar_categorias_new_publicacion" id="seleccionar_categorias_new_publicacion" onclick="event.stopPropagation();">
          <div className="close_select_categoria_publicacion">
            <i className="fa-regular fa-circle-xmark iconos" onclick="nomostrar_publicar_categoria()" />
          </div>
          <div className="contenido_seleccionar_categoria">
            <select name="language" className="custom-select" multiple>
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
  <div className="contenedor_detalles " id="contenedor_ajustes" onclick="nomostrar_ajustes()">
    <div className="tarjeta_detalles tarjeta_settings detalles_home" onclick="event.stopPropagation();">
      <div className="tittle_settings">
        <div className="parte_left_tittle_ajustes">
          <i className="fa-solid fa-gear icono_settings_set iconos" />
          <h2 className="titulo_ajustes">
            AJUSTES
          </h2>
        </div>
        <div className="parte_right_tittle_ajustes">
          <button className="boton_tarjeta" onclick="nomostrar_ajustes()">
            X
          </button>
        </div>
      </div>
      <div className="ajustes_cuenta">
        <div className="tittle_detalles_cuenta">
          <i className="fa-regular fa-user icono_user_setting iconos" />
          <h2 className="titulo_detalles_cuenta">
            Cuenta
          </h2>
        </div>
        <hr className="linea_separadora_ajustes" />
        <div className="contenid_ajustes_cuenta">
          <div className="contenido_editar_perfil">
            <div className="texto_contenido_editar_perfil">
              <p className="texto_ajustes_cuenta">
                Editar Perfil
              </p>
            </div>
            <div className="flecha_editar_perfil">
              <i className="fa-solid fa-greater-than iconos" />
            </div>
          </div>
          <div className="contenido_editar_perfil">
            <div className="texto_contenido_editar_perfil">
              <p className="texto_ajustes_cuenta">
                Cambiar Contraseña
              </p>
            </div>
            <div className="flecha_editar_perfil">
              <i className="fa-solid fa-greater-than iconos" />
            </div>
          </div>
          <div className="contenido_editar_perfil">
            <div className="texto_contenido_editar_perfil">
              <p className="texto_ajustes_cuenta">
                Tus preferencias
              </p>
            </div>
            <div className="flecha_editar_perfil">
              <i className="fa-solid fa-greater-than iconos" />
            </div>
          </div>
        </div>
      </div>
      <div className="ajustes_cuenta">
        <div className="tittle_detalles_cuenta">
          <i className="fa-regular fa-bell iconos" />
          <h2 className="titulo_detalles_cuenta">
            NOTIFICACIONES
          </h2>
        </div>
        <hr className="linea_separadora_ajustes" />
        <div className="contenido_ajustes_cuenta">
          <div className="contenido_editar_perfil">
            <div className="texto_contenido_editar_perfil">
              <p className="texto_ajustes_cuenta">
                Mostrar Notificaciones
              </p>
            </div>
            <div className="toglle_notifications">
              <label className="toggle-switch">
                <input type="checkbox" />
                <div className="toggle-switch-background">
                  <div className="toggle-switch-handle" />
                </div>
              </label>
            </div>
          </div>
        </div>
      </div>
      <div className="ajustes_cuenta">
        <div className="tittle_detalles_cuenta">
          <i className="fa-regular fa-bell iconos" />
          <h2 className="titulo_detalles_cuenta">
            OTROS AJUSTES
          </h2>
        </div>
        <hr className="linea_separadora_ajustes" />
        <div className="contenido_ajustes_cuenta contenedor_idiomas">
          <div className="contenido_editar_perfil">
            <div className="ajustes_lenguajes">
              <button className="cssbuttons-io-button">
                Cambiar Lenguaje
                <div className="icon" id="chose_language" onclick="mostrar_ajustes_lenguaje()">
                  <svg height={24} width={24} viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path d="M0 0h24v24H0z" fill="none" />
                    <path d="M16.172 11l-5.364-5.364 1.414-1.414L20 12l-7.778 7.778-1.414-1.414L16.172 13H4v-2z" fill="currentColor" />
                  </svg>
                </div>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div className="contenedor_detalles contenedor_detalles_ajustes" id="contenedor_ajustes_2" onclick="verificarYOcultar_detalles()">
    <div className="tarjeta_detalles tarjeta_settings contenedor_ajustes_id_detale" id="contenedor_ajustes_id_detale" onclick="event.stopPropagation();">
      <div className="contenido_detalles_lenguaje">
        <div className="tittle_settings">
          <div className="parte_left_tittle_ajustes">
            <i className="icono_cambio_lenguaje fa-solid fa-earth-americas iconos" />
            <h2 className="titulo_ajustes">
              Cambiar Lenguaje
            </h2>
          </div>
          <div className="parte_right_tittle_ajustes">
            <button className="boton_tarjeta" onclick="nomostrar_ajustes_lenguaje()">
              X
            </button>
          </div>
        </div>
        <div className="band_settings">
          <div className="uband banderas" id="language_english" onclick="cambiarIdioma('en')">
            <img src="img/banderas/band_eeuu.png" alt />
            <h3 className='posicion_h'>
              ENGLISH
            </h3>
          </div>
          <div className="banderas">
            <img src="img/banderas/band_spain.png" />
            <h3 className='posicion_h'>
              ESPAÑOL
            </h3>
          </div>
          <div className="banderas">
            <img src="img/banderas/band_portugal.png" alt />
            <h3 className='posicion_h'>
              PORTUGUES
            </h3>
          </div>
          <div className="banderas">
            <img src="img/banderas/band_francia.png" alt />
            <h3 className='posicion_h'>
              FRANCES
            </h3>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div id="google_translate_element" style={{display: 'none'}} />
</div>
  );
};

export default Home;