import React, { useState, useEffect, useRef } from 'react';
import axios from '../../utils/axiosintance';
import { useParams } from 'react-router-dom';
import '../../assets/styles/perfil/perfil.css';
import '../../assets/styles/perfil/stylep.css';
import ModalDetalles from '../home/DetallesModal';
import PublicacionPropiaModal from './Detalles_propia';
import pribut from '../../assets/img/primary-button.svg';
import ModalAjustes from '../modal_configuracion/configuracion';

const PerfilUsuarioTercero = () => {
   const { idUsuario } = useParams();
  const [publicaciones, setPublicaciones] = useState([]);
  const [cargando, setCargando] = useState(false);
  const [usuario, setUsuario] = useState({
    nombre: "",
    imagen: "",
    descripcion: "",
    totalReacciones: 0,
    totalPublicaciones: 0
  });
  const [modalDetallesAbierto, setModalDetallesAbierto] = useState(false);
  const [idPublicacionSeleccionada, setIdPublicacionSeleccionada] = useState(null);
  const [mostrarModal, setMostrarModal] = useState(false);
  const [showPropiaModal, setShowPropiaModal] = useState(false);
  const [selectedPublicacion, setSelectedPublicacion] = useState(null);

  const [contenidoExplicito, setContenidoExplicito] = useState(false);

  useEffect(() => {
    const pref = localStorage.getItem("Cont_Explicit_user");
    setContenidoExplicito(pref === 'true');
  }, []);

  useEffect(() => {
    if (idUsuario) {
      setCargando(true);

      axios.get(`http://127.0.0.1:5000/usuario/${idUsuario}`)
        .then(userResponse => {
          const userData = userResponse.data;

          return axios.get(`http://127.0.0.1:5000/publicacion`)
            .then(response => {
              const publicacionesUsuario = response.data.filter(
                pub => pub.ID_usuario === Number(idUsuario)
              );

              setPublicaciones(publicacionesUsuario);

              return axios.get('http://127.0.0.1:5000/publicacion_reaccion')
                .then(reaccionesResponse => {
                  const todasReacciones = reaccionesResponse.data;
                  const idsPublicacionesUsuario = publicacionesUsuario.map(p => p.ID_publicacion);

                  const reaccionesUsuario = todasReacciones.filter(r =>
                    idsPublicacionesUsuario.includes(r.ID_publicacion)
                  );

                  setUsuario({
                    nombre: userData.Nombre_usuario,
                    imagen: userData.Img_usuario,
                    descripcion: userData.Descripcion_usuario,
                    totalPublicaciones: publicacionesUsuario.length,
                    totalReacciones: reaccionesUsuario.length
                  });

                  setCargando(false);
                });
            });
        })
        .catch(error => {
          console.error("Error al obtener datos:", error);
          setCargando(false);
        });
    }
  }, [idUsuario]);

  const abrirModalAjustes = () => {
    setMostrarModal(true);
    document.documentElement.classList.add('html-no-scroll');
  };



  const cerrarModalAjustes = () => {
    setMostrarModal(false);
    document.documentElement.classList.remove('html-no-scroll');
  };


  const cerrarModalDetalles = () => {
    setModalDetallesAbierto(false);
  };



  const handleClickPublicacionExplicita = (publicacion) => {
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
      setIdPublicacionSeleccionada(publicacion.ID_publicacion);
      setModalDetallesAbierto(true);
    }
  };

  const renderizarColumnas = (numColumnas, publicacionesArray) => {
    if (!Array.isArray(publicacionesArray)) return null;

    const columnas = Array.from({ length: numColumnas }, () => []);

    publicacionesArray.forEach((publicacion, index) => {
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
                  onClick={() => handleClickPublicacionExplicita(publicacion)}
                >
                  <img
                    src={publicacion.Img_publicacion}
                    alt={publicacion.Titulo_publicacion || `Publicación ${publicacion.ID_publicacion}`}
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

  if (cargando) {
    return <div className="cargando-perfil">Cargando perfil...</div>;
  }

  return (
    <div>
      <nav className="menu_nav">
        <div className="menu">
          <div className="logo">
            <img className="img_logo" src="/src/assets/img/concepto_logo.png" alt />
          </div>
          <div className="options_menu">
            <a href="/home" className='texto'>
              <div className="opciones indicador_actual">
                <div className="indicador_opcion " />
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
            <div className="opciones" onClick={abrirModalAjustes}>
              <i className="icons fa-solid fa-gear iconos" style={{ color: '#545454' }} />
              <h4 className='texto_h'>Configuraciones</h4>
            </div>
          </div>
          <div className="box">
            <div className="ayuda">
              <div className="overlap-group"><img className="primary-button" src={pribut} /></div>
            </div>
          </div>
        </div>
      </nav>
      <div className="contenedor_home_perfil">
        <div className="contenedor_cabecera_perfil">
          <div className="parte_foto_perfil">
            <div className="imagen_usuario">
              <img src={usuario.imagen} alt={`Foto de ${usuario.nombre}`} />
            </div>
          </div>
          <div className="parte_desccripcion_usuario">
            <div className="first_part_perfil">
              <div className="nombre_perfil">
                {usuario.nombre}
              </div>
              <div className="botones_acciones_perfil">
                <a style={{ textDecoration: 'none' }}>
                  <div className="parte_boton_editar_perfil">
                  </div>
                </a>
              </div>
            </div>
            <div className="second_part_perfil">
              <div className="seccion_num_publicaciones">
                {usuario.totalPublicaciones} <br /> Publicaciones
              </div>
              <div className="seccion_num_seguidores">
                {usuario.totalReacciones} <br /> Reacciones
              </div>
            </div>
            <div className="three_part_perfil">
              <div className="texto_descripcion_perfil">
                <p>{usuario.descripcion}</p>
              </div>
            </div>
          </div>
        </div>
        <div className="separador_cabecera_perfil">
          <hr />
        </div>
        <div className="seccion_publicaciones_save">
          <button
            className="boton_publicaciones_save boton_publicaciones"

          >
            Publicaciones de {usuario.nombre}
          </button>
        </div>

        {/* Sección de publicaciones */}
        <div className="contenedor-publicaciones">
          {publicaciones.length > 0 ? (
            <>
              <div className="home_columnas home_columnas_5c">
                {renderizarColumnas(5, publicaciones)}
              </div>
              <div className="home_columnas home_columnas_4c">
                {renderizarColumnas(4, publicaciones)}
              </div>
              <div className="home_columnas home_columnas_3c">
                {renderizarColumnas(3, publicaciones)}
              </div>
              <div className="home_columnas home_columnas_2c">
                {renderizarColumnas(2, publicaciones)}
              </div>
              <div className="home_columnas home_columnas_1c">
                {renderizarColumnas(1, publicaciones)}
              </div>
            </>
          ) : (
            <p className="mensaje-vacio">Este usuario no tiene publicaciones</p>
          )}
        </div>
      </div>


      <ModalAjustes
        mostrar={mostrarModal}
        onCerrar={cerrarModalAjustes}
      />
      {/* Modal de detalles de publicación */}
      {modalDetallesAbierto && (
        <ModalDetalles
          idPublicacion={idPublicacionSeleccionada}
          onClose={() => {
            setModalDetallesAbierto(false);
            document.documentElement.classList.remove('html-no-scroll');
          }}
          onOpenPropia={(publicacion) => {
            setSelectedPublicacion(publicacion);
            setShowPropiaModal(true);
            setModalDetallesAbierto(false);
            document.documentElement.classList.add('html-no-scroll');
          }}
        />
      )}

      {showPropiaModal && (
        <PublicacionPropiaModal
          mostrar={showPropiaModal}
          onClose={() => {
            setShowPropiaModal(false);
            document.documentElement.classList.remove('html-no-scroll');
          }}
          publicacion={selectedPublicacion}
          onOpenDetalles={(idPublicacion) => {
            setIdPublicacionSeleccionada(idPublicacion);
            setModalDetallesAbierto(true);
            setShowPropiaModal(false);
          }}
        />
      )}

    </div>



  );
};

export default PerfilUsuarioTercero;