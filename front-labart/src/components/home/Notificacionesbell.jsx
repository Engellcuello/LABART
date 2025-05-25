// components/NotificationBell.jsx
import React, { useState, useEffect } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBell } from "@fortawesome/free-regular-svg-icons";
import { useNavigate } from "react-router-dom";
import axios from '../../utils/axiosintance';

const NotificationBell = () => {
  const [unreadCount, setUnreadCount] = useState(0);
  const navigate = useNavigate();
  const currentUserId = parseInt(localStorage.getItem("ID_usuario"), 10);

  useEffect(() => {
    if (currentUserId) {
      fetchUnreadCount();
      // Opcional: refrescar cada 30 segundos
      const interval = setInterval(fetchUnreadCount, 30000);
      return () => clearInterval(interval);
    }
  }, [currentUserId]);

  const fetchUnreadCount = async () => {
    try {
      const response = await axios.get(`/notificaciones/tiene_no_leidas/${currentUserId}`);
      setUnreadCount(response.data.cantidad || 0);
    } catch (error) {
      console.error("Error fetching unread count:", error);
    }
  };

  const handleClick = () => {
    navigate("/notificaciones");
  };

  return (
    <div className="icono_centro icono_cabeza notificacion" onClick={handleClick}>
      <FontAwesomeIcon icon={faBell} className="iconos" />
      {unreadCount > 0 && <span className="notification-badge">{unreadCount}</span>}
    </div>
  );
};

export default NotificationBell;