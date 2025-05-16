import { useState, useRef, useEffect } from 'react';
import axios from 'axios';
import Swal from 'sweetalert2';

const PublicacionModal = ({ mostrar, onClose }) => {
  const [file, setFile] = useState(null);
  const [preview, setPreview] = useState(null);
  const [titulo, setTitulo] = useState('');
  const [descripcion, setDescripcion] = useState('');
  const [contenidoExplicito, setContenidoExplicito] = useState(false);
  const [categorias, setCategorias] = useState([]);
  const [categoriasDisponibles, setCategoriasDisponibles] = useState([]);
  const [categoriasSeleccionadas, setCategoriasSeleccionadas] = useState([]);
  const [showCategoriasModal, setShowCategoriasModal] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  const fileInputRef = useRef(null);
  const modalRef = useRef(null);

  useEffect(() => {
    const fetchCategorias = async () => {
      try {
        const response = await axios.get('/categoria'); 
        setCategoriasDisponibles(response.data);
      } catch (error) {
        console.error('Error al obtener categorías:', error);
      }
    };
    
    fetchCategorias();
  }, []);

  // Manejar el archivo seleccionado
  const handleFileChange = (e) => {
    const selectedFile = e.target.files[0];
    if (!selectedFile) return;

    setFile(selectedFile);

    // Crear vista previa
    const reader = new FileReader();
    reader.onloadend = () => {
      setPreview(reader.result);
    };
    
    if (selectedFile.type.includes('image')) {
      reader.readAsDataURL(selectedFile);
    } else if (selectedFile.type.includes('video')) {
      reader.readAsDataURL(selectedFile);
    }
  };

  // Eliminar archivo seleccionado
  const removeFile = () => {
    setFile(null);
    setPreview(null);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
  
    try {
      const ID_usuario = localStorage.getItem('ID_usuario');
  
      if (!ID_usuario) {
        throw new Error('No se encontró el ID de usuario');
      }

      // Validar datos antes de enviar
      if (!titulo || !descripcion) {
        throw new Error('El título y la descripción son requeridos');
      }

      // Validar categorías (usando categoriasSeleccionadas)
      if (categoriasSeleccionadas.length === 0) {
        throw new Error('Debes seleccionar al menos una categoría');
      }

      // 1. Crear FormData para la publicación
      const formData = new FormData();
      formData.append('Titulo_publicacion', titulo);
      formData.append('Descripcion_publicacion', descripcion);
      formData.append('Cont_Explicit_publi', contenidoExplicito);
      formData.append('ID_usuario', ID_usuario);
      
      // Agregar la imagen si existe
      if (file) {
        const validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        const maxSize = 10 * 1024 * 1024; // 10MB

        if (!validTypes.includes(file.type)) {
          throw new Error('Formato de imagen no soportado. Use JPEG, PNG, GIF o WEBP');
        }

        if (file.size > maxSize) {
          throw new Error('La imagen es demasiado grande (máximo 10MB)');
        }

        formData.append('Img_publicacion', file);
      }

      Swal.fire({
        title: 'Creando publicación...',
        html: 'Por favor espere mientras se procesa su publicación',
        allowOutsideClick: false,
        didOpen: () => {
          Swal.showLoading();
        }
      });

      const publicacionResponse = await axios.post('/publicacion', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        },
        validateStatus: (status) => status < 500
      });
  
      if (publicacionResponse.status >= 400) {
        throw new Error(publicacionResponse.data?.error || publicacionResponse.data?.message || 'Error al crear la publicación');
      }

      const ID_publicacion = publicacionResponse.data.ID_publicacion;

      const categoriasPromises = categoriasSeleccionadas.map(async (ID_categoria) => {
        try {
          await axios.post('/publicacion_categoria', {
            ID_publicacion,
            ID_categoria
          });
        } catch (error) {
          console.error(`Error asociando categoría ${ID_categoria}:`, error);
         
        }
      });

      await Promise.all(categoriasPromises);
  
      
      onClose();
      resetForm();
      setCategoriasSeleccionadas([]);
  
      Swal.fire({
        title: '¡Éxito!',
        text: 'Publicación creada correctamente con sus categorías',
        icon: 'success',
        confirmButtonText: 'Aceptar'
      });
  
    } catch (error) {
      console.error('Error completo en handleSubmit:', {
        message: error.message,
        stack: error.stack,
        response: error.response?.data
      });
  
      Swal.fire({
        title: 'Error',
        text: error.message || 'Ocurrió un error al publicar',
        icon: 'error',
        confirmButtonText: 'Entendido'
      });
  
    } finally {
      setIsSubmitting(false);
    }
};

