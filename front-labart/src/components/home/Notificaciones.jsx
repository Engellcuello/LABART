// pages/NotificationsPage.jsx
import React, { useState, useEffect } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faComment, faThumbsUp, faHeart, faAngry, faBell } from "@fortawesome/free-regular-svg-icons";
import { faTimes, faCheck, faTrash } from "@fortawesome/free-solid-svg-icons";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import PublicacionPropiaModal from '../perfil/Detalles_propia';
import logo from '../../assets/img/concepto_logo.png';
import pribut from '../../assets/img/primary-button.svg';
import ModalAjustes from "../modal_configuracion/configuracion";
import PqrsModal from "../Pqrs/PqrsModal";

const NotificationsPage = () => {
  const [notifications, setNotifications] = useState({
    comentarios: [],
    reacciones: []
  });
  const [loading, setLoading] = useState(false);
  const [showPropiaModal, setShowPropiaModal] = useState(false);
  const [mostrarModal, setMostrarModal] = useState(false);
  const [showPqrsModal, setShowPqrsModal] = useState(false);
  const [selectedPublicacion, setSelectedPublicacion] = useState(null);
  const navigate = useNavigate();

  const currentUserId = parseInt(localStorage.getItem("ID_usuario"), 10);
  const backendUrl = "http://127.0.0.1:5000";

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
    if (currentUserId) {
      fetchNotifications();
      markNotificationsAsRead();
    }
  }, [currentUserId]);

  const fetchNotifications = async () => {
    if (!currentUserId) return;
    setLoading(true);
    try {
      const response = await axios.get(`${backendUrl}/notificaciones_usuario/${currentUserId}`);

      const notifs = {
        comentarios: (response.data.comentarios || []).map(n => ({
          ...n,
          id_publicacion: n.id_publicacion || n.ID_publicacion || n.publicacion?.id
        })),
        reacciones: (response.data.reacciones || []).map(n => ({
          ...n,
          id_publicacion: n.id_publicacion || n.ID_publicacion || n.publicacion?.id
        }))
      };

      setNotifications(notifs);
    } catch (error) {
      console.error("Error fetching notifications:", error);
    } finally {
      setLoading(false);
    }
  };

  const abrirModalAjustes = () => {
    setMostrarModal(true);
    document.documentElement.classList.add('html-no-scroll');
  };

  const cerrarModalAjustes = () => {
    setMostrarModal(false);
    document.documentElement.classList.remove('html-no-scroll');
  };


  const markNotificationsAsRead = async () => {
    try {
      await axios.put(`${backendUrl}/notificaciones/marcar_como_leidas/${currentUserId}`);
    } catch (error) {
      console.error("Error marking notifications as read:", error);
    }
  };

  const deleteNotification = async (id) => {
    try {
      await axios.delete(`${backendUrl}/notificaciones/${id}`);
      setNotifications(prev => ({
        comentarios: prev.comentarios.filter(n => n.id !== id),
        reacciones: prev.reacciones.filter(n => n.id !== id)
      }));
    } catch (error) {
      console.error("Error deleting notification:", error);
    }
  };

  const deleteAllNotifications = async () => {
    try {
      await axios.delete(`${backendUrl}/notificaciones/eliminar/${currentUserId}`);
      setNotifications({ comentarios: [], reacciones: [] });
    } catch (error) {
      console.error("Error deleting all notifications:", error);
    }
  };

  const handleNotificationClick = (publicacionId) => {
    if (!publicacionId) {
      console.error("No se pudo obtener el ID de la publicación");
      return;
    }
    setSelectedPublicacion({ ID_publicacion: publicacionId });
    setShowPropiaModal(true);
  };

  const getNotificationContent = (notif) => {
    const baseMessages = {
      3: "comentó en tu publicación",
      2: "le gustó tu publicación",
      4: "no le gustó tu publicación",
      5: "le encantó tu publicación"
    };

    const icons = {
      3: <FontAwesomeIcon icon={faComment} className="text-blue-500" />,
      2: <FontAwesomeIcon icon={faThumbsUp} className="text-green-500" />,
      4: <FontAwesomeIcon icon={faAngry} className="text-red-500" />,
      5: <FontAwesomeIcon icon={faHeart} className="text-pink-500" />
    };

    const publicacionId = notif.id_publicacion || notif.ID_publicacion || notif.publicacion?.id;

    return {
      icon: icons[notif.id_tipo] || <FontAwesomeIcon icon={faBell} className="text-gray-500" />,
      message: `${notif.usuario_accion?.nombre || 'Un usuario'} ${baseMessages[notif.id_tipo] || 'interactuó con tu publicación'}`,
      time: new Date(notif.fecha).toLocaleString(),
      publicacionId: publicacionId
    };
  };

  return (
    <div className="notifications-page">
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
            <a href="/notificaciones" className="opciones indicador_actual texto">
              <div className="indicador_opcion" />
              <i className="icon_selected icons fa-regular fa-bell iconos" />
              <h4 className='text_selected texto_h'>Notificaciones</h4>
            </a>

            <h3 className='posicion_h'>Settings</h3>
            <a href="/perfil" className="texto">
              <div className="opciones">
              <i className="icons fa-regular fa-user iconos" style={{ color: '#545454' }}/>
              <h4 className='texto_h'>Mi Perfil</h4>
              </div>
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

      <div className="notifications-container">
        <div className="notifications-header">
          <h1>Notificaciones</h1>
          <div className="notifications-actions">
            <button
              className="mark-all-read"
              onClick={markNotificationsAsRead}
            >
              <FontAwesomeIcon icon={faCheck} /> Marcar todas como leídas
            </button>
            <button
              className="delete-all"
              onClick={deleteAllNotifications}
            >
              <FontAwesomeIcon icon={faTrash} /> Borrar todas
            </button>
          </div>
        </div>

        <div className="notifications-content">
          {loading ? (
            <div className="loading">Cargando notificaciones...</div>
          ) : (
            <>
              {/* Sección de Reacciones */}
              <div className="notifications-section">
                <h2 className="section-title">Reacciones</h2>
                {notifications.reacciones.length > 0 ? (
                  notifications.reacciones.map(notif => {
                    const { icon, message, time, publicacionId } = getNotificationContent(notif);
                    return (
                      <div
                        key={notif.id}
                        className={`notification-item ${!notif.leida ? "unread" : ""}`}
                        onClick={() => handleNotificationClick(publicacionId)}
                        style={{ cursor: publicacionId ? 'pointer' : 'default' }}
                      >
                        <div className="notification-icon">{icon}</div>
                        <div className="notification-content">
                          <div className="notification-message">{message}</div>
                          <div className="notification-time">{time}</div>
                          {notif.imagen_publicacion && (
                            <img
                              src={notif.imagen_publicacion}
                              alt="Publicación"
                              className="notification-image"
                            />
                          )}
                        </div>
                        <button
                          className="delete-notification"
                          onClick={(e) => {
                            e.stopPropagation();
                            deleteNotification(notif.id);
                          }}
                        >
                          <FontAwesomeIcon icon={faTimes} />
                        </button>
                      </div>
                    );
                  })
                ) : (
                  <div className="empty-section">No hay notificaciones de reacciones</div>
                )}
              </div>

              {/* Sección de Comentarios */}
              <div className="notifications-section">
                <h2 className="section-title">Comentarios</h2>
                {notifications.comentarios.length > 0 ? (
                  notifications.comentarios.map(notif => {
                    const { icon, message, time, publicacionId } = getNotificationContent(notif);
                    return (
                      <div
                        key={notif.id}
                        className={`notification-item ${!notif.leida ? "unread" : ""}`}
                        onClick={() => handleNotificationClick(publicacionId)}
                        style={{ cursor: publicacionId ? 'pointer' : 'default' }}
                      >
                        <div className="notification-icon">{icon}</div>
                        <div className="notification-content">
                          <div className="notification-message">{message}</div>
                          <div className="notification-time">{time}</div>
                          {notif.imagen_publicacion && (
                            <img
                              src={notif.imagen_publicacion}
                              alt="Publicación"
                              className="notification-image"
                            />
                          )}
                        </div>
                        <button
                          className="delete-notification"
                          onClick={(e) => {
                            e.stopPropagation();
                            deleteNotification(notif.id);
                          }}
                        >
                          <FontAwesomeIcon icon={faTimes} />
                        </button>
                      </div>
                    );
                  })
                ) : (
                  <div className="empty-section">No hay notificaciones de comentarios</div>
                )}
              </div>
            </>
          )}
        </div>
      </div>

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

      {/* Modal de Publicación */}
      <PublicacionPropiaModal
        mostrar={showPropiaModal}
        onClose={() => setShowPropiaModal(false)}
        publicacion={selectedPublicacion}
        className="fullscreen-modal"
      />
    </div>
  );
};

export default NotificationsPage;