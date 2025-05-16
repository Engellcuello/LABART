import React, { useState, useEffect } from "react";
import axios from "axios";
import Swal from "sweetalert2";
import { Card, Button } from "react-bootstrap";

// Importación de imágenes
import asistente from '../crud/assets/asistente.png';
import categoria from '../crud/assets/categoria.png';
import color_publicacion from '../crud/assets/color_publicacion.png';
import comentario from '../crud/assets/comentario.png';
import estado from '../crud/assets/estado.png';
import etiqueta_publicacion from '../crud/assets/etiqueta_publicacion.png';
import historial from '../crud/assets/historial.png';
import notificaciones from '../crud/assets/notificaciones.png';
import pqrs from '../crud/assets/pqrs.png';
import publicacion from '../crud/assets/publicacion.png';
import publicacion_categoria from '../crud/assets/publicacion_categoria.png';
import publicacion_guardada from '../crud/assets/publicacion_guardada.png';
import publicacion_reaccion from '../crud/assets/publicacion_reaccion.png';
import reaccion from '../crud/assets/reaccion.png';
import rol from '../crud/assets/rol.png';
import sexo from '../crud/assets/sexo.png';
import tipo_pqrs from '../crud/assets/tipo_pqrs.png';
import tiponotificacion from '../crud/assets/tiponotificacion.png';
import usuario from '../crud/assets/usuario.png';
import usuario_reaccion from '../crud/assets/usuario_reaccion.png'; 
import logo from '../../assets/img/concepto_logo.png';

// Mapeo de imágenes
const imagesMap = {
  asistente: asistente,
  categoria: categoria,
  color_publicacion: color_publicacion,
  comentario: comentario,
  estado: estado,
  etiqueta_publicacion: etiqueta_publicacion,
  historial: historial,
  notificaciones: notificaciones,
  pqrs: pqrs,
  publicacion: publicacion,
  publicacion_categoria: publicacion_categoria,
  publicacion_guardada: publicacion_guardada,
  publicacion_reaccion: publicacion_reaccion,
  reaccion: reaccion,
  rol: rol,
  sexo: sexo,
  tipo_pqrs: tipo_pqrs,
  tiponotificacion: tiponotificacion,
  usuario: usuario,
  usuario_reaccion: usuario_reaccion
};

const Dashboard = ({ onTableSelect }) => {
  const [tables, setTables] = useState([]);

  useEffect(() => {
    axios
      .get("http://127.0.0.1:5000/api/tables")
      .then((response) => setTables(response.data))
      .catch((error) => console.error("Error fetching tables:", error));
  }, []);

  const cerrar_sesion = () => {
    Swal.fire({
      title: "¿QUIERES CERRAR LA SESIÓN?",
      showCancelButton: true,
      cancelButtonText: "Cancelar",
      confirmButtonText: "Sí",
      background: '#f8f9fa',
      confirmButtonColor: '#3182ce',
      cancelButtonColor: '#e53e3e'
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
          background: '#f8f9fa'
        });
        setTimeout(() => {
          window.location.href = "/";
        }, 1500);
      }
    });
  };

  return (
    <div className="container-fluid p-4" style={{ 
      background: 'linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%)',
      minHeight: '100vh'
    }}>
      {/* Header con logo, título y botón de cerrar sesión */}
      <div className="d-flex justify-content-between align-items-center mb-4 p-3" style={{
        background: 'linear-gradient(135deg, #2b6cb0 0%, #1a365d 100%)',
        borderRadius: '8px',
        boxShadow: '0 4px 6px rgba(0,0,0,0.1)',
        position: 'relative'
      }}>
        {/* Logo */}
        <img 
          src={logo} 
          alt="Logo" 
          style={{
            height: '100px',
            position: 'absolute',
            left: '20px'
          }}
        />

        {/* Título centrado */}
        <h2 className="text-center text-white font-weight-bold mb-0 mx-auto">
          <i className="fas fa-tachometer-alt mr-2"></i> Dashboard de Tablas
        </h2>

        {/* Botón de cerrar sesión a la derecha */}
        <button 
          onClick={cerrar_sesion}
          style={{
            background: 'rgba(255,255,255,0.2)',
            color: 'white',
            border: '1px solid rgba(255,255,255,0.3)',
            borderRadius: '6px',
            padding: '8px 16px',
            fontWeight: '500',
            transition: 'all 0.3s ease',
            position: 'absolute',
            right: '20px'
          }}
          onMouseOver={(e) => {
            e.currentTarget.style.background = 'rgba(255,255,255,0.3)';
            e.currentTarget.style.color = 'white';
          }}
          onMouseOut={(e) => {
            e.currentTarget.style.background = 'rgba(255,255,255,0.2)';
            e.currentTarget.style.color = 'white';
          }}
        >
          <i className="fas fa-sign-out-alt mr-2"></i> Cerrar Sesión
        </button>
      </div>

      {/* Grid de tablas (se mantiene igual) */}
      <div className="row">
        {tables.map((table, index) => (
          <div key={index} className="col-lg-3 col-md-4 col-sm-6 mb-4">
            <Card
              className="shadow-lg h-100"
              style={{
                border: 'none',
                borderRadius: '10px',
                overflow: 'hidden',
                transition: 'all 0.3s ease',
                cursor: 'pointer'
              }}
              onClick={() => onTableSelect(table)}
              onMouseEnter={(e) => {
                e.currentTarget.style.transform = "translateY(-5px)";
                e.currentTarget.style.boxShadow = "0 10px 20px rgba(0,0,0,0.15)";
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.transform = "translateY(0)";
                e.currentTarget.style.boxShadow = "0 4px 10px rgba(0,0,0,0.1)";
              }}
            >
              {/* Imagen de la tabla */}
              <div style={{
                height: '150px',
                overflow: 'hidden',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                backgroundColor: '#f8f9fa'
              }}>
                <img 
                  src={imagesMap[table]} 
                  alt={table}
                  style={{
                    maxHeight: '100%',
                    maxWidth: '100%',
                    objectFit: 'contain',
                    padding: '10px'
                  }}
                />
              </div>
              
              <Card.Body className="text-center">
                <Card.Title style={{ color: '#2D3748', fontWeight: '600' }}>
                  {table.replace(/_/g, ' ')}
                </Card.Title>
                <Card.Text style={{ color: '#718096', fontSize: '0.9rem' }}>
                  Haz clic para administrar esta tabla
                </Card.Text>
              </Card.Body>
              
              <div 
                className="text-center py-2"
                style={{
                  background: 'linear-gradient(135deg, #4299e1 0%, #3182ce 100%)',
                  color: 'white'
                }}
              >
                <small>Seleccionar Tabla</small>
              </div>
            </Card>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Dashboard;