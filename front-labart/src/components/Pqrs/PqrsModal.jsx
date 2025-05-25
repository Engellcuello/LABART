import React, { useState } from 'react';
import axios from '../../utils/axiosintance';
import '../../assets/styles/pqrs/pqrs.css';

const PqrsModal = ({ onClose }) => {
    // Obtener ID_usuario correctamente
    const userId = localStorage.getItem('ID_usuario') || 
                   JSON.parse(localStorage.getItem('userData'))?.ID_usuario;
  
    const [formData, setFormData] = useState({
      Contenido_pqrs: '',
      ID_tipo_pqrs: 1,
      ID_usuario: userId,
      Fecha_pqrs: new Date().toISOString().split('T')[0],
      ID_estado: 1 // Valor por defecto para el estado
    });
    
    const [tiposPqrs, setTiposPqrs] = useState([]);
    const [isLoading, setIsLoading] = useState(false);
    const [message, setMessage] = useState('');
  
    React.useEffect(() => {
      const fetchTiposPqrs = async () => {
        try {
          const response = await axios.get('/tipo_pqrs');
          console.log('Tipos PQRS recibidos:', response.data);
          setTiposPqrs(response.data);
        } catch (error) {
          console.error('Error al cargar tipos de PQRS:', error);
          setMessage('Error al cargar tipos de PQRS');
        }
      };
      fetchTiposPqrs();
    }, []);
  
    const handleChange = (e) => {
      const { name, value } = e.target;
      setFormData(prev => ({
        ...prev,
        [name]: value
      }));
    };
  
    const handleSubmit = async (e) => {
      e.preventDefault();
      
      if (!userId) {
        setMessage('No se pudo identificar al usuario. Por favor inicie sesión.');
        return;
      }
  
      setIsLoading(true);
      setMessage('');
      
      try {
        const response = await axios.post('/pqrs', {
          ...formData,
          ID_usuario: userId
          // ID_estado ya está incluido en formData
        });
        setMessage('PQRS enviada correctamente');
        setTimeout(() => {
          onClose();
        }, 1500);
      } catch (error) {
        console.error('Error al enviar PQRS:', error);
        setMessage('Error al enviar la PQRS: ' + (error.response?.data?.message || error.message));
      } finally {
        setIsLoading(false);
      }
    };

  return (
    <div className="pqrs-modal-overlay">
      <div className="pqrs-modal-container">
        <button className="pqrs-close-btn" onClick={onClose}>×</button>
        <h2 className="pqrs-modal-title">Enviar PQRS</h2>
        
        <form className="pqrs-form" onSubmit={handleSubmit}>
          <div className="pqrs-form-field">
            <label className="pqrs-form-label">Tipo de PQRS:</label>
            <select 
              className="pqrs-form-select"
              name="ID_tipo_pqrs" 
              value={formData.ID_tipo_pqrs} 
              onChange={handleChange}
              required
            >
              {tiposPqrs.map(tipo => (
                <option key={tipo.ID_tipo_pqrs} value={tipo.ID_tipo_pqrs}>
                  {tipo.Nombre_tipo}
                </option>
              ))}
            </select>
          </div>
          
          <div className="pqrs-form-field">
            <label className="pqrs-form-label">Mensaje:</label>
            <textarea
              className="pqrs-form-textarea"
              name="Contenido_pqrs"
              value={formData.Contenido_pqrs}
              onChange={handleChange}
              required
              rows="5"
              placeholder="Describe tu petición, queja, reclamo o sugerencia..."
            />
          </div>
          
          <button 
            type="submit" 
            className="pqrs-submit-btn"
            disabled={isLoading}
          >
            {isLoading ? 'Enviando...' : 'Enviar PQRS'}
          </button>
          
          {message && (
            <p className={`pqrs-message ${message.includes('Error') ? 'pqrs-error' : 'pqrs-success'}`}>
              {message}
            </p>
          )}
        </form>
      </div>
    </div>
  );
};

export default PqrsModal;