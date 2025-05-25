import React, { useState, useEffect } from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import "@fortawesome/fontawesome-free/css/all.min.css";
import axios from '../../utils/axiosintance';
import { Modal, ModalHeader, ModalBody, ModalFooter } from "reactstrap";



const TablePage = ({ tableName, onBack }) => {
  const [data, setData] = useState([]);
  const [modalOpen, setModalOpen] = useState(false);
  const [editMode, setEditMode] = useState(false);
  const [formData, setFormData] = useState({});
  const [primaryKey, setPrimaryKey] = useState(null); // Clave primaria dinámica

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const response = await axios.get(`/${tableName}`);
      setData(response.data);
      
      if (response.data.length > 0) {
        // Detectar automáticamente la clave primaria (asumimos que es el primer campo)
        const keys = Object.keys(response.data[0]);
        setPrimaryKey(keys[0]); 
      }
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  };

  const handleSave = async () => {
    try {
      if (editMode) {
        await axios.put(`/${tableName}/${formData["ID_" + tableName]}`, formData);
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
      await axios.put(`/${tableName}/${formData["ID_" + tableName]}`, formData);
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

  const openModal = (item = {}) => {
    setEditMode(!!formData["ID_" + tableName]);
    setFormData(item);
    setModalOpen(true);
  };

  const closeModal = () => setModalOpen(false);

  return (
    <div className="container mt-4">
      <div className="d-flex justify-content-between align-items-center p-3 bg-light shadow-sm">
        <h2 className="text-center w-100">CRUD {tableName.toUpperCase()}</h2>
        <button className="btn btn-secondary" onClick={onBack}>Regresar</button>
      </div>
      <div className="d-flex justify-content-between align-items-center p-2 bg-light shadow-sm mt-3">
        <button className="btn btn-success" onClick={() => openModal({})}>
          <i className="fas fa-plus"></i> Agregar Dato
        </button>
        <span>Total registros: {data.length}</span>
      </div>
      <div className="table-responsive bg-white shadow p-3 mt-3">
        <table className="table table-striped text-center">
          <thead className="table-dark">
            <tr>
              {data[0] && Object.keys(data[0]).map((key) => <th key={key}>{key}</th>)}
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {data.map((item) => (
              <tr key={item[primaryKey]}>
                {Object.values(item).map((val, index) => (
                  <td key={index}>{typeof val === "boolean" ? (val ? "Sí" : "No") : val}</td>
                ))}
                <td>
                  <button className="btn btn-warning btn-sm me-2" onClick={() => openModal(item)}>
                    <i className="fas fa-edit"></i>
                  </button>
                  <button className="btn btn-danger btn-sm" onClick={() => handleDelete(item[formData["ID_" + tableName]])}>
                    <i className="fas fa-trash"></i>
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Modal isOpen={modalOpen} toggle={closeModal}>
        <ModalHeader toggle={closeModal}>{editMode ? "Editar" : "Agregar"} Registro</ModalHeader>
        <ModalBody>
          {Object.keys(formData).map((key) => (
            <div className="form-group" key={key}>
              <label>{key}</label>
              <input
                className="form-control"
                type={typeof formData[key] === "boolean" ? "checkbox" : "text"}
                name={key}
                checked={typeof formData[key] === "boolean" ? formData[key] : undefined}
                value={typeof formData[key] === "boolean" ? undefined : formData[key]}
                onChange={handleChange}
                disabled={editMode && key === primaryKey} // Evita modificar la clave primaria al editar
              />
            </div>
          ))}
        </ModalBody>
        <ModalFooter>
          <button className="btn btn-success" onClick={handleSave}>{editMode ? "Actualizar" : "Insertar"}</button>
          <button className="btn btn-danger" onClick={closeModal}>Cancelar</button>
        </ModalFooter>
      </Modal>
    </div>
  );
};

export default TablePage;