import React, { useState, useEffect, useRef } from 'react';
import axios from '../../utils/axiosintance';
import Swal from 'sweetalert2';


const ModalDetalles = ({ idPublicacion, onClose, onOpenPropia }) => {
  const [detallesPublicacion, setDetallesPublicacion] = useState(null);
  const [comentarios, setComentarios] = useState([]);
  const [categorias, setCategorias] = useState([]);
  const [guardada, setGuardada] = useState(false);
  const [ImgUsuario, setImgUsuario] = useState("");
  const [publicacionesRecomendadas, setPublicacionesRecomendadas] = useState([]);
  const [nuevoComentario, setNuevoComentario] = useState('');
  const [etiquetas, setEtiquetas] = useState([]);
  const historialRegistradoRef = useRef(null);
  const [cargandoReaccion, setCargandoReaccion] = useState(false);
  const [cargandoComentario, setCargandoComentario] = useState(false);
  const [yaComento, setYaComento] = useState(false);
  const [idPublicacionActual, setIdPublicacionActual] = useState(idPublicacion);


  const [reaccionUsuario, setReaccionUsuario] = useState(null);
  const [contadorReacciones, setContadorReacciones] = useState({
    meGusta: 0,
    meEncanta: 0,
    meDesagrada: 0,
    total: 0
  });

  useEffect(() => {
    const Img_usuario = localStorage.getItem("Img_usuario");
    setImgUsuario(Img_usuario);
  }, []);

  useEffect(() => {
    setIdPublicacionActual(idPublicacion);
  }, [idPublicacion]);


  const registrarHistorial = async (idPublicacion) => {
    try {
      const ID_usuario = localStorage.getItem("ID_usuario");
      if (!ID_usuario) return;

      if (historialRegistradoRef.current === idPublicacion) return;

      historialRegistradoRef.current = idPublicacion;

      await axios.post("/historial", {
        ID_usuario: parseInt(ID_usuario),
        ID_publicacion: parseInt(idPublicacion)
      });
    } catch (error) {
      console.error("Error al registrar historial:", error);
    }
  };


  const cargarEtiquetas = async (idPublicacion) => {
    try {
      setEtiquetas([]);

      const response = await axios.get(`/publicaciones/${idPublicacion}/etiquetas`);

      const etiquetasData = Array.isArray(response.data?.etiquetas)
        ? response.data.etiquetas
        : [];

      setEtiquetas(etiquetasData);
    } catch (error) {
      console.error('Error cargando etiquetas:', error);
      setEtiquetas([]);
    }
  };


  const cargarRecomendaciones = (idPublicacion) => {
    axios.get(`/recomendaciones/publicacion/${idPublicacion}`)
      .then((response) => {
        setPublicacionesRecomendadas(response.data);
      })
      .catch((error) => {
        console.error('Error al cargar recomendaciones:', error);
      });
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

  const formatRelativeTime = (dateString) => {
    const date = new Date(dateString);
    const now = new Date();
    const diffInSeconds = Math.floor((now - date) / 1000);

    const minute = 60;
    const hour = minute * 60;
    const day = hour * 24;
    const month = day * 30;
    const year = day * 365;

    if (diffInSeconds < minute) {
      return 'hace unos segundos';
    } else if (diffInSeconds < hour) {
      const minutes = Math.floor(diffInSeconds / minute);
      return `hace ${minutes} minuto${minutes !== 1 ? 's' : ''}`;
    } else if (diffInSeconds < day) {
      const hours = Math.floor(diffInSeconds / hour);
      return `hace ${hours} hora${hours !== 1 ? 's' : ''}`;
    } else if (diffInSeconds < month) {
      const days = Math.floor(diffInSeconds / day);
      return `hace ${days} día${days !== 1 ? 's' : ''}`;
    } else if (diffInSeconds < year) {
      const months = Math.floor(diffInSeconds / month);
      return `hace ${months} mes${months !== 1 ? 'es' : ''}`;
    } else {
      const years = Math.floor(diffInSeconds / year);
      return `hace ${years} año${years !== 1 ? 's' : ''}`;
    }
  };

  const cargarDetalles = (idPublicacion) => {
    setComentarios([]);

    axios.get(`/publicacion/${idPublicacion}`)
      .then((response) => {
        const publicacionData = response.data;
        setDetallesPublicacion({
          ...publicacionData,
          id: publicacionData.id || publicacionData.ID_publicacion
        });
        const imagen = new Image();
        imagen.src = publicacionData.Img_publicacion;
        imagen.onload = () => {
          document.getElementById('resolucionImagen').textContent =
            `${imagen.width}px x ${imagen.height}px`;
        };

        registrarHistorial(publicacionData.ID_publicacion);

        axios.get(`/usuario/${publicacionData.ID_usuario}`)
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

        axios.get(`/publicaciones/${idPublicacion}/categorias`)
          .then(response => setCategorias(response.data))
          .catch(error => {
            console.error('Error cargando categorías:', error);
            setCategorias([]);
          });

        const usuarioGuardado = localStorage.getItem('ID_usuario');
        if (usuarioGuardado) {
          axios.get(`/publicacion_guardada`)
            .then(response => {
              const todasLasGuardadas = response.data;
              const estaGuardada = todasLasGuardadas.some(
                pg => pg.ID_usuario == usuarioGuardado && pg.ID_publicacion == idPublicacion
              );
              setGuardada(estaGuardada);
            })
            .catch(error => {
              console.error('Error verificando estado guardado:', error);
              setGuardada(false);
            });
        }

        axios.get(`/comentario`)
          .then(async (response) => {
            const comentariosFiltrados = response.data.filter(
              comentario => comentario.ID_publicacion == idPublicacion
            );

            const comentariosConUsuarios = await Promise.all(
              comentariosFiltrados.map(async comentario => {
                try {
                  const userResponse = await axios.get(`/usuario/${comentario.ID_usuario}`);
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

            const usuarioActual = localStorage.getItem('ID_usuario');
            if (usuarioActual) {
              const yaComento = comentariosFiltrados.some(c => c.ID_usuario == usuarioActual);
              setYaComento(yaComento);
            }


            setComentarios(comentariosConUsuarios);
          })
          .catch(console.error);
      })
      .catch(console.error);
  };

  const guardarPublicacion = async () => {
    try {
      const usuarioGuardado = localStorage.getItem('ID_usuario');

      if (!usuarioGuardado) {
        alert('Debes iniciar sesión para guardar publicaciones');
        return;
      }

      if (!detallesPublicacion?.ID_publicacion) {
        console.error('No se ha cargado la publicación');
        return;
      }

      const response = await axios.get(`/publicacion_guardada`);
      const todasLasGuardadas = response.data;
      const publicacionGuardada = todasLasGuardadas.find(
        pg => pg.ID_usuario == usuarioGuardado && pg.ID_publicacion == detallesPublicacion.ID_publicacion
      );

      if (publicacionGuardada) {
        await axios.delete(`/publicacion_guardada/${publicacionGuardada.ID_publicacion_guardada}`);
        setGuardada(false);
      } else {
        await axios.post(`/publicacion_guardada`, {
          ID_usuario: usuarioGuardado,
          ID_publicacion: detallesPublicacion.ID_publicacion
        });
        setGuardada(true);
      }
    } catch (error) {
      console.error('Error:', error);
    }
  };

  const handleClickRecomendada = async (idPublicacionRecomendada) => {
    try {
      const ID_usuario = localStorage.getItem('ID_usuario');
      if (!ID_usuario) {
        // Si no hay usuario logueado, simplemente recargar en el mismo modal
        setIdPublicacionActual(idPublicacionRecomendada);
        return;
      }

      // Obtener datos de la publicación recomendada
      const response = await axios.get(`/publicacion/${idPublicacionRecomendada}`);
      const publicacionRecomendada = response.data;

      // Verificar si es del usuario actual
      if (String(publicacionRecomendada.ID_usuario) === String(ID_usuario)) {
        // Es propia - notificar al padre para que abra el modal propio
        onClose(); // Cerrar este modal primero
        onOpenPropia(publicacionRecomendada);
      } else {
        // No es propia - recargar en este modal
        setIdPublicacionActual(idPublicacionRecomendada);
      }
    } catch (error) {
      console.error('Error al verificar publicación:', error);
      // En caso de error, recargar en este modal por defecto
      setIdPublicacionActual(idPublicacionRecomendada);
    }
  };



  const handleSubmitComentario = async (e) => {
    e.preventDefault();

    if (yaComento) {
      alert('Ya has comentado en esta publicación');
      return;
    }

    if (!nuevoComentario.trim()) {
      alert('El comentario no puede estar vacío');
      return;
    }

    const ID_usuario = localStorage.getItem('ID_usuario');
    if (!ID_usuario) {
      alert('Debes iniciar sesión para comentar');
      return;
    }

    setCargandoComentario(true);

    try {
      const response = await axios.post('/comentario', {
        Contenido_comentario: nuevoComentario,
        ID_usuario: parseInt(ID_usuario),
        ID_publicacion: parseInt(idPublicacionActual)
      });

      const userResponse = await axios.get(`/usuario/${ID_usuario}`);
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
      setYaComento(true);
    } catch (error) {
      console.error('Error al enviar comentario:', error);
      alert('Error al enviar el comentario');
    } finally {
      setCargandoComentario(false);
    }
  };


  const eliminarComentario = async (idComentario) => {
    if (!Swal.confirm('¿Estás seguro de que quieres eliminar este comentario?')) {
      return;
    }

    try {
      await axios.delete(`/comentario/${idComentario}`);
      setComentarios(prev => prev.filter(coment => coment.ID_comentario !== idComentario));
      setYaComento(false);
    } catch (error) {
      console.error('Error al eliminar comentario:', error);
      alert('No se pudo eliminar el comentario');
    }
  };


  useEffect(() => {
    if (idPublicacionActual) {
      cargarDetalles(idPublicacionActual);
      cargarReacciones(idPublicacionActual);
      cargarRecomendaciones(idPublicacionActual);
      cargarEtiquetas(idPublicacionActual);
    }
  }, [idPublicacionActual]);


  const cargarReacciones = async (idPublicacion) => {
    try {

      const response = await axios.get('/publicacion_reaccion');
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
        const idPublicacion = parseInt(idPublicacionActual);
        const usuarioReacciones = await axios.get('/usuario_reaccion');

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
      setCargandoReaccion(true);
      const usuarioActual = localStorage.getItem('ID_usuario');
      if (!usuarioActual) {
        alert('Debes iniciar sesión para reaccionar');
        return;
      }

      if (reaccionUsuario === idReaccion) {
        await quitarReaccion();
        return;
      }

      if (reaccionUsuario) {
        await quitarReaccion();
      }

      await axios.post('/publicacion_reaccion', {
        ID_publicacion: parseInt(idPublicacionActual),
        ID_reaccion: idReaccion,
        ID_usuario: usuarioActual
      });

      await axios.post('/usuario_reaccion', {
        ID_usuario: usuarioActual,
        ID_publicacion: parseInt(idPublicacionActual),
        ID_reaccion: idReaccion
      });

      setReaccionUsuario(idReaccion);
      actualizarContador(idReaccion, true);
    } catch (error) {
      console.error('Error al reaccionar:', error);
    } finally {
      setCargandoReaccion(false);
    }
  };

  const quitarReaccion = async () => {
    try {
      const idPublicacion = parseInt(idPublicacionActual);
      const usuarioActual = localStorage.getItem('ID_usuario');
      if (!usuarioActual || !reaccionUsuario) return;

      const usuarioReaccion = await axios.get(`/usuario_reaccion`);
      const miReaccion = usuarioReaccion.data.find(
        ur => ur.ID_usuario == usuarioActual && ur.ID_reaccion == reaccionUsuario
      );

      if (miReaccion) {
        await axios.delete(`/usuario_reaccion/${miReaccion.ID_usuario_reaccion}`);

        const publicacionReacciones = await axios.get(`/publicacion_reaccion`);
        const reaccionPublicacion = publicacionReacciones.data.find(
          pr => pr.ID_publicacion == idPublicacion && pr.ID_reaccion == reaccionUsuario
        );

        if (reaccionPublicacion) {
          await axios.delete(`/publicacion_reaccion/${reaccionPublicacion.ID_publicacion_reaccion}`);
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


  if (!idPublicacion) return null;

  return (
    <div
      className="contenedor_detalles"
      style={{ display: 'flex' }}
      onClick={onClose}
    >
      <div className="tarjeta_detalles" onClick={(event) => event.stopPropagation()}>
        <div className="first_part_detalles">
          <div className="half half-left">
            <div className="img_descripcion">
              <img src={detallesPublicacion ? detallesPublicacion.Img_publicacion : ""} alt="Imagen de la publicación" />
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
                  <p className="text_descrip" id="fechaCreacion">{detallesPublicacion ? formatRelativeTime(detallesPublicacion.Fecha_Publicacion) : ""}</p>
                </div>
                <div className="div_detall">
                  <div className="tittel_descrip" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <span>Etiquetas</span>
                  </div>

                  <div className="text_descrip">
                    <div className="etiquetas-lista">
                      {Array.isArray(etiquetas) && etiquetas.map(etiqueta => (
                        <span key={etiqueta.ID_etiqueta_publicacion} className="etiqueta-item">
                          {etiqueta.descripcion} <em>({etiqueta.score?.toFixed(0)}%)</em>
                        </span>
                      ))}
                    </div>
                  </div>

                </div>
              </div>
            </div>
          </div>
          <div className="half half-right">
            <div className="buton_cerrar">
              <a href={`/perfil_tercero/${detallesPublicacion?.usuario?.ID_usuario}`} className="direccion_user texto">
                <div className="icon_user_detalles">
                  {detallesPublicacion?.usuario && (
                    <>
                      <img
                        src={detallesPublicacion.usuario.Img_usuario}
                        alt=""
                      />
                      <p id="userName">{detallesPublicacion.usuario.Nombre_usuario}</p>
                    </>
                  )}
                </div>
              </a>
              <div className="icon_saves" onClick={guardarPublicacion}>
                <i
                  className={`fa-${guardada ? 'solid' : 'regular'} fa-bookmark iconos`}
                  style={{ color: guardada ? "#1e90ff" : "#87cefa" }}
                />
              </div>
              <button className="boton_tarjeta" onClick={onClose}>
                X
              </button>
            </div>
            <div className="tittle_descripcion">
              <h2 id="tituloPublicacion">{detallesPublicacion ? detallesPublicacion.Titulo_publicacion : "Título de la publicación"}</h2>
              <hr />
            </div>
            <div className="scrool_detalles">
              <div className="descripcion_card">
                <h3 className='posicion_h'>
                  Descripcion de la Publicacion
                </h3>
                <div className="container_description">
                  <div className="descripcion_tarjeta_texto">
                    <p id="descripcionPublicacion">{detallesPublicacion ? detallesPublicacion.Descripcion_publicacion : "Descripción de la publicación"}</p>
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
                    <i className="fa-solid fa-angle-down iconos" />
                  </div>
                  <div className="categorias_descripcion">
                    {comentarios.map((comentario) => {
                      const ID_usuario_actual = localStorage.getItem('ID_usuario');
                      const esMiComentario = ID_usuario_actual && comentario.ID_usuario == ID_usuario_actual;

                      return (
                        <div className="tarjeta_comentarios" key={comentario.ID_comentario}>
                          <div className="icon_comentario">
                            <img src={comentario.usuario?.Img_usuario} alt="Usuario" />
                          </div>
                          <div className="contenedor_contenido_reaccion">
                            <div className="conenido_comentario">
                              <a href={`/perfil_tercero/${comentario.ID_usuario}`} className="direccion_user texto">
                                <div className="titulo_nombre_comentario">
                                  <h3 className='posicion_h'>{comentario.usuario?.Nombre_usuario || "Usuario"}</h3>
                                </div>
                              </a>
                              <div className="texto_contenido_comentario">
                                <h3 className='posicion_h'>{comentario.Contenido_comentario}</h3>
                              </div>
                            </div>
                            <div className="detalles_comentario">
                              <p>{formatRelativeTime(comentario.Fecha_comentario)}</p>
                              <p className="texto_centro_comentario">Responder</p>
                              <i className="fa-regular fa-heart iconos" />
                              {esMiComentario && (
                                <i
                                  className="fa-solid fa-trash iconos"
                                  onClick={() => eliminarComentario(comentario.ID_comentario)}
                                  style={{ cursor: 'pointer', color: '#ff4d4d' }}
                                  title="Eliminar comentario"
                                />
                              )}
                              <i className="fa-solid fa-bug icono_reporte iconos">
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
                        onClick={() => !cargandoReaccion && manejarReaccion(1)}
                        style={{
                          cursor: cargandoReaccion ? 'not-allowed' : 'pointer',
                          opacity: cargandoReaccion ? 0.6 : 1
                        }}
                        title="Me gusta"
                      />
                      {cargandoReaccion && reaccionUsuario === 1 ? (
                        <span className="contador-reaccion">...</span>
                      ) : (
                        <span className="contador-reaccion">{contadorReacciones.meGusta}</span>
                      )}
                    </div>

                    <div className="reaccion-item">
                      <i
                        className={`fa-solid fa-heart iconos ${reaccionUsuario === 2 ? 'reaccion-activa' : ''}`}
                        onClick={() => !cargandoReaccion && manejarReaccion(2)}
                        style={{
                          cursor: cargandoReaccion ? 'not-allowed' : 'pointer',
                          opacity: cargandoReaccion ? 0.6 : 1
                        }}
                        title="Me encanta"
                      />
                      {cargandoReaccion && reaccionUsuario === 2 ? (
                        <span className="contador-reaccion">...</span>
                      ) : (
                        <span className="contador-reaccion">{contadorReacciones.meEncanta}</span>
                      )}
                    </div>

                    <div className="reaccion-item">
                      <i
                        className={`fa-solid fa-thumbs-down iconos ${reaccionUsuario === 3 ? 'reaccion-activa' : ''}`}
                        onClick={() => !cargandoReaccion && manejarReaccion(3)}
                        style={{
                          cursor: cargandoReaccion ? 'not-allowed' : 'pointer',
                          opacity: cargandoReaccion ? 0.6 : 1
                        }}
                        title="No me gusta"
                      />
                      {cargandoReaccion && reaccionUsuario === 3 ? (
                        <span className="contador-reaccion">...</span>
                      ) : (
                        <span className="contador-reaccion">{contadorReacciones.meDesagrada}</span>
                      )}
                    </div>

                    <div className="reaccion-texto">
                      <span className="texto_reaccion">
                        {cargandoReaccion ? 'Procesando...' : 'Reaccionar'}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
              <div className="segunda_publicacion">
                <div className="icon_comentario">
                  <img src={ImgUsuario} alt />
                </div>
                <form onSubmit={handleSubmitComentario}>
                  <input
                    type="text"
                    className="input_publicar_comentario"
                    placeholder={yaComento ? "Ya comentaste esta publicación" : "Añade un comentario"}
                    value={nuevoComentario}
                    onChange={(e) => !yaComento && setNuevoComentario(e.target.value)}
                    disabled={yaComento || cargandoComentario}
                  />
                  <button
                    type="submit"
                    className="boton_enviar_comentario"
                    disabled={yaComento || cargandoComentario || !nuevoComentario.trim()}
                  >
                    {cargandoComentario ? (
                      <i className="fas fa-spinner fa-spin" />
                    ) : (
                      <i className="fa-solid fa-paper-plane iconos" />
                    )}
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

export default ModalDetalles;