const handleSelectCategoria = (categoriaId) => {
  setCategoriasSeleccionadas(prev => 
    prev.includes(categoriaId) 
      ? prev.filter(id => id !== categoriaId) 
      : [...prev, categoriaId]
  );
};
  

  // Resetear formulario
  const resetForm = () => {
    setFile(null);
    setPreview(null);
    setTitulo('');
    setDescripcion('');
    setContenidoExplicito(false);
    setCategoriasSeleccionadas([]);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  const toggleCategoria = (ID_categoria) => {
    setCategoriasSeleccionadas(prev => 
      prev.includes(ID_categoria)
        ? prev.filter(id => id !== ID_categoria)
        : [...prev, ID_categoria]
    );
  };

  useEffect(() => {
    if (mostrar) {
      document.documentElement.classList.add('html-no-scroll');
    } else {
      document.documentElement.classList.remove('html-no-scroll');
    }

    return () => {
      
    };
  }, [mostrar]);

  if (!mostrar) return null;

  return (
    <div className="publication-modal-overlay" onClick={onClose}>
      <div 
        className="publication-modal-container" 
        onClick={(e) => e.stopPropagation()}
        ref={modalRef}
      >
        <div className="publication-modal-header">
          <h2>Crear nueva publicación</h2>
          <button className="close-modal-btn" onClick={onClose}>
            <i className="fas fa-times"></i>
          </button>
        </div>
        
        <form onSubmit={handleSubmit} className="publication-modal-content">
          {/* Sección de subida de archivos */}
          <div className="upload-section">
            <div 
              className="upload-area" 
              id="upload-area"
              onClick={() => fileInputRef.current.click()}
            >
              {!preview ? (
                <>
                  <div className="upload-icon">
                    <i className="fas fa-cloud-upload-alt"></i>
                  </div>
                  <p className="upload-instructions">Arrastra y suelta tu archivo aquí</p>
                  <p className="upload-subtext">o haz clic para seleccionar</p>
                </>
              ) : (
                <div className="file-preview">
                  {file.type.includes('image') ? (
                    <img src={preview} alt="Preview" className="preview-image" />
                  ) : (
                    <video src={preview} controls className="preview-video"></video>
                  )}
                  <button 
                    type="button" 
                    className="remove-file-btn"
                    onClick={(e) => {
                      e.stopPropagation();
                      removeFile();
                    }}
                  >
                    <i className="fas fa-times"></i>
                  </button>
                </div>
              )}
              <input 
                type="file" 
                ref={fileInputRef}
                onChange={handleFileChange}
                accept=".jpg,.jpeg,.png,.mp4,.mov,.avi" 
                className="file-input" 
                required
              />
            </div>
            <p className="file-requirements">
              Formatos soportados: JPG, PNG (hasta 20MB), MP4, MOV, AVI (hasta 200MB)
            </p>
          </div>
          
          {/* Sección de formulario */}
          <div className="form-section">
            <div className="form-group">
              <label htmlFor="title">Título*</label>
              <input 
                type="text" 
                id="title" 
                className="form-input" 
                placeholder="Ej: Mi última creación digital" 
                maxLength="50"
                value={titulo}
                onChange={(e) => setTitulo(e.target.value)}
                required
              />
              <span className="char-counter">{titulo.length}/50</span>
            </div>
            
            <div className="form-group">
              <label htmlFor="description">Descripción*</label>
              <textarea 
                id="description" 
                className="form-input textarea" 
                placeholder="Describe tu obra, inspiración, proceso..." 
                maxLength="100"
                value={descripcion}
                onChange={(e) => setDescripcion(e.target.value)}
                required
              ></textarea>
              <span className="char-counter">{descripcion.length}/100</span>
            </div>
        
            
            <div className="form-options">
              <div className="option-group">
                <label className="toggle-labell">
                  <span>Contenido explícito</span>
                  <label className="toggle-switchh">
                    <input 
                      type="checkbox" 
                      checked={contenidoExplicito}
                      onChange={(e) => setContenidoExplicito(e.target.checked)}
                    />
                    <span className="sliderr round"></span>
                  </label>
                </label>
              </div>
            </div>
            
            <div className="form-group">
              <label>Categorías*</label>
              <div className="categories-selector">
                <button 
                  type="button"
                  className="select-categories-btn" 
                  onClick={(e) => {
                    e.preventDefault();
                    setShowCategoriasModal(true);
                  }}
                >
                  Seleccionar categorías
                  <i className="fas fa-chevron-down"></i>
                </button>
                {categoriasSeleccionadas.length > 0 && (
                  <div className="selected-categories">
                    {categoriasSeleccionadas.map(id => {
                      const categoria = categoriasDisponibles.find(c => c.ID_categoria === id);
                      return categoria ? (
                        <span key={id} className="category-tag">
                          {categoria.Nombre_categoria}
                        </span>
                      ) : null;
                    })}
                  </div>
                )}
              </div>
            </div>
          </div>
          
          <div className="publication-modal-footer">
            <button 
              type="button"
              className="cancel-btn" 
              onClick={onClose}
              disabled={isSubmitting}
            >
              Cancelar
            </button>
            <button 
              type="submit" 
              className="publish-btn" 
              disabled={isSubmitting}
            >
              {isSubmitting ? (
                <>
                  <i className="fas fa-spinner fa-spin"></i> Publicando...
                </>
              ) : (
                'Publicar'
              )}
            </button>
          </div>
        </form>
      </div>
      
      {/* Modal de categorías */}
      {showCategoriasModal && (
  <div 
    className="categories-modal-overlay" 
    onClick={() => setShowCategoriasModal(false)}
  >
    <div className="categories-modal" onClick={(e) => e.stopPropagation()}>
      <div className="categories-modal-header">
        <h3>Selecciona categorías</h3>
        <button 
          className="close-categories-btn" 
          onClick={() => setShowCategoriasModal(false)}
          aria-label="Cerrar modal"
        >
          <i className="fas fa-times"></i>
        </button>
      </div>
      <div className="categories-list">
        {categoriasDisponibles.map(categoria => (
          <label key={categoria.ID_categoria} className="category-item">
            <input 
              type="checkbox"
              checked={categoriasSeleccionadas.includes(categoria.ID_categoria)}
              onChange={() => {
                if (categoriasSeleccionadas.includes(categoria.ID_categoria)) {
                  setCategoriasSeleccionadas(prev => 
                    prev.filter(id => id !== categoria.ID_categoria)
                  );
                } else {
                  setCategoriasSeleccionadas(prev => [...prev, categoria.ID_categoria]);
                }
              }}
            />
            <span className="checkmark"></span>
            <span className="category-name">{categoria.Nombre_categoria}</span>
          </label>
        ))}
      </div>
      <div className="categories-modal-footer">
        <button 
          className="apply-categories-btn" 
          onClick={() => setShowCategoriasModal(false)}
        >
          Aplicar selección
        </button>
      </div>
    </div>
  </div>
)}
    </div>
  );
};

export default PublicacionModal;