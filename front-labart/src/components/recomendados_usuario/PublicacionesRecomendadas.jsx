import React, { useEffect, useState } from 'react';
import axios from 'axios';
import 'bootstrap/dist/css/bootstrap.min.css';
import '../../assets/styles/explorar/explorar.css';
import '../../assets/styles/home/estiloh.css';
import logo from '../../assets/img/concepto_logo.png';
import pribut from '../../assets/img/primary-button.svg';
import ModalAjustes from "../modal_configuracion/configuracion";
import ModalDetalles from '../home/DetallesModal';

const PublicacionesRecomendadas = () => {
  const [publicacionesRecomendadas, setPublicacionesRecomendadas] = useState([]);
  const [usuario, setUsuario] = useState(null);
  const [mostrarModal, setMostrarModal] = useState(false);
  const [cargando, setCargando] = useState(true);
  const [modalPublicacionId, setModalPublicacionId] = useState(null);
  const [idUsuario, setIdUsuario] = useState(null);

  useEffect(() => {
    const id = localStorage.getItem('ID_usuario');
    const nombre = localStorage.getItem('Nombre_usuario');
    if (id) setIdUsuario(id);
    if (nombre) setUsuario({ nombre: nombre });
  }, []);

  useEffect(() => {
    const obtenerDatos = async () => {
      if (!idUsuario) return;

      try {
        setCargando(true);
        const responseUsuario = await axios.get(`/usuario/${idUsuario}`);
        setUsuario(responseUsuario.data || { nombre: localStorage.getItem('Nombre_usuario') });

        const responsePublicaciones = await axios.get(`/page_explorar/${idUsuario}`);
        const publicaciones = responsePublicaciones.data?.data?.secciones || [];
        setPublicacionesRecomendadas(publicaciones);
      } catch (error) {
        console.error("Error al cargar datos:", error);
      } finally {
        setCargando(false);
      }
    };

    obtenerDatos();
  }, [idUsuario]);

  const renderizarColumnas = (numColumnas) => {
    if (cargando) return <div>Cargando publicaciones...</div>;
    if (!Array.isArray(publicacionesRecomendadas) || publicacionesRecomendadas.length === 0)
      return <div>No hay publicaciones recomendadas</div>;

    // Extraer y eliminar duplicados por id_publicacion
    const publicacionesPlanas = publicacionesRecomendadas.flatMap(seccion =>
      Array.isArray(seccion.publicaciones) ? seccion.publicaciones : []
    );

    const publicacionesUnicas = Array.from(
      new Map(publicacionesPlanas.map(pub => [pub.id_publicacion, pub])).values()
    );

    if (publicacionesUnicas.length === 0) return <div>No hay publicaciones disponibles</div>;

    const columnas = Array.from({ length: numColumnas }, () => []);

    publicacionesUnicas.forEach((publicacion, index) => {
      columnas[index % numColumnas].push(publicacion);
    });

    return columnas.map((columna, i) => (
      <div key={i} className={`columnas columna${i + 1}`}>
        <div className="tarjetas">
          {columna.map((publicacion) => (
            <div key={publicacion.id_publicacion} className="tarjeta">
              <img
                src={publicacion.imagen_publicacion}
                alt={`Publicación de ${publicacion.nombre_usuario}`}
                onClick={() => mostrarDetalles(publicacion.id_publicacion)} 
              />
            </div>
          ))}
        </div>
      </div>
    ));
  };

  const mostrarDetalles = (idPublicacion) => {
    setModalPublicacionId(idPublicacion);
    document.documentElement.classList.add('html-no-scroll');
  };
  
  const cerrarDetalles = () => {
    setModalPublicacionId(null);
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
  
  return (
    <div className='contenedor_home'>
      <div className='contenedor_todo'>
        <div className="container_all">
          <nav className="menu_nav">
            <div className="menu">
              <div className="logo">
                <img className="img_logo" src={logo} alt="LABART Logo" />
              </div>
              <div className="options_menu">
                <a href="/home" className='texto'>
                  <div className="opciones indicador_actual">
                    <div className="indicador_opcion" />
                    <i className="icon_selected fa-solid fa-house iconos" />
                    <h4 className="text_selected texto_h">Inicio</h4>
                  </div>
                </a>
                <a href="/categoria" className="opciones texto">
                  <i className="fa-regular fa-compass iconos" style={{ color: '#545454' }} />
                  <h4 className='texto_h'>Explorar</h4>
                </a>
                <a href="/asistente" className="opciones texto">
                  <i className="icons fa-regular fa-lightbulb iconos" style={{ color: '#545454' }} />
                  <h4 className='texto_h'>IA</h4>
                </a>
                <a href="paint/paint.html" className="opciones texto">
                  <i className="icons fa-solid fa-palette iconos" style={{ color: '#545454' }} />
                  <h4 className='texto_h'>Crea Tu Arte</h4>
                </a>
                <a href="/perfil" className="texto">
                  <div className="opciones">
                    <i className="icons fa-regular fa-bookmark iconos" style={{ color: '#545454' }} />
                    <h4 className='texto_h'>Publicaciones Guardadas</h4>
                  </div>
                </a>
                <h3 className='posicion_h'>Settings</h3>
                <a href="/perfil" className="opciones texto">
                  <i className="icons fa-regular fa-user iconos" style={{ color: '#545454' }} />
                  <h4 className='texto_h'>Mi Perfil</h4>
                </a>
                <div className="opciones" onClick={abrirModalAjustes} style={{ cursor: 'pointer' }}>
                  <i className="icons fa-solid fa-gear iconos" style={{ color: '#545454' }} />
                  <h4 className='texto_h'>Configuraciones</h4>
                </div>
              </div>
            </div>
            <div className="box">
              <div className="ayuda">
                <div className="overlap-group">
                  <img className="primary-button" src={pribut} alt="Botón de ayuda" />
                </div>
              </div>
            </div>
          </nav>

          <section>
            <div className="home" id="home">
              <div className="cabeza_home">
                <div className="cabeza_texto">
                  <h1>Bienvenido, {usuario?.Nombre_usuario}</h1>
                  <p>{publicacionesRecomendadas.flatMap(seccion => seccion.publicaciones || []).length} publicaciones recomendadas</p>
                </div>
              </div>

              <div className="contenedor_todo_2">
                <div className="home_columnas home_columnas_5c">{renderizarColumnas(5)}</div>
                <div className="home_columnas home_columnas_4c">{renderizarColumnas(4)}</div>
                <div className="home_columnas home_columnas_3c">{renderizarColumnas(3)}</div>
                <div className="home_columnas home_columnas_2c">{renderizarColumnas(2)}</div>
                <div className="home_columnas home_columnas_1c">{renderizarColumnas(1)}</div>
              </div>
            </div>
          </section>
        </div>

        <ModalDetalles 
          idPublicacion={modalPublicacionId} 
          onClose={cerrarDetalles}
        />
        <ModalAjustes mostrar={mostrarModal} onCerrar={cerrarModalAjustes} />
      </div>
    </div>
  );
};

export default PublicacionesRecomendadas;
