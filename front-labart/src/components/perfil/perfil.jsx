import React, { useState, useEffect, useRef } from 'react';
import Swal from 'sweetalert2';
import axios from 'axios';
import '../../assets/styles/perfil/perfil.css'
import '../../assets/styles/perfil/stylep.css'
import pribut from '../../assets/img/primary-button.svg';
import PublicacionPropiaModal from './Detalles_propia';
import PublicacionGuardadaModal from './Detalles_guardada';
import PqrsModal from '../Pqrs/PqrsModal';
import logo from '../../assets/img/concepto_logo.png';

import PublicacionModal from '../home/Nueva_publicacion';
import ModalAjustes from '../modal_configuracion/configuracion';

const Perfil = () => {

  const [mostrarPublicaciones, setMostrarPublicaciones] = useState(true);
  const [publicaciones, setPublicaciones] = useState([]);
  const [publicacionesGuardadas, setPublicacionesGuardadas] = useState([]);
  const [cargando, setCargando] = useState(false);
  const [showPqrsModal, setShowPqrsModal] = useState(false);
  const contenedorUsuarioRef = useRef(null);
  const contenedorSavesRef = useRef(null);
  const homeRef = useRef(null);
  const resolucionImagenRef = useRef(null);
  const [detallesPublicacion, setDetallesPublicacion] = useState(null);
  const [showPublicacionModal, setShowPublicacionModal] = useState(false);
  const [mostrarModal, setMostrarModal] = useState(false);
  const [showPropiaModal, setShowPropiaModal] = useState(false);
  const [showGuardadaModal, setShowGuardadaModal] = useState(false);
  const [selectedPublicacion, setSelectedPublicacion] = useState(null);
  const [usuario_perfil, setUsuarioPerfil] = useState({
    nombre: "",
    imagen: "",
    descripcion: "",
    totalReacciones: 0,
    totalPublicaciones: 0
  });

  useEffect(() => {
    if (showPropiaModal) {
      document.documentElement.classList.add('html-no-scroll');
    } else {
      document.documentElement.classList.remove('html-no-scroll');
    }
    return () => {
      document.documentElement.classList.remove('html-no-scroll');
    };
  }, [showPropiaModal]);

  useEffect(() => {
    if (showGuardadaModal) {
      document.documentElement.classList.add('html-no-scroll');
    } else {
      document.documentElement.classList.remove('html-no-scroll');
    }

    return () => {
      document.documentElement.classList.remove('html-no-scroll');
    };
  }, [showGuardadaModal]);

  useEffect(() => {
    const cargarDatosUsuario = async () => {
      try {
        const idUsuario = localStorage.getItem("ID_usuario");

        if (idUsuario) {
          // Hacer la petición al endpoint /usuario
          const response = await axios.get(`http://127.0.0.1:5000/usuario/${idUsuario}`);
          const datosUsuario = response.data;

          setUsuarioPerfil({
            nombre: datosUsuario.Nombre_usuario || "Invitado",
            imagen: datosUsuario.Img_usuario,
            descripcion: datosUsuario.Descripcion_usuario || "Sin descripción"
          });
        } else {
          // Usuario no autenticado (modo invitado)
          setUsuarioPerfil({
            nombre: "Invitado",
            imagen: null,
            descripcion: "Inicia sesión para personalizar tu perfil"
          });
        }
      } catch (error) {
        console.error("Error al cargar datos del usuario:", error);
        // Fallback a los datos del localStorage si la API falla
        const nombre = localStorage.getItem("Nombre_usuario") || "Invitado";
        const imagen = localStorage.getItem("Img_usuario");

        setUsuarioPerfil({
          nombre: nombre,
          imagen: imagen,
          descripcion: "No se pudo cargar la descripción"
        });
      }
    };

    cargarDatosUsuario();
  }, []);



  useEffect(() => {
    const idUsuario = localStorage.getItem('ID_usuario');

    if (!idUsuario) return;

    const fetchDatosUsuario = async () => {
      try {
        setCargando(true);

        const publicacionesResponse = await axios.get('http://127.0.0.1:5000/publicacion');
        const publicacionesUsuario = publicacionesResponse.data.filter(
          pub => pub.ID_usuario === Number(idUsuario)
        );
        setPublicaciones(publicacionesUsuario);

        const idsPublicacionesUsuario = publicacionesUsuario.map(p => p.ID_publicacion);
        setUsuarioPerfil(prev => ({
          ...prev,
          totalPublicaciones: publicacionesUsuario.length
        }));

        const reaccionesResponse = await axios.get('http://127.0.0.1:5000/publicacion_reaccion');
        const reaccionesUsuario = reaccionesResponse.data.filter(r =>
          idsPublicacionesUsuario.includes(r.ID_publicacion)
        );
        setUsuarioPerfil(prev => ({
          ...prev,
          totalReacciones: reaccionesUsuario.length
        }));

        const guardadasResponse = await axios.get('http://127.0.0.1:5000/publicacion_guardada');
        const guardadasDelUsuario = guardadasResponse.data.filter(
          pg => pg.ID_usuario === Number(idUsuario)
        );

        if (guardadasDelUsuario.length > 0) {
          const idsGuardadas = guardadasDelUsuario.map(g => g.ID_publicacion);
          const publicacionesGuardadasResponse = await Promise.all(
            idsGuardadas.map(id => axios.get(`http://127.0.0.1:5000/publicacion/${id}`))
          );

          const publicacionesGuardadasData = publicacionesGuardadasResponse.map(r => r.data);
          setPublicacionesGuardadas(publicacionesGuardadasData);
        }

      } catch (error) {
        console.error('Error al obtener datos:', error);
      } finally {
        setCargando(false);
      }
    };

    fetchDatosUsuario();
  }, []);



  if (cargando) {
    return <div>Cargando publicaciones...</div>;
  }


  const abrirModalAjustes = () => {
    setMostrarModal(true);
    document.documentElement.classList.add('html-no-scroll');
  };



  const cerrarModalAjustes = () => {
    setMostrarModal(false);
    document.documentElement.classList.remove('html-no-scroll');
  };


  const renderizarColumnas = (numColumnas, publicacionesArray, mostrarFunc) => {
    if (!Array.isArray(publicacionesArray) || publicacionesArray.length === 0) {
      return null;
    }

    const columnas = Array.from({ length: numColumnas }, () => []);

    publicacionesArray.forEach((publicacion, index) => {
      columnas[index % numColumnas].push(publicacion);
    });

    return (
      <>
        {columnas.map((columna, i) => (
          <div key={`col-${numColumnas}-${i}`} className={`columnas columna${i + 1}`}>
            <div className="tarjetas">
              {columna.map((publicacion) => (
                <div key={publicacion.ID_publicacion} className="tarjeta">
                  <img
                    src={publicacion.Img_publicacion}
                    alt={publicacion.Titulo_publicacion || `Publicación ${publicacion.ID_publicacion}`}
                    onClick={() => mostrarFunc(publicacion)}
                  />
                </div>
              ))}
            </div>
          </div>
        ))}
      </>
    );
  };


  const calcularResolucionImagen = (imagenUrl) => {
    const imagen = new Image();
    imagen.src = imagenUrl;

    imagen.onload = function () {
      if (resolucionImagenRef.current) {
        const resolucion = `${imagen.width}px x ${imagen.height}px`;
        resolucionImagenRef.current.textContent = resolucion;
      }
    };
  };








  const cerrarDetalles = () => {
    if (contenedorUsuarioRef.current) {
      contenedorUsuarioRef.current.style.display = 'none';
    }
    if (contenedorSavesRef.current) {
      contenedorSavesRef.current.style.display = 'none';
    }
    if (homeRef.current) {
      homeRef.current.style.overflowY = 'visible';
    }
  };

  window.onload = function () {
    // Leer el estado desde sessionStorage
    if (sessionStorage.getItem('mostrarGuardados') === 'true') {
      document.getElementById('home_mis_publicaciones').style.display = 'none';
      document.getElementById('home_publicaciones_guardadas').style.display = 'flex';

      // Limpiar el estado para futuras visitas
      sessionStorage.removeItem('mostrarGuardados');
    }
  };




  const cerrar_sesion = () => {
    Swal.fire({
      title: "¿QUIERES CERRAR LA SESIÓN?",
      showCancelButton: true,
      cancelButtonText: "Cancelar",
      confirmButtonText: "Sí",
    }).then((result) => {
      if (result.isConfirmed) {
        localStorage.removeItem("token");
        localStorage.removeItem("ID_usuario");
        localStorage.removeItem("Nombre_usuario");
        localStorage.removeItem("Img_usuario");
        Swal.fire({
          position: "center",
          icon: "info",
          title: "Hasta Pronto",
          showConfirmButton: false,
          timer: 1500,
        });
        setTimeout(() => {
          window.location.href = "/";
        }, 1500);
      }
    });
  };




  return (

    <div ref={homeRef}>
      <nav className="menu_nav">
        <div className="menu">
          <div className="logo">
            <img className="img_logo" src={logo} alt="Logo LABART" />
          </div>
          <div className="options_menu">
            <a href="/home" className="opciones texto">
              <i className="fa-solid fa-house iconos" style={{ color: '#545454' }} />
              <h4 className="texto_h">Inicio</h4>
            </a>
            <a href="/categoria" className="opciones texto">
              <i className="fa-regular fa-compass iconos" style={{ color: '#545454' }} />
              <h4 className='texto_h'>Explorar</h4>
            </a>
            <a href="/buscar-usuario" className="opciones texto">
              <i className="fa-solid fa-magnifying-glass iconos lupa-ajustada" style={{ color: '#545454' }} />
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
            <a href="/perfil" className="opciones indicador_actual texto">
              <div className="indicador_opcion" />
              <i className="icon_selected icons fa-regular fa-user iconos" />
              <h4 className='text_selected texto_h'>Mi Perfil</h4>
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
      <div className="contenedor_home_perfil">
        <div className="contenedor_cabecera_perfil">
          <div className="parte_cerrar_sesion_perfil">
            <i className="fa-solid fa-right-from-bracket" onClick={cerrar_sesion} />
          </div>
          <div className="parte_foto_perfil">
            <div className="imagen_usuario">
              <img src={usuario_perfil.imagen} />
            </div>
          </div>
          <div className="parte_desccripcion_usuario">
            <div className="first_part_perfil">
              <div className="nombre_perfil">
                {usuario_perfil.nombre}
              </div>
              <div className="botones_acciones_perfil">
                <a href="/editar-perfil" style={{ textDecoration: 'none' }}>
                  <div className="parte_boton_editar_perfil">
                    <button className="boton_editar_perfil" href="/editar-perfil">
                      Editar <br /> perfil
                    </button>
                  </div>
                </a>
                <div className="parte_boton_publicar_perfil">
                  <button className="boton_publicar_perfil" onClick={() => setShowPublicacionModal(true)}>
                    Nueva <br /> Publicacion
                  </button>
                </div>
              </div>
            </div>
            <div className="second_part_perfil">
              <div className="seccion_num_publicaciones">
                {usuario_perfil.totalPublicaciones} <br /> Publicaciones
              </div>
              <div className="seccion_num_seguidores">
                {usuario_perfil.totalReacciones} <br /> Reacciones
              </div>
            </div>
            <div className="three_part_perfil">
              <div className="texto_descripcion_perfil">
                <p>
                  {usuario_perfil.descripcion}
                </p>
              </div>
            </div>
          </div>
        </div>
        <div className="separador_cabecera_perfil">
          <hr />
        </div>
        <div className="seccion_publicaciones_save">
          <button
            className={`boton_publicaciones_save boton_publicaciones ${mostrarPublicaciones ? 'active' : ''}`}
            onClick={() => setMostrarPublicaciones(true)}
          >
            Mis Publicaciones
          </button>
          <div className="linea_vertical"></div>
          <button
            className={`boton_publicaciones_save boton_saves ${!mostrarPublicaciones ? 'active' : ''}`}
            onClick={() => setMostrarPublicaciones(false)}
          >
            Publicaciones Guardadas
          </button>
        </div>
        {mostrarPublicaciones ? (
          <div className="contenedor-publicaciones" id="home_mis_publicaciones">
            {publicaciones.length > 0 ? (
              [5, 4, 3, 2, 1].map((columnas) => (
                <div key={`col-${columnas}`} className={`home_columnas home_columnas_${columnas}c`}>
                  {renderizarColumnas(columnas, publicaciones, (publicacion) => {
                    setSelectedPublicacion(publicacion);
                    setShowPropiaModal(true);
                  })}
                </div>
              ))
            ) : (
              <p className="mensaje-vacio">No tienes publicaciones propias</p>
            )}
          </div>
        ) : (
          <div className="contenedor-publicaciones" id="home_publicaciones_guardadas">
            {publicacionesGuardadas.length > 0 ? (
              [5, 4, 3, 2, 1].map((columnas) => (
                <div key={`col-${columnas}`} className={`home_columnas home_columnas_${columnas}c`}>
                  {renderizarColumnas(columnas, publicacionesGuardadas, (publicacion) => {
                    setSelectedPublicacion(publicacion);
                    setShowGuardadaModal(true);
                  })}
                </div>
              ))
            ) : (
              <p className="mensaje-vacio">No tienes publicaciones guardadas</p>
            )}
          </div>
        )}
      </div>


      {showPqrsModal && (
        <PqrsModal onClose={() => {
          setShowPqrsModal(false);
          document.documentElement.classList.remove('html-no-scroll');
        }} />
      )}




      <PublicacionPropiaModal
        mostrar={showPropiaModal}
        onClose={() => setShowPropiaModal(false)}
        publicacion={selectedPublicacion}
      />

      <PublicacionGuardadaModal
        mostrar={showGuardadaModal}
        onClose={() => setShowGuardadaModal(false)}
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

    </div>


  );
};
export default Perfil;