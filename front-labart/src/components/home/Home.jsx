import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import logo from '../../assets/img/concepto_logo.png';
import pribut from '../../assets/img/primary-button.svg';
import imgper from '../../assets/img/fotos_usuario/imgper.webp';
import persoar from '../../assets/img/fotos_usuario/persoar.jpg';
import Swal from 'sweetalert2';
import band1 from '../../assets/img/banderas/band_eeuu.png';
import band2 from '../../assets/img/banderas/band_spain.png';
import band3 from '../../assets/img/banderas/band_portugal.png';
import band4 from '../../assets/img/banderas/band_francia.png';
import PublicacionModal from './Nueva_publicacion';
import NotificationBell from "./Notificacionesbell";
import ModalAjustes from '../modal_configuracion/configuracion';
import PqrsModal from '../Pqrs/PqrsModal';
import PublicacionPropiaModal from '../../components/perfil/Detalles_propia';
import ModalDetalles from './DetallesModal';

const Home = () => {
  const [usuario, setUsuario] = useState("");
  const [ImgUsuario, setImgUsuario] = useState("");
  const [idUsuario, setIdUsuario] = useState(null);
  const [showPublicacionModal, setShowPublicacionModal] = useState(false);
  const [mostrarModal, setMostrarModal] = useState(false);
  const [publicaciones, setPublicaciones] = useState([]);
  const [showPropiaModal, setShowPropiaModal] = useState(false);
  const [selectedPublicacion, setSelectedPublicacion] = useState(null);
  const [showPqrsModal, setShowPqrsModal] = useState(false);
  const [modalPublicacionId, setModalPublicacionId] = useState(null);
  const [cantidadReacciones, setCantidadReacciones] = useState(0);
  const [cantidadPublicaciones, setCantidadPublicaciones] = useState(0);
  const [contenidoExplicito, setContenidoExplicito] = useState(false);


  // Obtener datos del usuario
  useEffect(() => {
    const Nombre_usuario = localStorage.getItem("Nombre_usuario") || "Invitado";
    const Img_usuario = localStorage.getItem("Img_usuario") || imgper;
    const idUsuarioLocal = localStorage.getItem("ID_usuario");
    const contenidoExplicit = localStorage.getItem("Cont_Explicit_user") === 'true';

    setUsuario(Nombre_usuario);
    setImgUsuario(Img_usuario);
    setIdUsuario(idUsuarioLocal);
    setContenidoExplicito(contenidoExplicit);
  }, []);

  useEffect(() => {
    const idUsuarioLocal = localStorage.getItem("ID_usuario");

    if (idUsuarioLocal) {

      axios.get(`http://127.0.0.1:5000/publicacion`)
        .then((response) => {
          if (Array.isArray(response.data)) {
            const publicacionesUsuario = response.data.filter(pub => String(pub.ID_usuario) === String(idUsuarioLocal));
            setCantidadPublicaciones(publicacionesUsuario.length);
          }
        })
        .catch((error) => {
          console.error("Error al obtener publicaciones del usuario:", error);
        });

      axios.get(`http://127.0.0.1:5000/publicacion_reaccion`)
        .then((response) => {
          if (Array.isArray(response.data)) {
            const reaccionesUsuario = response.data.filter(react => String(react.ID_usuario) === String(idUsuarioLocal));
            setCantidadReacciones(reaccionesUsuario.length);
          }
        })
        .catch((error) => {
          console.error("Error al obtener reacciones del usuario:", error);
        });
    }
  }, []);


  // Efecto para el scroll cuando el modal está abierto
  useEffect(() => {
    if (showPropiaModal || modalPublicacionId !== null) {
      document.documentElement.classList.add('html-no-scroll');
    } else {
      document.documentElement.classList.remove('html-no-scroll');
    }
    return () => {
      document.documentElement.classList.remove('html-no-scroll');
    };
  }, [showPropiaModal, modalPublicacionId]);

  // Mostrar modal ajustes
  const abrirModalAjustes = () => {
    setMostrarModal(true);
    document.documentElement.classList.add('html-no-scroll');
  };

  const cerrarModalAjustes = () => {
    setMostrarModal(false);
    document.documentElement.classList.remove('html-no-scroll');
  };



  const handleClickPublicacionExplicita = (publicacion) => {
    const idUsuarioLocal = localStorage.getItem("ID_usuario");
    const esPublicacionPropia = String(publicacion.ID_usuario) === String(idUsuarioLocal);

    // Si es publicación propia, mostrar siempre sin censura
    if (esPublicacionPropia) {
      mostrarDetalles(publicacion);
      return;
    }

    // Si es de otro usuario y es explícita con filtro activado
    if (publicacion.Cont_Explicit_publi && !contenidoExplicito) {
      Swal.fire({
        icon: 'warning',
        title: 'Contenido explícito',
        text: 'Esta publicación contiene contenido explícito. Activa "Mostrar contenido explícito" en ajustes para verla.',
        confirmButtonText: 'Ir a ajustes',
        showCancelButton: true,
        cancelButtonText: 'Cancelar'
      }).then((result) => {
        if (result.isConfirmed) {
          setMostrarModal(true);
        }
      });
    } else {
      mostrarDetalles(publicacion);
    }
  };


  // Función para mostrar el modal adecuado según si es publicación propia o no
  const mostrarDetalles = (publicacion) => {
    const idUsuarioLocal = localStorage.getItem("ID_usuario");

    // Asegurarse de comparar strings con strings
    if (String(publicacion.ID_usuario) === String(idUsuarioLocal)) {
      setSelectedPublicacion(publicacion);
      setShowPropiaModal(true);
      setModalPublicacionId(null); // Asegurarse de cerrar el otro modal
    } else {
      setModalPublicacionId(publicacion.ID_publicacion);
      setShowPropiaModal(false); // Asegurarse de cerrar el modal propio
    }
    document.documentElement.classList.add('html-no-scroll');
  };

  const cerrarDetalles = () => {
    setModalPublicacionId(null);
    document.documentElement.classList.remove('html-no-scroll');
  };





  // Obtención de publicaciones desde la API
  useEffect(() => {
    axios
      .get("http://127.0.0.1:5000/publicacion")
      .then((response) => {
        if (Array.isArray(response.data)) {
          const publicacionesOrdenadas = response.data.sort((a, b) => {
            return new Date(b.Fecha_publicacion) - new Date(a.Fecha_publicacion);
          });
          setPublicaciones(publicacionesOrdenadas);
        } else {
          console.error("La respuesta de la API no es un array.");
        }
      })
      .catch((error) => {
        console.error("Error al obtener las publicaciones:", error);
      });
  }, []);

  // Renderizar columnas de publicaciones
  const renderizarColumnas = (numColumnas) => {
    if (!Array.isArray(publicaciones)) {
      console.error("Las publicaciones no son un array:", publicaciones);
      return null;
    }

    const columnas = Array.from({ length: numColumnas }, () => []);

    publicaciones.forEach((publicacion, index) => {
      columnas[index % numColumnas].push(publicacion);
    });

    return columnas.map((columna, i) => (
      <div key={i} className={`columnas columna${i + 1}`}>
        <div className="tarjetas">
          {columna.map((publicacion) => {
            const idUsuarioLocal = localStorage.getItem("ID_usuario");
            const esPublicacionPropia = String(publicacion.ID_usuario) === String(idUsuarioLocal);
            const debeMostrarFiltro = publicacion.Cont_Explicit_publi && !contenidoExplicito && !esPublicacionPropia;

            return (
              <div key={publicacion.ID_publicacion} className="tarjeta">
                <div
                  className={`imagen-contenedor ${debeMostrarFiltro ? 'contenido-explicito' : ''}`}
                  onClick={() => handleClickPublicacionExplicita(publicacion)}
                >
                  <img
                    src={publicacion.Img_publicacion}
                    alt={`Publicación ${publicacion.ID_publicacion}`}
                  />
                  {debeMostrarFiltro && (
                    <div className="advertencia-explicito">
                      <i className="fa-solid fa-eye-slash"></i>
                      <span>Contenido explícito</span>
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </div>
    ));
  };

  // Event listeners para el input de archivo (mantenido como estaba)
  useEffect(() => {
    const uploadButton = document.getElementById("input_subir_archivo");
    const chosenImage = document.getElementById("img_subir_archivo");
    const closeIcon = document.getElementById("close_img_archivo");
    const infoInputArchivo = document.getElementById("info_input_archivo");
    const centroInputArchivo = document.getElementById("centro_input_archivo");
    const contenedor_subir_publicacion = document.getElementById("contenedor_subir_publicacion");

    if (uploadButton && chosenImage && closeIcon && infoInputArchivo && centroInputArchivo && contenedor_subir_publicacion) {
      uploadButton.onchange = () => {
        const file = uploadButton.files[0];
        if (file) {
          const reader = new FileReader();
          reader.readAsDataURL(file);
          reader.onload = () => {
            chosenImage.setAttribute("src", reader.result);
            chosenImage.style.display = "block";
            closeIcon.style.display = "flex";
            infoInputArchivo.style.display = "none";
            centroInputArchivo.style.display = "none";
            uploadButton.style.display = "none";
            contenedor_subir_publicacion.style.marginTop = "25px";
          };
        }
      };

      closeIcon.onclick = () => {
        chosenImage.style.display = "none";
        closeIcon.style.display = "none";
        infoInputArchivo.style.display = "block";
        centroInputArchivo.style.display = "flex";
        uploadButton.value = "";
        uploadButton.style.display = "block";
        contenedor_subir_publicacion.style.marginTop = "50%";
      };
    }
  });



  return (
    <div className='contenedor_home'>
      <div className='contenedor_todo'>
        <div className="container_all">
          <nav className="menu_nav">
            <div className="menu">
              <div className="logo">
                <img className="img_logo" src={logo} alt="Logo LABART" />
              </div>
              <div className="options_menu">
                <div className="opciones indicador_actual">
                  <div className="indicador_opcion" />
                  <i className="icon_selected fa-solid fa-house iconos" />
                  <h4 className="text_selected texto_h">Inicio</h4>
                </div>
                <a href="/categoria" className="opciones texto">
                  <i className="fa-regular fa-compass iconos" style={{ color: '#545454' }} />
                  <h4 className='texto_h'>Explorar</h4>
                </a>
                <a href="/buscar-usuario" className="opciones texto">
                  <i className="fa-solid fa-magnifying-glass iconos lupa-ajustada" style={{ color: '#545454'}} />
                  <h4 className='texto_h'>Buscar Usuario</h4>
                </a>
                <a href="/asistente" className="opciones texto">
                  <i className="icons fa-regular fa-lightbulb iconos" style={{ color: '#545454' }} />
                  <h4 className='texto_h'>IA</h4>
                </a>
                <a href="paint/paint.html" className="opciones texto">
                  <i className="icons fa-solid fa-palette iconos" style={{ color: '#545454' }} />
                  <h4 className='texto_h'>Crea Tu Arte</h4>
                </a>
                <a href="/notificaciones" className="texto">
                  <div className="opciones">
                    <i className="icons fa-regular fa-bell iconos" style={{ color: '#545454' }}/>
                    <h4 className='texto_h'>Notificaciones</h4>
                  </div>
                </a>
                <h3 className='posicion_h'>Settings</h3>
                <a href="/perfil" className="opciones texto">
                  <i className="icons fa-regular fa-user iconos" style={{ color: '#545454' }} />
                  <h4 className='texto_h'>Mi Perfil</h4>
                </a>
                <div
                  className="opciones"
                  onClick={abrirModalAjustes}
                  style={{ cursor: 'pointer' }}
                >
                  <i className="icons fa-solid fa-gear iconos" style={{ color: '#545454' }} />
                  <h4 className='texto_h'>Configuraciones</h4>
                </div>
              </div>
            </div>
            <div className="box">
              <div className="ayuda">
                <div className="overlap-group">
                  <img
                    className="primary-button"
                    src={pribut}
                    onClick={() => {
                      setShowPqrsModal(true);
                      document.documentElement.classList.add('html-no-scroll');
                    }}
                    alt="Botón de ayuda PQRS"
                    style={{ cursor: 'pointer' }}
                  />
                </div>
              </div>
            </div>
          </nav>
          <section>
            <div className="home" id="home">
              <div className="cabeza_home">
                <div className="cabeza_texto">
                  <h1>Bienvenido a LABART</h1>
                  <p>Hola {usuario}</p>
                </div>




                <div className="cabeza_acciones">
                  <a href="/asistente" className='texto'>
                    <div className="icono_cabeza mensajes">
                      <i className="fa-regular fa-comments iconos" />
                    </div>
                  </a>
                  <NotificationBell />
                  <a href="/perfil" className='texto'>
                    <div className="icono_cabeza icon_user">
                      <img src={ImgUsuario} alt="Usuario" />
                    </div>
                  </a>
                </div>
              </div>
              <div className="contenedor_buttonera">
                <div className="tarjeta_home">
                  <div>
                    <h2 className="titulo_home">Crea, Explora y Publica Arte</h2>
                    <p className="texto_home">
                      Explora tu creatividad, crea obras únicas y compártelas con el mundo en nuestra plataforma dedicada al arte.
                    </p>
                    <div>
                      <button className="btn_home btn_home1">
                        <a href="/categoria" className="btn_home btn_home2 texto">Explorar Arte</a>
                      </button>
                      <button className="btn_home btn_home2" onClick={() => setShowPublicacionModal(true)}>Publica Tu Arte</button>
                      <button className="btn_home btn_home3">
                        <a href="paint/paint.html" className="btn_home btn_home3 texto">Crea Tu Arte</a>
                      </button>
                    </div>
                  </div>
                </div>
                <div className="tarjeta_contenido">
                  <div className="contenido_titulo">
                    <h1 className="text_contenido titulo_home">Mi Contenido</h1>
                    <i className="icon_rocket fa-solid fa-rocket iconos" style={{ color: '#ffffff' }} />
                  </div>
                  <div className="contenido_divicion">
                    <div className="contenido_publicaciones">
                      <p className="texto_contenido">Publicaciones</p>
                      <p className="texto_contenido">{cantidadPublicaciones}</p>
                    </div>
                    <div className="contenido_interacciones">
                      <p className="texto_contenido">Reacciones</p>
                      <p className="texto_contenido">{cantidadReacciones}</p>
                    </div>
                  </div>
                  <a className="texto_detalles2" href="/perfil">
                    <div className="boton_detalles flex items-center justify-between">
                      <p className="texto_detalles">Ver Todos Los Detalles</p>
                      <i className="icon_flecha fa-solid fa-arrow-right iconos" style={{ color: '#ffffff' }} />
                    </div>
                  </a>
                </div>
              </div>
              <div className="contenedor_todo_2">
                <div className="contenedor_publicaciones">
                  <div className="titulo_publicaciones">
                    <h2 className="texto_publicaciones">Todas las publicaciones</h2>
                  </div>
                </div>
                <div className="home_columnas home_columnas_5c">
                  {renderizarColumnas(5)}
                </div>
                <div className="home_columnas home_columnas_4c">
                  {renderizarColumnas(4)}
                </div>
                <div className="home_columnas home_columnas_3c">
                  {renderizarColumnas(3)}
                </div>
                <div className="home_columnas home_columnas_2c">
                  {renderizarColumnas(2)}
                </div>
                <div className="home_columnas home_columnas_1c">
                  {renderizarColumnas(1)}
                </div>
              </div>
            </div>
          </section>
        </div>

        {/* Modales */}
        <ModalDetalles
          idPublicacion={modalPublicacionId}
          onClose={cerrarDetalles}
        />

        <PublicacionPropiaModal
          mostrar={showPropiaModal}
          onClose={() => {
            setShowPropiaModal(false);
            document.documentElement.classList.remove('html-no-scroll');
          }}
          publicacion={selectedPublicacion}
        />

        <PublicacionModal
          mostrar={showPublicacionModal}
          onClose={() => setShowPublicacionModal(false)}
        />

        <ModalAjustes
          mostrar={mostrarModal}
          onCerrar={cerrarModalAjustes}
        />

        {showPqrsModal && (
          <PqrsModal onClose={() => {
            setShowPqrsModal(false);
            document.documentElement.classList.remove('html-no-scroll');
          }} />
        )}
      </div>
    </div>
  );
};

export default Home;