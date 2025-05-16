import React, { useState, useEffect } from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import "@fortawesome/fontawesome-free/css/all.min.css";
import axios from "axios";
import { Modal, ModalHeader, ModalBody, ModalFooter } from "reactstrap";

const TablePage = ({ tableName, onBack }) => {
  const [data, setData] = useState([]);
  const [modalOpen, setModalOpen] = useState(false);
  const [editMode, setEditMode] = useState(false);
  const [formData, setFormData] = useState({});
  const [primaryKey, setPrimaryKey] = useState(null);
  const [foreignKeys, setForeignKeys] = useState([]);
  const [relatedData, setRelatedData] = useState({});
  const [currentPage, setCurrentPage] = useState(1);
  const [itemsPerPage] = useState(10);
  const [visibleColumns, setVisibleColumns] = useState({});

  // Limpiar estados cuando cambie la tabla
  useEffect(() => {
    setData([]);
    setModalOpen(false);
    setEditMode(false);
    setFormData({});
    setPrimaryKey(null);
    setForeignKeys([]);
    setRelatedData({});
    setCurrentPage(1);
    setVisibleColumns({});
    fetchData();
    fetchForeignKeys();
  }, [tableName]);

  const fetchForeignKeys = async () => {
    try {
      const response = await axios.get(`/api/foreign-keys/${tableName}`);
      setForeignKeys(response.data);
      
      const related = {};
      for (const fk of response.data) {
        const res = await axios.get(`/${fk.related_table}`);
        related[fk.column] = {
          data: res.data,
          displayField: fk.display_field,
          relatedTable: fk.related_table
        };
      }
      setRelatedData(related);
    } catch (error) {
      console.error("Error fetching foreign keys:", error);
    }
  };

  const fetchData = async () => {
    try {
      const response = await axios.get(`/${tableName}`);
      setData(response.data);

      if (response.data.length > 0) {
        const keys = Object.keys(response.data[0]);
        setPrimaryKey(keys[0]);
        
        // Inicializar columnas visibles
        const initialVisible = {};
        keys.forEach(key => {
          initialVisible[key] = true;
        });
        setVisibleColumns(initialVisible);
      }
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  };

  const handleSave = async () => {
    try {
      if (editMode) {
        if (!formData[primaryKey]) {
          console.error("Error: Falta el ID para actualizar.");
          return;
        }
        await axios.put(`/${tableName}/${formData[primaryKey]}`, formData);
      } else {
        await axios.post(`/${tableName}`, formData);
      }
      fetchData();
      closeModal();
    } catch (error) {
      console.error("Error saving data:", error);
    }
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`/${tableName}/${id}`);
      fetchData();
    } catch (error) {
      console.error("Error deleting data:", error);
    }
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData({
      ...formData,
      [name]: type === "checkbox" ? checked : value,
    });
  };

  const getRelatedName = (column, id) => {
    if (!relatedData[column] || !id) return id;
    
    // Caso especial para ID_tipo_notificacion
    if (column === 'ID_tipo_notificacion') {
      const relatedItem = relatedData[column].data.find(
        item => item.ID_tipo_notificacion == id || item.id == id
      );
      return relatedItem ? `${id} (${relatedItem.Nombre})` : id;
    }
  
    // Caso general para otras relaciones
    const relatedItem = relatedData[column].data.find(
      item => item[`ID_${relatedData[column].relatedTable}`] == id || 
             item.id == id
    );
    
    return relatedItem ? 
      `${id} (${relatedItem[relatedData[column].displayField] || id})` : 
      id;
  };

  const openModal = (item = {}) => {
    if (Object.keys(item).length === 0) {
      const lastId = data.length > 0 ? Math.max(...data.map(d => parseInt(d[primaryKey] || 0, 10))) : 0;
      const newEntry = data.length > 0 ? Object.keys(data[0]).reduce((acc, key) => {
        acc[key] = key === primaryKey ? lastId + 1 : "";
        return acc;
      }, {}) : {};
      setFormData(newEntry);
    } else {
      setFormData(item);
    }
    setEditMode(!!item[primaryKey]);
    setModalOpen(true);
  };

  const closeModal = () => {
    setModalOpen(false);
    setFormData({});
    setEditMode(false);
  };

  const renderInputField = (key) => {
    // 1. Primero verificar si es un campo de relación (foreign key)
    const fk = foreignKeys.find(f => f.column === key);
    
    if (fk) {
      const relatedItems = relatedData[key]?.data || [];
      const currentValue = formData[key] || "";
      
      // Caso especial para ID_tipo_notificacion
      if (key === 'ID_tipo_notificacion') {
        return (
          <select
            className="form-control"
            name={key}
            value={currentValue}
            onChange={handleChange}
          >
            <option value="">Seleccione un tipo</option>
            {relatedItems.map(item => (
              <option key={item.ID_tipo_notificacion} value={item.ID_tipo_notificacion}>
                {item.Nombre}
              </option>
            ))}
          </select>
        );
      }
      
      // Caso general para otras relaciones
      return (
        <select
          className="form-control"
          name={key}
          value={currentValue}
          onChange={handleChange}
        >
          <option value="">Seleccione una opción</option>
          {relatedItems.map(item => {
            const id = item[`ID_${fk.related_table}`] || item.id;
            const displayValue = item[fk.display_field] || `ID: ${id}`;
            return (
              <option key={id} value={id}>
                {displayValue} (ID: {id})
              </option>
            );
          })}
        </select>
      );
    }
  
    // 2. Campos booleanos específicos
    const booleanFields = ["cont_explicit_publi","cont_explicit", "notificaciones", "leido"];
    if (booleanFields.some(field => key.toLowerCase() === field.toLowerCase())) {
      return (
        <select
          className="form-control"
          name={key}
          value={formData[key] !== undefined ? formData[key].toString() : "false"}
          onChange={(e) => setFormData({...formData, [key]: e.target.value === "true"})}
          style={{
            backgroundColor: '#fff',
            color: '#2D3748',
            border: '1px solid #E2E8F0',
            borderRadius: '6px',
            padding: '8px 12px'
          }}
        >
          <option value="false">No</option>
          <option value="true">Sí</option>
        </select>
      );
    }
  
    // 3. Campos de fecha
    if (key.toLowerCase().includes("fecha")) {
      return (
        <input
          className="form-control"
          type="date"
          name={key}
          value={formData[key] ? formData[key].split("T")[0] : ""}
          onChange={handleChange}
          style={{
            backgroundColor: '#fff',
            color: '#2D3748',
            border: '1px solid #E2E8F0',
            borderRadius: '6px',
            padding: '8px 12px'
          }}
        />
      );
    }
  
    // 4. Campo primario (ID)
    if (key === primaryKey) {
      return (
        <input
          className="form-control"
          type="text"
          name={key}
          value={formData[key] || ""}
          disabled
          style={{
            backgroundColor: '#EDF2F0',
            color: '#2D3748',
            border: '1px solid #E2E8F0',
            borderRadius: '6px',
            padding: '8px 12px',
            cursor: "not-allowed"
          }}
        />
      );
    }
  
    // 5. Campo de texto normal
    return (
      <input
        className="form-control"
        type="text"
        name={key}
        value={formData[key] || ""}
        onChange={handleChange}
        style={{
          backgroundColor: '#fff',
          color: '#2D3748',
          border: '1px solid #E2E8F0',
          borderRadius: '6px',
          padding: '8px 12px'
        }}
      />
    );
  };

  // Calcular datos paginados
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentItems = data.slice(indexOfFirstItem, indexOfLastItem);

  return (
    <div className="container-fluid p-0 d-flex" style={{ 
      background: 'linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%)',
      minHeight: '100vh'
    }}>
      <div className="flex-grow-1 p-4">
        {/* Header */}
        <div className="d-flex justify-content-between align-items-center mb-4 p-3 rounded" style={{
          background: 'linear-gradient(135deg, #2b6cb0 0%, #1a365d 100%)',
          boxShadow: '0 4px 6px rgba(0,0,0,0.1)'
        }}>
          <h2 className="text-center w-100 text-white font-weight-bold mb-0">
            <i className="fas fa-table mr-2"></i> 
            {tableName.toUpperCase()}
          </h2>
          <button 
            className="btn btn-outline-light"
            onClick={onBack}
            style={{
              background: 'rgba(255,255,255,0.1)',
              borderColor: 'rgba(255,255,255,0.3)',
              transition: 'all 0.3s ease',
              fontWeight: '500'
            }}
            onMouseOver={(e) => e.currentTarget.style.background = 'rgba(255,255,255,0.2)'}
            onMouseOut={(e) => e.currentTarget.style.background = 'rgba(255,255,255,0.1)'}
          >
            <i className="fas fa-arrow-left mr-2"></i> Regresar
          </button>
        </div>

        {/* Actions Bar */}
        <div className="d-flex justify-content-between align-items-center mb-4 p-3 rounded" style={{
          background: 'white',
          boxShadow: '0 2px 4px rgba(0,0,0,0.05)'
        }}>
          <div>
            <button 
              className="btn btn-primary mr-2"
              onClick={() => openModal({})}
              style={{
                background: 'linear-gradient(135deg, #4299e1 0%, #3182ce 100%)',
                border: 'none',
                borderRadius: '6px',
                fontWeight: '500',
                transition: 'all 0.3s ease'
              }}
              onMouseOver={(e) => e.currentTarget.style.opacity = '0.9'}
              onMouseOut={(e) => e.currentTarget.style.opacity = '1'}
            >
              <i className="fas fa-plus mr-2"></i> Agregar Dato
            </button>
            <button 
              className="btn btn-info"
              onClick={() => {
                const allHidden = Object.values(visibleColumns).every(v => v === false);
                const newVisible = {};
                Object.keys(data[0] || {}).forEach(key => {
                  newVisible[key] = allHidden ? true : false;
                });
                setVisibleColumns(newVisible);
              }}
              style={{
                background: 'linear-gradient(135deg, #38b2ac 0%, #319795 100%)',
                border: 'none',
                borderRadius: '6px',
                fontWeight: '500',
                transition: 'all 0.3s ease'
              }}
            >
              <i className={`fas fa-eye${Object.values(visibleColumns).every(v => v === false) ? '' : '-slash'} mr-2`}></i>
              {Object.values(visibleColumns).every(v => v === false) ? 'Mostrar' : 'Ocultar'} Columnas
            </button>
          </div>
          <span className="text-dark font-weight-bold">Total registros: {data.length}</span>
        </div>

        {/* Table */}
        <div className="table-responsive" style={{
          maxWidth: '100%',
          overflowX: 'auto',
          border: '1px solid #E2E8F0',
          borderRadius: '8px',
          boxShadow: '0 2px 4px rgba(0,0,0,0.05)'
        }}>
          <table className="table table-hover mb-0" style={{
            minWidth: 'max-content',
            width: '100%'
          }}>
            <thead>
              <tr style={{ 
                background: 'linear-gradient(135deg, #2b6cb0 0%, #1a365d 100%)',
                color: 'white'
              }}>
                {data[0] && Object.keys(data[0]).map((key, index) => (
                  <th 
                    key={`${key}-${index}`} 
                    style={{ 
                      fontWeight: '600', 
                      padding: '12px 16px',
                      display: visibleColumns[key] === false ? 'none' : 'table-cell',
                      position: 'sticky',
                      top: 0
                    }}
                  >
                    <div className="d-flex align-items-center justify-content-between">
                      <span>{key}</span>
                      <button 
                        className="btn btn-sm ml-2"
                        onClick={() => setVisibleColumns({...visibleColumns, [key]: !visibleColumns[key]})}
                        style={{
                          background: 'rgba(255,255,255,0.1)',
                          border: 'none',
                          color: 'white',
                          padding: '2px 5px',
                          borderRadius: '4px'
                        }}
                      >
                        <i className={`fas fa-eye${visibleColumns[key] === false ? '' : '-slash'}`}></i>
                      </button>
                    </div>
                  </th>
                ))}
                <th style={{ 
                  fontWeight: '600', 
                  padding: '12px 16px',
                  position: 'sticky',
                  top: 0,
                  background: 'linear-gradient(135deg, #2b6cb0 0%, #1a365d 100%)'
                }}>
                  Acciones
                </th>
              </tr>
            </thead>
            <tbody>
              {currentItems.map((item, rowIndex) => (
                <tr 
                  key={item[primaryKey]} 
                  style={{ 
                    transition: 'all 0.2s ease',
                    backgroundColor: rowIndex % 2 === 0 ? '#fff' : '#F7FAFC'
                  }}
                  onMouseOver={(e) => e.currentTarget.style.backgroundColor = '#EBF8FF'}
                  onMouseOut={(e) => e.currentTarget.style.backgroundColor = rowIndex % 2 === 0 ? '#fff' : '#F7FAFC'}
                >
                  {Object.keys(item).map((key, index) => (
                    <td 
                      key={`${primaryKey}-${index}`} 
                      style={{ 
                        color: '#2D3748',
                        padding: '12px 16px',
                        borderBottom: '1px solid #EDF2F7',
                        display: visibleColumns[key] === false ? 'none' : 'table-cell',
                        maxWidth: '200px',
                        overflow: 'hidden',
                        textOverflow: 'ellipsis',
                        whiteSpace: 'nowrap'
                      }}
                      title={typeof item[key] === 'string' ? item[key] : JSON.stringify(item[key])}
                    >
                      {key === "contrasena_hash" ? "********" : 
                       foreignKeys.some(fk => fk.column === key) ? getRelatedName(key, item[key]) : 
                       typeof item[key] === 'boolean' ? (item[key] ? 'Sí' : 'No') :
                       item[key]}
                    </td>
                  ))}
                  <td style={{ 
                    padding: '12px 16px', 
                    borderBottom: '1px solid #EDF2F7',
                    position: 'sticky',
                    right: 0,
                    background: rowIndex % 2 === 0 ? '#fff' : '#F7FAFC'
                  }}>
                    <button 
                      className="btn btn-sm me-2"
                      onClick={() => openModal(item)}
                      style={{
                        background: 'rgba(234, 179, 8, 0.1)',
                        color: '#D97706',
                        border: '1px solid rgba(234, 179, 8, 0.3)',
                        borderRadius: '4px',
                        padding: '5px 10px',
                        transition: 'all 0.3s ease'
                      }}
                      onMouseOver={(e) => {
                        e.currentTarget.style.background = 'rgba(234, 179, 8, 0.2)';
                        e.currentTarget.style.color = '#B45309';
                      }}
                      onMouseOut={(e) => {
                        e.currentTarget.style.background = 'rgba(234, 179, 8, 0.1)';
                        e.currentTarget.style.color = '#D97706';
                      }}
                    >
                      <i className="fas fa-edit mr-1"></i> Editar
                    </button>
                    <button 
                      className="btn btn-sm"
                      onClick={() => handleDelete(item[primaryKey])}
                      style={{
                        background: 'rgba(220, 38, 38, 0.1)',
                        color: '#DC2626',
                        border: '1px solid rgba(220, 38, 38, 0.3)',
                        borderRadius: '4px',
                        padding: '5px 10px',
                        transition: 'all 0.3s ease'
                      }}
                      onMouseOver={(e) => {
                        e.currentTarget.style.background = 'rgba(220, 38, 38, 0.2)';
                        e.currentTarget.style.color = '#B91C1C';
                      }}
                      onMouseOut={(e) => {
                        e.currentTarget.style.background = 'rgba(220, 38, 38, 0.1)';
                        e.currentTarget.style.color = '#DC2626';
                      }}
                    >
                      <i className="fas fa-trash mr-1"></i> Eliminar
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Paginación */}
        <div className="d-flex justify-content-between align-items-center mt-3 p-3 rounded" style={{
          background: 'white',
          boxShadow: '0 2px 4px rgba(0,0,0,0.05)'
        }}>
          <div>
            Mostrando {indexOfFirstItem + 1} a {Math.min(indexOfLastItem, data.length)} de {data.length} registros
          </div>
          <div>
            <button 
              className="btn btn-sm mx-1"
              onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
              disabled={currentPage === 1}
              style={{
                background: currentPage === 1 ? '#E2E8F0' : '#4299E1',
                color: currentPage === 1 ? '#A0AEC0' : 'white',
                border: 'none',
                borderRadius: '4px',
                padding: '5px 10px',
                transition: 'all 0.3s ease'
              }}
            >
              <i className="fas fa-chevron-left mr-1"></i> Anterior
            </button>
            {Array.from({length: Math.ceil(data.length / itemsPerPage)}).map((_, i) => (
              <button
                key={i}
                className={`btn btn-sm mx-1 ${currentPage === i + 1 ? 'btn-primary' : 'btn-outline-primary'}`}
                onClick={() => setCurrentPage(i + 1)}
                style={{
                  minWidth: '32px',
                  borderRadius: '4px',
                  transition: 'all 0.3s ease'
                }}
              >
                {i + 1}
              </button>
            ))}
            <button 
              className="btn btn-sm mx-1"
              onClick={() => setCurrentPage(prev => Math.min(prev + 1, Math.ceil(data.length / itemsPerPage)))}
              disabled={currentPage === Math.ceil(data.length / itemsPerPage)}
              style={{
                background: currentPage === Math.ceil(data.length / itemsPerPage) ? '#E2E8F0' : '#4299E1',
                color: currentPage === Math.ceil(data.length / itemsPerPage) ? '#A0AEC0' : 'white',
                border: 'none',
                borderRadius: '4px',
                padding: '5px 10px',
                transition: 'all 0.3s ease'
              }}
            >
              Siguiente <i className="fas fa-chevron-right ml-1"></i>
            </button>
          </div>
        </div>

        {/* Modal */}
        <Modal isOpen={modalOpen} toggle={closeModal} size="lg">
          <ModalHeader 
            toggle={closeModal} 
            style={{
              background: 'linear-gradient(135deg, #2b6cb0 0%, #1a365d 100%)',
              color: 'white',
              borderBottom: '1px solid #2C5282'
            }}
          >
            {editMode ? "Editar Registro" : "Agregar Nuevo Registro"}
          </ModalHeader>
          <ModalBody style={{ backgroundColor: '#F7FAFC' }}>
            {Object.keys(formData).map(key => (
              <div className="form-group mb-3" key={key}>
                <label className="font-weight-bold" style={{ color: '#2D3748', marginBottom: '6px' }}>{key}</label>
                {renderInputField(key)}
              </div>
            ))}
          </ModalBody>
          <ModalFooter style={{ 
            backgroundColor: '#F7FAFC',
            borderTop: '1px solid #E2E8F0'
          }}>
            <button 
              className="btn"
              onClick={handleSave}
              style={{
                background: 'linear-gradient(135deg, #4299e1 0%, #3182ce 100%)',
                color: 'white',
                border: 'none',
                borderRadius: '6px',
                padding: '8px 16px',
                fontWeight: '500',
                transition: 'all 0.3s ease'
              }}
              onMouseOver={(e) => e.currentTarget.style.opacity = '0.9'}
              onMouseOut={(e) => e.currentTarget.style.opacity = '1'}
            >
              {editMode ? "Actualizar" : "Guardar"}
            </button>
            <button 
              className="btn"
              onClick={closeModal}
              style={{
                background: 'rgba(226, 232, 240, 0.8)',
                color: '#4A5568',
                border: '1px solid #E2E8F0',
                borderRadius: '6px',
                padding: '8px 16px',
                fontWeight: '500',
                transition: 'all 0.3s ease'
              }}
              onMouseOver={(e) => {
                e.currentTarget.style.background = 'rgba(203, 213, 224, 0.8)';
                e.currentTarget.style.color = '#2D3748';
              }}
              onMouseOut={(e) => {
                e.currentTarget.style.background = 'rgba(226, 232, 240, 0.8)';
                e.currentTarget.style.color = '#4A5568';
              }}
            >
              Cancelar
            </button>
          </ModalFooter>
        </Modal>
      </div>
    </div>
  );
};

export default TablePage;