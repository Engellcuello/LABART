import React from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import "@fortawesome/fontawesome-free/css/all.min.css";
import logo from '../../assets/img/concepto_logo.png';

const Sidebar = ({ currentTable, onTableSelect, showTables, setShowTables }) => {
  const tables = [
    'asistente', 'categoria', 'color_publicacion', 'comentario', 
    'estado', 'etiqueta_publicacion', 'historial', 'notificaciones',
    'pqrs', 'publicacion', 'publicacion_categoria', 'publicacion_guardada',
    'publicacion_reaccion', 'reaccion', 'rol', 'sexo',
    'tipo_pqrs', 'tiponotificacion', 'usuario', 'usuario_reaccion'
  ];

  return (
    <div className="d-flex flex-column p-3"
      style={{
        width: showTables ? '300px' : '80px',
        minHeight: '100vh',
        background: 'linear-gradient(135deg, #2b6cb0 0%, #1a365d 100%)',
        boxShadow: '0 4px 6px rgba(0,0,0,0.1)',
        color: 'white',
        transition: 'width 0.3s ease'
      }}>
      
      <div className="d-flex justify-content-between align-items-center mb-4">
        {showTables && (
          <img src={logo} alt="Logo" style={{ height: '125px' }} />
        )}
        <button 
          className="btn btn-link text-white"
          onClick={() => setShowTables(!showTables)}
          style={{ fontSize: '1.5rem' }}
        >
          <i className={`fas ${showTables ? 'fa-times' : 'fa-bars'}`}></i>
        </button>
      </div>

      {showTables && currentTable && (
        <div className="mb-3 p-2 rounded" style={{ background: 'rgba(255,255,255,0.1)' }}>
          <small>Tabla actual:</small>
          <div className="font-weight-bold">{currentTable}</div>
        </div>
      )}

      {showTables && (
        <div className="flex-grow-1" style={{ overflowY: 'auto' }}>
          <h5 className="mb-3">Tablas disponibles</h5>
          <ul className="list-unstyled">
            {tables.map((table, index) => (
              <li key={index} className="mb-2">
                <button
                  className="btn btn-block text-left text-white"
                  onClick={() => onTableSelect(table)}
                  style={{
                    background: table === currentTable ? 'rgba(66, 153, 225, 0.3)' : 'transparent',
                    borderRadius: '4px',
                    transition: 'all 0.2s ease'
                  }}
                  onMouseOver={(e) => {
                    e.currentTarget.style.background = 'rgba(66, 153, 225, 0.2)';
                  }}
                  onMouseOut={(e) => {
                    e.currentTarget.style.background = table === currentTable ? 
                      'rgba(66, 153, 225, 0.3)' : 'transparent';
                  }}
                >
                  {table.replace(/_/g, ' ')}
                </button>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
};

export default Sidebar;