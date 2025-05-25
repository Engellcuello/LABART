import React, { useState, useEffect, useRef } from 'react';
import axios from '../../utils/axiosintance';
import Swal from 'sweetalert2';

const PublicacionPropiaModal = ({ mostrar, onClose, publicacion, onOpenDetalles }) => {
  const [comentarios, setComentarios] = useState([]);
  const [categorias, setCategorias] = useState([]);
  const [detallesPublicacion, setDetallesPublicacion] = useState(null);
  const [nuevoComentario, setNuevoComentario] = useState('');
  const [ImgUsuario, setImgUsuario] = useState("");
  const [reaccionUsuario, setReaccionUsuario] = useState(null);
  const [mostrarModalCategorias, setMostrarModalCategorias] = useState(false);
  const [todasLasCategorias, setTodasLasCategorias] = useState([]);
  const [categoriasSeleccionadas, setCategoriasSeleccionadas] = useState([]);
  const [etiquetas, setEtiquetas] = useState([]);
  const [etiquetasDisponibles, setEtiquetasDisponibles] = useState([]);
  const [mostrarModalEtiquetas, setMostrarModalEtiquetas] = useState(false);
  const [etiquetaSeleccionada, setEtiquetaSeleccionada] = useState('');
  const [contadorReacciones, setContadorReacciones] = useState({
    meGusta: 0,
    meEncanta: 0,
    meDesagrada: 0,
    total: 0
  });
  const [publicacionesRecomendadas, setPublicacionesRecomendadas] = useState([]);
  const [cargandoReaccion, setCargandoReaccion] = useState(false);
  const [cargandoComentario, setCargandoComentario] = useState(false);
  const [yaComento, setYaComento] = useState(false);

  const contenedorUsuarioRef = useRef(null);
  const resolucionImagenRef = useRef(null);
  const historialRegistradoRef = useRef(null);

  // Obtener imagen de usuario del localStorage
  useEffect(() => {
    const Img_usuario = localStorage.getItem("Img_usuario");
    setImgUsuario(Img_usuario);
  }, []);

  useEffect(() => {
    if (mostrar && publicacion) {
      mostrarPublicacionPropia(publicacion);
      cargarTodasLasCategorias();

      // Cargar las categorías actuales de la publicación
      axios.get(`/publicaciones/${publicacion.ID_publicacion}/categorias`)
        .then(response => {
          setCategorias(response.data);
          setCategoriasSeleccionadas(response.data.map(cat => cat.ID_categoria));
        })
        .catch(console.error);
    }
  }, [mostrar, publicacion]);

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

  const calcularResolucionImagen = (imagenUrl) => {
    const imagen = new Image();
    imagen.src = imagenUrl;
    imagen.onload = function () {
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
    axios.get(`/recomendaciones/publicacion/${idPublicacion}`)
      .then((response) => {
        setPublicacionesRecomendadas(response.data);
      })
      .catch((error) => {
        console.error('Error al cargar recomendaciones:', error);
      });
  };

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
      const idPublicacion = publicacion.ID_publicacion;

      if (!usuarioActual) {
        alert('Debes iniciar sesión para reaccionar');
        return;
      }

      if (reaccionUsuario === idReaccion) {
        await quitarReaccion(idPublicacion);
        return;
      }

      if (reaccionUsuario) {
        await quitarReaccion(idPublicacion);
      }

      await axios.post('/publicacion_reaccion', {
        ID_publicacion: idPublicacion,
        ID_reaccion: idReaccion,
        ID_usuario: usuarioActual
      });

      await axios.post('/usuario_reaccion', {
        ID_usuario: usuarioActual,
        ID_publicacion: idPublicacion,
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

  const quitarReaccion = async (idPublicacion) => {
    try {
      const usuarioActual = localStorage.getItem('ID_usuario');
      if (!usuarioActual || !reaccionUsuario) return;

      const usuarioReaccion = await axios.get('/usuario_reaccion');
      const miReaccion = usuarioReaccion.data.find(
        ur => ur.ID_usuario == usuarioActual && ur.ID_publicacion == idPublicacion && ur.ID_reaccion == reaccionUsuario
      );

      if (miReaccion) {
        await axios.delete(`/usuario_reaccion/${miReaccion.ID_usuario_reaccion}`);

        const publicacionReacciones = await axios.get('/publicacion_reaccion');
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
        ID_publicacion: parseInt(publicacion.ID_publicacion)
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
    if (!await Swal.fire({
      title: '¿Estás seguro?',
      text: "No podrás revertir esta acción",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Sí, eliminar'
    }).then(result => result.isConfirmed)) return;

    try {
      await axios.delete(`/comentario/${idComentario}`);
      setComentarios(prev => prev.filter(c => c.ID_comentario !== idComentario));
      setYaComento(false);
    } catch (error) {
      console.error('Error al eliminar comentario:', error);
      Swal.fire('Error', 'No se pudo eliminar el comentario', 'error');
    }
  };

  const eliminarPublicacion = async () => {
    const confirmacion = await Swal.fire({
      title: '¿Estás seguro?',
      text: "Esta acción eliminará la publicación permanentemente",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Sí, eliminar'
    });

    if (!confirmacion.isConfirmed) return;

    try {
      await axios.delete(`/publicacion/${publicacion.ID_publicacion}`);
      Swal.fire('Eliminada', 'La publicación ha sido eliminada', 'success')
        .then((result) => {
          if (result.isConfirmed) {
            window.location.reload();
          }
        });
      onClose();
    } catch (error) {
      console.error('Error al eliminar publicación:', error);
      Swal.fire('Error', 'No se pudo eliminar la publicación', 'error');
    }
  };

  const guardarCambios = async () => {
    // Verificar que los campos no estén vacíos
    if (!detallesPublicacion?.Titulo_publicacion?.trim()) {
      Swal.fire('Error', 'El título no puede estar vacío', 'error');
      return;
    }

    if (!detallesPublicacion?.Descripcion_publicacion?.trim()) {
      Swal.fire('Error', 'La descripción no puede estar vacía', 'error');
      return;
    }

    try {
      await axios.put(`/publicacion/${publicacion.ID_publicacion}`, {
        Titulo_publicacion: detallesPublicacion.Titulo_publicacion,
        Descripcion_publicacion: detallesPublicacion.Descripcion_publicacion
      });
      Swal.fire('Guardado', 'Los cambios se han guardado correctamente', 'success');
    } catch (error) {
      console.error('Error al guardar cambios:', error);
      Swal.fire('Error', 'No se pudieron guardar los cambios', 'error');
    }
  };

  const handleClickRecomendada = async (idPublicacionRecomendada) => {
    try {
      const ID_usuario = localStorage.getItem('ID_usuario');
      if (!ID_usuario) {
        // Si no hay usuario logueado, abrir directamente modal de detalles
        onClose();
        onOpenDetalles(idPublicacionRecomendada);
        return;
      }

      // Obtener datos de la publicación recomendada
      const response = await axios.get(`/publicacion/${idPublicacionRecomendada}`);
      const publicacionRecomendada = response.data;

      // Verificar si es del usuario actual
      if (String(publicacionRecomendada.ID_usuario) === String(ID_usuario)) {
        // Es propia - recargar el modal actual
        mostrarPublicacionPropia({ ID_publicacion: idPublicacionRecomendada });
      } else {
        // No es propia - cerrar este modal y abrir el de detalles
        onClose();
        onOpenDetalles(idPublicacionRecomendada);
      }
    } catch (error) {
      console.error('Error al verificar publicación:', error);
      // En caso de error, abrir modal de detalles por defecto
      onClose();
      onOpenDetalles(idPublicacionRecomendada);
    }
  };

  const mostrarPublicacionPropia = (publicacion) => {
    if (!publicacion?.ID_publicacion) {
      console.error("Publicación no tiene ID:", publicacion);
      return;
    }

    setComentarios([]);
    setCategorias([]);
    setYaComento(false);

    if (contenedorUsuarioRef.current) {
      contenedorUsuarioRef.current.style.display = 'flex';
    }

    axios.get(`/publicacion/${publicacion.ID_publicacion}`)
      .then((response) => {
        const publicacionData = response.data;
        setDetallesPublicacion({
          ...publicacionData,
          id_original: publicacion.ID_publicacion,
          esPropia: true
        });

        calcularResolucionImagen(publicacionData.Img_publicacion);
        cargarReacciones(publicacion.ID_publicacion);
        cargarRecomendaciones(publicacion.ID_publicacion);
        cargarEtiquetas(publicacion.ID_publicacion);
        registrarHistorial(publicacion.ID_publicacion);

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

        axios.get(`/publicaciones/${publicacion.ID_publicacion}/categorias`)
          .then(response => setCategorias(response.data))
          .catch(error => {
            console.error('Error cargando categorías:', error);
            setCategorias([]);
          });

        axios.get(`/comentario`)
          .then(async (response) => {
            const comentariosFiltrados = response.data.filter(
              c => c.ID_publicacion == publicacion.ID_publicacion
            );

            const usuarioActual = localStorage.getItem('ID_usuario');
            if (usuarioActual) {
              const yaComento = comentariosFiltrados.some(c => c.ID_usuario == usuarioActual);
              setYaComento(yaComento);
            }

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

            setComentarios(comentariosConUsuarios);
          })
          .catch(console.error);
      })
      .catch(console.error);
  };

  const cargarTodasLasCategorias = async () => {
    try {
      const response = await axios.get('/categoria');
      setTodasLasCategorias(response.data);
    } catch (error) {
      console.error('Error al cargar categorías:', error);
    }
  };

  const toggleCategoria = (idCategoria) => {
    setCategoriasSeleccionadas(prev => {
      if (prev.includes(idCategoria)) {
        return prev.filter(id => id !== idCategoria);
      } else {
        return [...prev, idCategoria];
      }
    });
  };

  const cargarEtiquetas = async (idPublicacion) => {
    try {
      const response = await axios.get(`/publicaciones/${idPublicacion}/etiquetas`);
      const etiquetasData = response.data.etiquetas || [];
      setEtiquetas(Array.isArray(etiquetasData) ? etiquetasData : []);
    } catch (error) {
      console.error('Error cargando etiquetas:', error);
      setEtiquetas([]);
    }
  };

  const cargarEtiquetasDisponibles = async () => {
    try {
      const response = await axios.get('/etiquetas/disponibles');
      setEtiquetasDisponibles(response.data);
    } catch (error) {
      console.error('Error cargando etiquetas disponibles:', error);
    }
  };

  const asignarEtiqueta = async () => {
    if (!etiquetaSeleccionada) return;

    try {
      const ID_usuario = localStorage.getItem('ID_usuario');
      if (!ID_usuario) {
        alert('Debes iniciar sesión para agregar etiquetas');
        return;
      }

      const response = await axios.post(
        `/publicaciones/${publicacion.ID_publicacion}/etiquetas/asignar`,
        {
          descripcion: etiquetaSeleccionada,
          ID_usuario: ID_usuario
        }
      );

      setEtiquetas([...etiquetas, response.data]);
      setEtiquetaSeleccionada('');
      setMostrarModalEtiquetas(false);
    } catch (error) {
      console.error('Error asignando etiqueta:', error);
      alert(error.response?.data?.mensaje || 'Error al asignar etiqueta');
    }
  };

  const guardarCategorias = async () => {
    if (!publicacion?.ID_publicacion) return;

    try {
      await axios.delete(`/publicaciones/${publicacion.ID_publicacion}/categorias`);

      for (const idCategoria of categoriasSeleccionadas) {
        await axios.post(`/publicacion_categoria`, {
          ID_publicacion: publicacion.ID_publicacion,
          ID_categoria: idCategoria
        });
      }
      const nuevasCategorias = todasLasCategorias.filter(cat =>
        categoriasSeleccionadas.includes(cat.ID_categoria)
      );
      setCategorias(nuevasCategorias);

      setMostrarModalCategorias(false);
      Swal.fire('Éxito', 'Categorías actualizadas correctamente', 'success');
    } catch (error) {
      console.error('Error al actualizar categorías:', error);
      Swal.fire('Error', 'No se pudieron actualizar las categorías', 'error');
    }
  };

  if (!mostrar) return null;

  return (
    <div
      className="contenedor_detalles contenedor_usuario"
      ref={contenedorUsuarioRef}
      onClick={onClose}
      style={{ display: 'none' }}
    >
      <div className="contnedor2_detalles">
        <div className="tarjeta_detalle2" onClick={(e) => e.stopPropagation()}>
          <div className="first_part_detalles">
            <div className="half half-left">
              <div className="img_descripcion">
                <img
                  src={detallesPublicacion?.Img_publicacion || '/img/placeholder.jpg'}
                  alt={detallesPublicacion?.Titulo_publicacion || "Publicación"}
                />
              </div>
              <div className="buton_eliminar_publicacion">
                <button
                  className="botones_eliminar"
                  onClick={eliminarPublicacion}
                >
                  Eliminar publicación
                </button>
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
                    <div className="tittel_descrip" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                      <span>Etiquetas</span>
                      <button
                        className="btn-agregar-etiqueta"
                        onClick={() => {
                          cargarEtiquetasDisponibles();
                          setMostrarModalEtiquetas(true);
                        }}
                      >
                        + Agregar
                      </button>
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
                    {mostrarModalEtiquetas && (
                      <div className="modal-etiquetas">
                        <div className="modal-contenido">
                          <h3>Seleccionar etiqueta</h3>
                          <div className="lista-etiquetas-disponibles">
                            {etiquetasDisponibles.map((etiqueta, index) => (
                              <div
                                key={index}
                                className={`etiqueta-disponible ${etiquetaSeleccionada === etiqueta ? 'seleccionada' : ''}`}
                                onClick={() => setEtiquetaSeleccionada(etiqueta)}
                              >
                                {etiqueta}
                              </div>
                            ))}
                          </div>
                          <div className="modal-acciones">
                            <button onClick={() => setMostrarModalEtiquetas(false)}>Cancelar</button>
                            <button
                              onClick={asignarEtiqueta}
                              disabled={!etiquetaSeleccionada}
                            >
                              Asignar etiqueta
                            </button>
                          </div>
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </div>
            <div className="half half-right">
              <div className="buton_cerrar">
                <a href="/perfil" className="direccion_user texto">
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
                <button className="boton_tarjeta" onClick={onClose} style={{ marginLeft: '56%' }}>
                  X
                </button>
              </div>
              <div className="tittle_descripcion">
                <h2>
                  <input
                    className="input_nueva_publicacion"
                    type="text"
                    maxLength={58}
                    defaultValue={detallesPublicacion?.Titulo_publicacion}
                    onChange={(e) => setDetallesPublicacion(prev => ({
                      ...prev,
                      Titulo_publicacion: e.target.value
                    }))}
                    required

                  />
                </h2>
                <hr />
              </div>
              <div className="scrool_detalles">
                <div className="descripcion_card">
                  <h3>Descripción de la Publicación</h3>
                  <div className="container_description">
                    <div className="descripcion_tarjeta_texto">
                      <textarea
                        className="input_descripcion_perfil"
                        type="text"
                        placeholder="Añade una descripción detallada"
                        defaultValue={detallesPublicacion?.Descripcion_publicacion}
                        onChange={(e) => setDetallesPublicacion(prev => ({
                          ...prev,
                          Descripcion_publicacion: e.target.value
                        }))}
                      />
                    </div>
                    <div className="categorias_descripcion">
                      {categorias.map((categoria, index) => (
                        <button key={index}>{categoria.Nombre_categoria}</button>
                      ))}
                      <button
                        className="btn-editar-categorias"
                        onClick={() => setMostrarModalCategorias(true)}
                      >
                        <i className="fa-solid fa-pencil" />
                      </button>
                    </div>
                  </div>
                  <div className="parte_guardar_cambios">
                    <button
                      className="guardar_cambios_button"
                      onClick={guardarCambios}
                      disabled={
                        !detallesPublicacion?.Titulo_publicacion?.trim() ||
                        !detallesPublicacion?.Descripcion_publicacion?.trim()
                      }
                    >
                      Guardar Cambios
                    </button>
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
                                alt="Usuario"
                              />
                            </div>
                            <div className="contenedor_contenido_reaccion">
                              <div className="conenido_comentario">
                                <a
                                  href={`/perfil_tercero/${comentario.ID_usuario}`}
                                  className="direccion_user texto"
                                >
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
                                  <span className="texto_reaccion reporte_comentario">
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
                    <img src={ImgUsuario} alt="Usuario" />
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
                        <i className="fa-solid fa-paper-plane" />
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
                  <h1>Imágenes Relacionadas</h1>
                </div>
                <button className="boton_tarjeta boton_ver_mas" src="/home">
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

            {mostrarModalCategorias && (
              <div className="modal-categorias-overlay" onClick={() => setMostrarModalCategorias(false)}>
                <div className="modal-categorias" onClick={(e) => e.stopPropagation()}>
                  <div className="modal-categorias-header">
                    <h3>Selecciona las categorías</h3>
                    <button
                      className="modal-categorias-close"
                      onClick={() => setMostrarModalCategorias(false)}
                    >
                      &times;
                    </button>
                  </div>
                  <div className="modal-categorias-body">
                    {todasLasCategorias.map(categoria => (
                      <div
                        key={categoria.ID_categoria}
                        className={`categoria-item ${categoriasSeleccionadas.includes(categoria.ID_categoria) ? 'selected' : ''}`}
                        onClick={() => toggleCategoria(categoria.ID_categoria)}
                      >
                        <input
                          type="checkbox"
                          checked={categoriasSeleccionadas.includes(categoria.ID_categoria)}
                          readOnly
                        />
                        <span>{categoria.Nombre_categoria}</span>
                      </div>
                    ))}
                  </div>
                  <div className="modal-categorias-footer">
                    <button
                      className="btn-cancelar"
                      onClick={() => setMostrarModalCategorias(false)}
                    >
                      Cancelar
                    </button>
                    <button
                      className="btn-guardar"
                      onClick={guardarCategorias}
                    >
                      Guardar Cambios
                    </button>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default PublicacionPropiaModal;