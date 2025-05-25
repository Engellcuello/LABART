import React, { useState, useEffect, useRef } from 'react';
import axios from '../../utils/axiosintance';
import Swal from 'sweetalert2';

const PublicacionGuardadaModal = ({ mostrar, onClose, publicacion }) => {
  const [comentarios, setComentarios] = useState([]);
  const [categorias, setCategorias] = useState([]);
  const [detallesPublicacion, setDetallesPublicacion] = useState(null);
  const [guardada, setGuardada] = useState(false);
  const [nuevoComentario, setNuevoComentario] = useState('');
  const [ImgUsuario, setImgUsuario] = useState("");
  const [reaccionUsuario, setReaccionUsuario] = useState(null);
  const [contadorReacciones, setContadorReacciones] = useState({
    meGusta: 0,
    meEncanta: 0,
    meDesagrada: 0,
    total: 0
  });
  const [publicacionesRecomendadas, setPublicacionesRecomendadas] = useState([]);
  
  const contenedorSavesRef = useRef(null);
  const resolucionImagenRef = useRef(null);

  // Obtener imagen de usuario del localStorage
  useEffect(() => {
    const Img_usuario = localStorage.getItem("Img_usuario");
    setImgUsuario(Img_usuario);
  }, []);

  // Cargar datos cuando se muestra el modal
  useEffect(() => {
    if (mostrar && publicacion) {
      mostrarPublicacionGuardada(publicacion);
    }
  }, [mostrar, publicacion]);

  const calcularResolucionImagen = (imagenUrl) => {
    const imagen = new Image();
    imagen.src = imagenUrl;
    imagen.onload = function() {
      if (resolucionImagenRef.current) {
        resolucionImagenRef.current.textContent = `${imagen.width}px x ${imagen.height}px`;
      }
    };
  };

  const formatRelativeTime = (dateString) => {
    const date = new Date(dateString);
    const now = new Date();
    const diffInSeconds = Math.floor((now - date) / 1000);

    const minute = 60;
    const hour = minute * 60;
    const day = hour * 24;
    const month = day * 30;
    const year = day * 365;

    if (diffInSeconds < minute) return 'hace unos segundos';
    if (diffInSeconds < hour) {
      const minutes = Math.floor(diffInSeconds / minute);
      return `hace ${minutes} minuto${minutes !== 1 ? 's' : ''}`;
    }
    if (diffInSeconds < day) {
      const hours = Math.floor(diffInSeconds / hour);
      return `hace ${hours} hora${hours !== 1 ? 's' : ''}`;
    }
    if (diffInSeconds < month) {
      const days = Math.floor(diffInSeconds / day);
      return `hace ${days} día${days !== 1 ? 's' : ''}`;
    }
    if (diffInSeconds < year) {
      const months = Math.floor(diffInSeconds / month);
      return `hace ${months} mes${months !== 1 ? 'es' : ''}`;
    }
    const years = Math.floor(diffInSeconds / year);
    return `hace ${years} año${years !== 1 ? 's' : ''}`;
  };

  const descargarImagen = async (url) => {
    if (!url) return;

    try {
      const response = await fetch(url);
      const blob = await response.blob();
      const blobUrl = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = blobUrl;
      link.download = url.split('/').pop();
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(blobUrl);
    } catch (error) {
      console.error('Error al descargar la imagen:', error);
    }
  };

  const cargarRecomendaciones = (idPublicacion) => {
    axios.get(`http://127.0.0.1:5000/recomendaciones/publicacion/${idPublicacion}`)
      .then((response) => {
        setPublicacionesRecomendadas(response.data);
      })
      .catch((error) => {
        console.error('Error al cargar recomendaciones:', error);
      });
  };

  const cargarReacciones = async (idPublicacion) => {
    try {
     
      const response = await axios.get('http://127.0.0.1:5000/publicacion_reaccion');
      const reaccionesPublicacion = response.data.filter(
        r => r.ID_publicacion == idPublicacion
      );
  
      const contadores = {
        meGusta: reaccionesPublicacion.filter(r => r.ID_reaccion === 1).length,
        meEncanta: reaccionesPublicacion.filter(r => r.ID_reaccion === 2).length,
        meDesagrada: reaccionesPublicacion.filter(r => r.ID_reaccion === 3).length,
        total: reaccionesPublicacion.length
      };
  
      setContadorReacciones(contadores);
  
      const usuarioActual = localStorage.getItem('ID_usuario');
      if (usuarioActual) {
        const usuarioReacciones = await axios.get('http://127.0.0.1:5000/usuario_reaccion');
  
        const miReaccion = usuarioReacciones.data.find(
          r => r.ID_usuario == usuarioActual && r.ID_publicacion == idPublicacion
        );
  
        if (miReaccion) {
          setReaccionUsuario(miReaccion.ID_reaccion);
        } else {
          setReaccionUsuario(null);
        }
      }
    } catch (error) {
      console.error('Error cargando reacciones:', error);
    }
  };

  const manejarReaccion = async (idReaccion) => {
    try {
      const usuarioActual = localStorage.getItem('ID_usuario');
      if (!usuarioActual) {
        alert('Debes iniciar sesión para reaccionar');
        return;
      }

      // Si ya tiene esta reacción, la quitamos
      if (reaccionUsuario === idReaccion) {
        await quitarReaccion();
        return;
      }

      // Primero quitamos cualquier reacción existente
      if (reaccionUsuario) {
        await quitarReaccion();
      }

      // Creamos la nueva reacción en publicacion_reaccion
      const response = await axios.post('http://127.0.0.1:5000/publicacion_reaccion', {
        ID_publicacion: publicacion.ID_publicacion,
        ID_reaccion: idReaccion,
        ID_usuario: usuarioActual
      });

      // Luego la vinculamos al usuario en usuario_reaccion
      // CAMBIO IMPORTANTE: Enviamos solo ID_usuario y ID_reaccion
      await axios.post('http://127.0.0.1:5000/usuario_reaccion', {
        ID_usuario: usuarioActual,
        ID_publicacion : publicacion.ID_publicacion,
        ID_reaccion: idReaccion  // Enviamos directamente el ID de reacción
      });

      setReaccionUsuario(idReaccion);
      actualizarContador(idReaccion, true);

    } catch (error) {
      console.error('Error al reaccionar:', error);
    }
  };

  const quitarReaccion = async () => {
    try {
      const usuarioActual = localStorage.getItem('ID_usuario');
      if (!usuarioActual || !reaccionUsuario) return;

      // Buscamos la reacción del usuario para esta publicación
      const usuarioReaccion = await axios.get(`http://127.0.0.1:5000/usuario_reaccion`);
      const miReaccion = usuarioReaccion.data.find(
        ur => ur.ID_usuario == usuarioActual && ur.ID_reaccion == reaccionUsuario
      );

      if (miReaccion) {
        // Eliminamos la entrada en usuario_reaccion
        await axios.delete(`http://127.0.0.1:5000/usuario_reaccion/${miReaccion.ID_usuario_reaccion}`);

        // Buscamos y eliminamos la correspondiente entrada en publicacion_reaccion
        const publicacionReacciones = await axios.get(`http://127.0.0.1:5000/publicacion_reaccion`);
        const reaccionPublicacion = publicacionReacciones.data.find(
          pr => pr.ID_publicacion == publicacion.ID_publicacion && pr.ID_reaccion == reaccionUsuario
        );

        if (reaccionPublicacion) {
          await axios.delete(`http://127.0.0.1:5000/publicacion_reaccion/${reaccionPublicacion.ID_publicacion_reaccion}`);
        }

        setReaccionUsuario(null);
        actualizarContador(reaccionUsuario, false);
      }
    } catch (error) {
      console.error('Error al quitar reacción:', error);
    }
  };


  const actualizarContador = (idReaccion, agregar) => {
    setContadorReacciones(prev => {
      const nuevosContadores = { ...prev };

      switch (idReaccion) {
        case 1:
          nuevosContadores.meGusta += agregar ? 1 : -1;
          break;
        case 2:
          nuevosContadores.meEncanta += agregar ? 1 : -1;
          break;
        case 3:
          nuevosContadores.meDesagrada += agregar ? 1 : -1;
          break;
      }

      nuevosContadores.total += agregar ? 1 : -1;
      return nuevosContadores;
    });
  };

  const handleSubmitComentario = async (e) => {
    e.preventDefault();

    if (!nuevoComentario.trim()) {
      alert('El comentario no puede estar vacío');
      return;
    }

    const ID_usuario = localStorage.getItem('ID_usuario');
    if (!ID_usuario) {
      alert('Debes iniciar sesión para comentar');
      return;
    }

    try {
      const response = await axios.post('http://127.0.0.1:5000/comentario', {
        Contenido_comentario: nuevoComentario,
        ID_usuario: parseInt(ID_usuario),
        ID_publicacion: parseInt(publicacion.ID_publicacion)
      });

      const userResponse = await axios.get(`http://127.0.0.1:5000/usuario/${ID_usuario}`);

      const comentarioCompleto = {
        ...response.data,
        usuario: {
          Nombre_usuario: userResponse.data.Nombre_usuario,
          Img_usuario: userResponse.data.Img_usuario,
          ID_usuario: userResponse.data.ID_usuario
        }
      };

      setComentarios(prev => [comentarioCompleto, ...prev]);
      setNuevoComentario('');
    } catch (error) {
      console.error('Error al enviar comentario:', error);
      alert('Error al enviar el comentario');
    }
  };

  const eliminarComentario = async (idComentario) => {
    const confirmacion = await Swal.fire({
      title: '¿Estás seguro?',
      text: "No podrás revertir esta acción",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Sí, eliminar'
    });

    if (!confirmacion.isConfirmed) return;

    try {
      await axios.delete(`http://127.0.0.1:5000/comentario/${idComentario}`);
      setComentarios(prev => prev.filter(c => c.ID_comentario !== idComentario));
    } catch (error) {
      console.error('Error al eliminar comentario:', error);
      Swal.fire('Error', 'No se pudo eliminar el comentario', 'error');
    }
  };

  const agregarGuardada = async () => {
    try {
      const usuarioId = localStorage.getItem('ID_usuario');
      await axios.post(`http://127.0.0.1:5000/publicacion_guardada`, {
        ID_usuario: usuarioId,
        ID_publicacion: detallesPublicacion.id_original
      });
      setGuardada(true);
      window.location.reload();
    } catch (error) {
      console.error('Error guardando publicación:', error);
    }
  };

  const quitarGuardada = async () => {
    try {
      const usuarioId = localStorage.getItem('ID_usuario');
      const idPublicacion = detallesPublicacion.id_original;

      const response = await axios.get('http://127.0.0.1:5000/publicacion_guardada');
      const guardada = response.data.find(
        item => item.ID_usuario === parseInt(usuarioId) && item.ID_publicacion === idPublicacion
      );

      if (guardada) {
        await axios.delete(`http://127.0.0.1:5000/publicacion_guardada/${guardada.ID_publicacion_guardada}`);
        window.location.reload();
        setGuardada(false);
      }
    } catch (error) {
      console.error('Error quitando publicación guardada:', error);
    }
  };

  const handleClickRecomendada = (idPublicacionRecomendada) => {
    mostrarPublicacionGuardada({ ID_publicacion: idPublicacionRecomendada });
  };

  const mostrarPublicacionGuardada = (publicacion) => {
    if (!publicacion?.ID_publicacion) {
      console.error("Publicación guardada no tiene ID:", publicacion);
      return;
    }

    setComentarios([]);
    setCategorias([]);

    if (contenedorSavesRef.current) {
      contenedorSavesRef.current.style.display = 'flex';
    }

    axios.get(`http://127.0.0.1:5000/publicacion/${publicacion.ID_publicacion}`)
      .then((response) => {
        const publicacionData = response.data;
        setDetallesPublicacion({
          ...publicacionData,
          id_original: publicacion.ID_publicacion,
          esGuardada: true
        });

        calcularResolucionImagen(publicacionData.Img_publicacion);
        cargarReacciones(publicacion.ID_publicacion);
        cargarRecomendaciones(publicacion.ID_publicacion);

        axios.get(`http://127.0.0.1:5000/usuario/${publicacionData.ID_usuario}`)
          .then((userResponse) => {
            setDetallesPublicacion(prev => ({
              ...prev,
              usuario: {
                ID_usuario: userResponse.data.ID_usuario,
                Nombre_usuario: userResponse.data.Nombre_usuario,
                Img_usuario: userResponse.data.Img_usuario
              }
            }));
          })
          .catch(console.error);

        axios.get(`http://127.0.0.1:5000/publicaciones/${publicacion.ID_publicacion}/categorias`)
          .then(response => setCategorias(response.data))
          .catch(error => {
            console.error('Error cargando categorías:', error);
            setCategorias([]);
          });

        const usuarioGuardado = localStorage.getItem('ID_usuario');
        if (usuarioGuardado) {
          axios.get(`http://127.0.0.1:5000/publicacion_guardada`)
            .then(response => {
              const estaGuardada = response.data.some(
                pg => pg.ID_usuario == usuarioGuardado && pg.ID_publicacion == publicacion.ID_publicacion
              );
              setGuardada(estaGuardada);
            })
            .catch(error => {
              console.error('Error verificando estado guardado:', error);
              setGuardada(false);
            });
        }

        axios.get(`http://127.0.0.1:5000/comentario`)
          .then(async (response) => {
            const comentariosFiltrados = response.data.filter(
              c => c.ID_publicacion == publicacion.ID_publicacion
            );

            const comentariosConUsuarios = await Promise.all(
              comentariosFiltrados.map(async comentario => {
                try {
                  const userResponse = await axios.get(`http://127.0.0.1:5000/usuario/${comentario.ID_usuario}`);
                  return {
                    ...comentario,
                    usuario: {
                      Nombre_usuario: userResponse.data.Nombre_usuario,
                      Img_usuario: userResponse.data.Img_usuario
                    }
                  };
                } catch (error) {
                  console.error(`Error obteniendo usuario ${comentario.ID_usuario}:`, error);
                  return {
                    ...comentario,
                    usuario: {
                      Nombre_usuario: "Usuario",
                      Img_usuario: "img/default-user.jpg"
                    }
                  };
                }
              })
            );

            setComentarios(comentariosConUsuarios);
          })
          .catch(console.error);
      })
      .catch(console.error);
  };

  if (!mostrar) return null;

  return (
    <div
      className="contenedor_detalles contenedor_saves"
      ref={contenedorSavesRef}
      onClick={onClose}
      style={{ display: 'none' }}
    >
      <div className="tarjeta_detalles" onClick={(e) => e.stopPropagation()}>
        <div className="first_part_detalles">
          <div className="half half-left">
            <div className="img_descripcion">
              <img src={detallesPublicacion?.Img_publicacion || '/img/placeholder.jpg'} alt="Publicación" />
            </div>
            <div className="buton_img">
              <button 
                className="botones_imagen"
                onClick={() => descargarImagen(detallesPublicacion?.Img_publicacion)}
              >
                Descargar
              </button>
              <button className="botones_imagen">
                Compartir
              </button>
            </div>
            <div className="contenedor_part_detalles_img">
              <div className="half half-left detall">
                <div className="div_detall">
                  <p className="tittel_descrip">Resolución</p>
                  <p className="text_descrip" ref={resolucionImagenRef} />
                </div>
                <div className="div_detall">
                  <p className="tittel_descrip">Derechos de Autor</p>
                  <p className="text_descrip">Ninguno</p>
                </div>
              </div>
              <div className="half half-right detall">
                <div className="div_detall">
                  <p className="tittel_descrip">Creado</p>
                  <p className="text_descrip">
                    {detallesPublicacion ? formatRelativeTime(detallesPublicacion.Fecha_Publicacion) : ""}
                  </p>
                </div>
                <div className="div_detall">
                  <p className="tittel_descrip">Adicionales</p>
                  <p className="text_descrip">Técnicas, pinturas, etc.</p>
                </div>
              </div>
            </div>
          </div>
          <div className="half half-right">
            <div className="buton_cerrar">
              <a href={`/perfil_tercero/${detallesPublicacion?.usuario?.ID_usuario}`} className="direccion_user">
                <div className="icon_user_detalles">
                  <img 
                    src={detallesPublicacion?.usuario?.Img_usuario || "/img/fotos_usuario/personas-arrogantes-wide.jpg"} 
                    alt="Usuario" 
                  />
                  <p>{detallesPublicacion?.usuario?.Nombre_usuario || "USER_NAME"}</p>
                </div>
              </a>
              <div className="icon_saves">
                <i 
                  className={`fa-${guardada ? 'solid' : 'regular'} fa-bookmark iconos`} 
                  onClick={guardada ? quitarGuardada : agregarGuardada}
                  style={{ color: guardada ? "#1e90ff" : "#87cefa" }}
                />
              </div>
              <button className="boton_tarjeta" onClick={onClose}>
                X
              </button>
            </div>
            <div className="tittle_descripcion">
              <h2>{detallesPublicacion?.Titulo_publicacion || "Título de publicación"}</h2>
              <hr />
            </div>
            <div className="scrool_detalles">
              <div className="descripcion_card">
                <h3>Descripción de la Publicación</h3>
                <div className="container_description">
                  <div className="descripcion_tarjeta_texto">
                    <p>{detallesPublicacion?.Descripcion_publicacion || "Descripción no disponible"}</p>
                  </div>
                  <div className="categorias_descripcion">
                    {categorias.map((categoria, index) => (
                      <button key={index}>{categoria.Nombre_categoria}</button>
                    ))}
                  </div>
                </div>
              </div>
              <div className="detales_card">
                <div className="container_description container_comentarios">
                  <div className="titulo_comentarios">
                    <h2>Comentarios {comentarios.length}</h2>
                    <i className="fa-solid fa-angle-down" />
                  </div>
                  <div className="categorias_descripcion">
                    {comentarios.map((comentario) => {
                      const ID_usuario_actual = localStorage.getItem('ID_usuario');
                      const esMiComentario = ID_usuario_actual && comentario.ID_usuario == ID_usuario_actual;

                      return (
                        <div className="tarjeta_comentarios" key={comentario.ID_comentario}>
                          <div className="icon_comentario">
                            <img 
                              src={comentario.usuario?.Img_usuario}
                            />
                          </div>
                          <div className="contenedor_contenido_reaccion">
                            <div className="conenido_comentario">
                              <a href={`/perfil_tercero/${comentario.ID_usuario}`} className="direccion_user">
                                <div className="titulo_nombre_comentario">
                                  <h3>{comentario.usuario?.Nombre_usuario || "Usuario"}</h3>
                                </div>
                              </a>
                              <div className="texto_contenido_comentario">
                                <h3>{comentario.Contenido_comentario}</h3>
                              </div>
                            </div>
                            <div className="detalles_comentario">
                              <p>{formatRelativeTime(comentario.Fecha_comentario)}</p>
                              <p className="texto_centro_comentario">Responder</p>
                              <i className="fa-regular fa-heart" />
                              {esMiComentario && (
                                <i
                                  className="fa-solid fa-trash"
                                  onClick={() => eliminarComentario(comentario.ID_comentario)}
                                  style={{ cursor: 'pointer', color: '#ff4d4d' }}
                                  title="Eliminar comentario"
                                />
                              )}
                              <i className="fa-solid fa-bug icono_reporte">
                               <span className="texto_reaccion reporte_comentario" style={{ marginLeft: '-100%' }}>
                                  Reportar comentario
                                </span>
                              </i>
                            </div>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
            </div>
            <div className="publicacion_comentarios">
            <div className="primera_publicacion">
                <div className="left_publicacion">
                  <h2>Comentar</h2>
                </div>
                <div className="right_publicacion">
                  <h3 className='posicion_h'>{contadorReacciones.total}</h3>
                </div>
                <div className="boton_reaccion_publicacion" id="boton_publicacion_reaccion">
                  <i
                    className={`fa-${reaccionUsuario ? 'solid' : 'regular'} fa-heart`}
                    style={{ color: reaccionUsuario ? '#ff4d4d' : '' }}
                  />
                  <div className="tooltip" id="tooltip">
                    <div className="reaccion-item">
                      <i
                        className={`fa-solid fa-thumbs-up iconos ${reaccionUsuario === 1 ? 'reaccion-activa' : ''}`}
                        onClick={() => manejarReaccion(1)}
                      />
                      <span className="contador-reaccion">{contadorReacciones.meGusta}</span>
                    </div>
                    <div className="reaccion-item">
                      <i
                        className={`fa-solid fa-heart iconos ${reaccionUsuario === 2 ? 'reaccion-activa' : ''}`}
                        onClick={() => manejarReaccion(2)}
                      />
                      <span className="contador-reaccion">{contadorReacciones.meEncanta}</span>
                    </div>
                    <div className="reaccion-item">
                      <i
                        className={`fa-solid fa-thumbs-down iconos ${reaccionUsuario === 3 ? 'reaccion-activa' : ''}`}
                        onClick={() => manejarReaccion(3)}
                      />
                      <span className="contador-reaccion">{contadorReacciones.meDesagrada}</span>
                    </div>
                    <div className="reaccion-texto">
                    <span className="texto_reaccion">Reaccionar</span>
                    </div>
                  </div>
                </div>
              </div>
              <div className="segunda_publicacion">
                <div className="icon_comentario">
                  <img src={ImgUsuario} alt="Usuario" />
                </div>
                <form onSubmit={handleSubmitComentario}>
                  <input
                    type="text"
                    className="input_publicar_comentario"
                    placeholder="Añade un comentario"
                    value={nuevoComentario}
                    onChange={(e) => setNuevoComentario(e.target.value)}
                  />
                  <button type="submit" className="boton_enviar_comentario">
                    <i className="fa-solid fa-paper-plane" />
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
                <h1>Imágenes Relacionadas</h1>
              </div>
              <button className="boton_tarjeta boton_ver_mas">
                Ver Más
              </button>
            </div>
            {publicacionesRecomendadas?.recomendaciones?.length > 0 ? (
              <>
                <div className="fila_detalles">
                  {publicacionesRecomendadas.recomendaciones.slice(0, 4).map((publicacion) => (
                    <div
                      className="celda_detalles"
                      key={publicacion.ID_publicacion}
                      onClick={() => handleClickRecomendada(publicacion.ID_publicacion)}
                    >
                      <img
                        src={publicacion.Img_publicacion}
                        alt={`Recomendación ${publicacion.Titulo_publicacion}`}
                        onError={(e) => {
                          e.target.src = 'https://via.placeholder.com/150';
                          e.target.alt = 'Imagen no disponible';
                        }}
                        style={{ width: '100%', height: '100%', objectFit: 'cover', cursor: "pointer" }}
                      />
                    </div>
                  ))}
                </div>
                <div className="fila_detalles">
                  {publicacionesRecomendadas.recomendaciones.slice(4, 8).map((publicacion) => (
                    <div
                      className="celda_detalles"
                      key={publicacion.ID_publicacion}
                      onClick={() => handleClickRecomendada(publicacion.ID_publicacion)}
                    >
                      <img
                        src={publicacion.Img_publicacion}
                        alt={`Recomendación ${publicacion.Titulo_publicacion}`}
                        onError={(e) => {
                          e.target.src = 'https://via.placeholder.com/150';
                          e.target.alt = 'Imagen no disponible';
                        }}
                        style={{ width: '100%', height: '100%', objectFit: 'cover', cursor: "pointer" }}
                      />
                    </div>
                  ))}
                </div>
                <div className="fila_detalles">
                  {publicacionesRecomendadas.recomendaciones.slice(8, 12).map((publicacion) => (
                    <div
                      className="celda_detalles"
                      key={publicacion.ID_publicacion}
                      onClick={() => handleClickRecomendada(publicacion.ID_publicacion)}
                    >
                      <img
                        src={publicacion.Img_publicacion}
                        alt={`Recomendación ${publicacion.Titulo_publicacion}`}
                        onError={(e) => {
                          e.target.src = 'https://via.placeholder.com/150';
                          e.target.alt = 'Imagen no disponible';
                        }}
                        style={{ width: '100%', height: '100%', objectFit: 'cover', cursor: "pointer" }}
                      />
                    </div>
                  ))}
                </div>
              </>
            ) : (
              <div className="fila_detalles">
                <p>No hay imágenes relacionadas disponibles</p>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default PublicacionGuardadaModal;