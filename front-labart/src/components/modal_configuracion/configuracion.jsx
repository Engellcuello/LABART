import React, { useState, useEffect } from 'react';
import PasswordResetModal from '../verificar_contrasena/verificacion';
import axios from 'axios';
import Swal from 'sweetalert2';

const ModalAjustes = ({ mostrar, onCerrar }) => {
  const [mostrarPasswordModal, setMostrarPasswordModal] = useState(false);
  const [contenidoExplicito, setContenidoExplicito] = useState(false);
  const idUsuario = localStorage.getItem("ID_usuario");

  // Obtener el estado actual del contenido explícito al abrir el modal
  useEffect(() => {
    if (mostrar && idUsuario) {
      axios.get(`http://127.0.0.1:5000/usuario/${idUsuario}`)
        .then(response => {
          setContenidoExplicito(response.data.Cont_Explicit || false);
        })
        .catch(error => {
          console.error("Error al obtener preferencias de usuario:", error);
        });
    }
  }, [mostrar, idUsuario]);

  const abrirPasswordModal = () => {
    setMostrarPasswordModal(true);
  };

  const cerrarPasswordModal = () => {
    setMostrarPasswordModal(false);
  };

  const handleContenidoExplicitoChange = async (e) => {
    const nuevoEstado = e.target.checked;
    setContenidoExplicito(nuevoEstado);

    try {
      await axios.put(`http://127.0.0.1:5000/usuario/${idUsuario}`, {
        Cont_Explicit: nuevoEstado
      }, {
        headers: {
          'Content-Type': 'application/json',
        }
      });

      // Actualizar el estado en localStorage
      localStorage.setItem("Cont_Explicit_user", nuevoEstado.toString());

      Swal.fire({
        icon: 'success',
        title: 'Preferencias actualizadas',
        text: `Contenido explícito ${nuevoEstado ? 'activado' : 'desactivado'}`,
        timer: 1500,
        showConfirmButton: false
      })
      window.location.reload();
      
    } catch (error) {
      console.error("Error al actualizar preferencias:", error);
      Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'No se pudo actualizar la preferencia',
      });
      // Revertir el cambio si hay error
      setContenidoExplicito(!nuevoEstado);
    }
  };

  if (!mostrar) return null;

  return (
    <>
      <div className="fondo-modal" onClick={onCerrar}>
        <div className="contenido-modal" onClick={(e) => e.stopPropagation()}>
          <div className="encabezado-modal">
            <div className="titulo-contenedor">
              <i className="fa-solid fa-gear icono-ajustes" />
              <h2>AJUSTES</h2>
            </div>
            <button className="boton-cerrar" onClick={onCerrar}>
              <i className="fa-solid fa-times" />
            </button>
          </div>

          <div className="contenido-ajustes">
            {/* Sección de Contenido Explícito */}
            <div className="seccion-ajustes">
              <div className="titulo-seccion">
                <i className="fa-solid fa-eye-slash icono-seccion" />
                <h3>CONTENIDO</h3>
              </div>
              <hr className="divisor" />

              <div className="opcion-ajuste">
                <span>Mostrar Contenido Explícito</span>
                <div className="descripcion-opcion">
                  <p>Activa esta opción para ver publicaciones con contenido explícito</p>
                </div>
                <label className="interruptor">
                  <input
                    type="checkbox"
                    checked={contenidoExplicito}
                    onChange={handleContenidoExplicitoChange}
                  />
                  <span className="deslizador"></span>
                </label>
              </div>
            </div>

            {/* Sección de Cuenta */}
            <div className="seccion-ajustes">
              <div className="titulo-seccion">
                <i className="fa-regular fa-user icono-seccion" />
                <h3>CUENTA</h3>
              </div>
              <hr className="divisor" />

              <a style={{ textDecoration: 'none' }} href='/editar-perfil'>
                <div className="opcion-ajuste">
                  <span>Editar Perfil</span>
                  <i className="fa-solid fa-chevron-right" />
                </div>
              </a>
              
              <div className="opcion-ajuste" onClick={abrirPasswordModal} style={{ cursor: 'pointer' }}>
                <span>Cambiar Contraseña</span>
                <i className="fa-solid fa-chevron-right" />
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Modal de recuperación de contraseña */}
      {mostrarPasswordModal && (
        <PasswordResetModal
          onClose={() => {
            cerrarPasswordModal();
            onCerrar();
          }}
        />
      )}
    </>
  );
};

export default ModalAjustes;