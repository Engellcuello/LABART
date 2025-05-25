import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import axios from '../../utils/axiosintance';
import 'bootstrap/dist/css/bootstrap.min.css';
import '../../assets/styles/explorar/explorar.css';
import '../../assets/styles/home/estiloh.css';
import logo from '../../assets/img/concepto_logo.png';
import pribut from '../../assets/img/primary-button.svg';
import ModalAjustes from "../modal_configuracion/configuracion";
import ModalDetalles from '../home/DetallesModal';
import PublicacionPropiaModal from '../perfil/Detalles_propia';
import PqrsModal from '../Pqrs/PqrsModal';
import Swal from 'sweetalert2';

const PublicacionesCategoria = () => {
  const { idCategoria } = useParams();
  const [publicaciones, setPublicaciones] = useState([]);
  const [categoria, setCategoria] = useState(null);
  const [mostrarModal, setMostrarModal] = useState(false);
  const [showPqrsModal, setShowPqrsModal] = useState(false);
  const [cargando, setCargando] = useState(true);
  const [modalPublicacionId, setModalPublicacionId] = useState(null);
  const [showPropiaModal, setShowPropiaModal] = useState(false);
  const [selectedPublicacion, setSelectedPublicacion] = useState(null);
  const [contenidoExplicito, setContenidoExplicito] = useState(false);

  useEffect(() => {
    const pref = localStorage.getItem("Cont_Explicit_user");
    setContenidoExplicito(pref === 'true');
  }, []);

  useEffect(() => {
    const obtenerDatos = async () => {
      try {
        setCargando(true);

        // Obtener datos de la categoría
        const responseCategoria = await axios.get(`/categoria/${idCategoria}`);
        setCategoria(responseCategoria.data);

        // Obtener publicaciones por categoría
        const responsePublicaciones = await axios.get(`/publicacion_categoria/categoria/${idCategoria}`);
        setPublicaciones(responsePublicaciones.data);

      } catch (error) {
        console.error("Error al cargar datos:", error);
      } finally {
        setCargando(false);
      }
    };

    obtenerDatos();
  }, [idCategoria]);

  const mostrarDetallesPublicacion = async (publicacion) => {
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
      return;
    }

    const idUsuarioLocal = localStorage.getItem('ID_usuario');
    
    try {
      // Obtener los datos completos de la publicación
      const response = await axios.get(`/publicacion/${publicacion.ID_publicacion}`);
      const publicacionCompleta = response.data;

      if (idUsuarioLocal && String(publicacionCompleta.ID_usuario) === String(idUsuarioLocal)) {
        // Es una publicación propia
        setSelectedPublicacion(publicacionCompleta);
        setShowPropiaModal(true);
        setModalPublicacionId(null);
      } else {
        // Es una publicación de otro usuario
        setModalPublicacionId(publicacionCompleta.ID_publicacion);
        setShowPropiaModal(false);
      }
      document.documentElement.classList.add('html-no-scroll');
    } catch (error) {
      console.error('Error al obtener detalles de la publicación:', error);
    }
  };

  const cerrarDetalles = () => {
    setModalPublicacionId(null);
    document.documentElement.classList.remove('html-no-scroll');
  };

  const cerrarPropiaModal = () => {
    setShowPropiaModal(false);
    document.documentElement.classList.remove('html-no-scroll');
  };

  const abrirModalAjustes = () => {
    setMostrarModal(true);
    document.documentElement.classList.add('html-no-scroll');
  };

  const cerrarModalAjustes = () => {
    setMostrarModal(false);
    document.documentElement.classList.remove('html-no-scroll');
  };

  const renderizarColumnas = (numColumnas) => {
    if (cargando) {
      return <div>Cargando publicaciones...</div>;
    }

    if (publicaciones.length === 0) {
      return <div>No hay publicaciones en esta categoría</div>;
    }

    const columnas = Array.from({ length: numColumnas }, () => []);

    publicaciones.forEach((publicacion, index) => {
      columnas[index % numColumnas].push(publicacion);
    });

    return columnas.map((columna, i) => (
      <div key={i} className={`columnas columna${i + 1}`}>
        <div className="tarjetas">
          {columna.map((publicacion) => {
            const debeMostrarFiltro = publicacion.Cont_Explicit_publi && !contenidoExplicito;
            
            return (
              <div key={publicacion.ID_publicacion} className="tarjeta">
                <div 
                  className={`imagen-contenedor ${debeMostrarFiltro ? 'contenido-explicito' : ''}`}
                  onClick={() => mostrarDetallesPublicacion(publicacion)}
                >
                  <img
                    src={publicacion.Img_publicacion || 'ruta/imagen_por_defecto.jpg'}
                    alt={`Publicación ${publicacion.Titulo || publicacion.ID_publicacion}`}
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

  return (
    <div className='contenedor_home'>
      <div className='contenedor_todo'>
        <div className="container_all">
          {/* Navbar */}
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
                    <i className="icons fa-regular fa-bell iconos" style={{ color: '#545454' }} />
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

          {/* Contenido principal */}
          <section>
            <div className="home" id="home">
              <div className="cabeza_home">
                <div className="cabeza_texto">
                  <h1>{categoria?.Nombre_categoria || "Cargando categoría..."}</h1>
                  <p>{publicaciones.length} publicaciones</p>
                </div>
              </div>

              <div className="contenedor_todo_2">
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
        {modalPublicacionId && (
          <ModalDetalles
            idPublicacion={modalPublicacionId}
            onClose={cerrarDetalles}
            onOpenPropia={(publicacion) => {
              setSelectedPublicacion(publicacion);
              setShowPropiaModal(true);
              setModalPublicacionId(null);
              document.documentElement.classList.add('html-no-scroll');
            }}
          />
        )}

        {showPropiaModal && (
          <PublicacionPropiaModal
            mostrar={showPropiaModal}
            onClose={cerrarPropiaModal}
            publicacion={selectedPublicacion}
            onOpenDetalles={(idPublicacion) => {
              setModalPublicacionId(idPublicacion);
              setShowPropiaModal(false);
              document.documentElement.classList.add('html-no-scroll');
            }}
          />
        )}

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

export default PublicacionesCategoria;