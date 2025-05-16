import React, { useEffect, useState } from 'react';
import axios from 'axios';
import './cloudinary.css';

const GestorImagenCloudinary = () => {
    const [imagenes, setImagenes] = useState([]);
    const [cargando, setCargando] = useState(false);
    const [error, setError] = useState(null);
    const [exito, setExito] = useState(null);

    const obtenerTodasLasImagenes = async () => {
        setCargando(true);
        setError(null);
        setExito(null);
        try {
            const token = localStorage.getItem('token');
            const response = await axios.get('http://127.0.0.1:5000/cloudinary', {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });
            setImagenes(response.data);
        } catch (err) {
            setError(err.response?.data?.error || 'Error al obtener las imágenes');
        } finally {
            setCargando(false);
        }
    };

    const eliminarImagen = async (publicId) => {
        if (!window.confirm(`¿Estás seguro de eliminar la imagen ${publicId}?`)) return;

        try {
            const token = localStorage.getItem('token');
            const response = await axios.delete('http://127.0.0.1:5000/cloudinary', {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                data: { public_id: publicId }
            });
            setExito(response.data.message);
            setImagenes(prev => prev.filter(img => img.public_id !== publicId));
        } catch (err) {
            setError(err.response?.data?.error || 'Error al eliminar la imagen');
        }
    };

    useEffect(() => {
        obtenerTodasLasImagenes();
    }, []);

    return (
        <div className="contenedor-gestor-imagen">
            <h2>Galería de Imágenes (Cloudinary)</h2>
            <a href='/crud' style={{ textDecoration: 'none' }}>
            <button  
                className="boton-regresar"
                style={{ marginBottom: '1rem' }}
            >
                ⬅ Regresar
            </button>
            </a>
            {error && <div className="mensaje-error">{error}</div>}
            {exito && <div className="mensaje-exito">{exito}</div>}
            {cargando ? (
                <p>Cargando imágenes...</p>
            ) : (
                <div className="galeria-imagenes">
                    {imagenes.map(imagen => (
                        <div key={imagen.public_id} className="tarjeta-imagen">
                            <img src={imagen.url} alt={imagen.public_id} className="imagen-preview" />
                            <div className="info-imagen">
                                <p><strong>ID:</strong> {imagen.public_id}</p>
                                <p><strong>Formato:</strong> {imagen.format}</p>
                                <p><strong>Tamaño:</strong> {imagen.width} x {imagen.height}</p>
                                <p><strong>Peso:</strong> {(imagen.bytes / 1024).toFixed(2)} KB</p>
                                <input type="text" value={imagen.url} readOnly className="input-enlace" />
                                <button 
                                    onClick={() => navigator.clipboard.writeText(imagen.url)}
                                    className="boton-copiar"
                                >
                                    Copiar enlace
                                </button>
                                <button 
                                    onClick={() => eliminarImagen(imagen.public_id)}
                                    className="boton-eliminar"
                                >
                                    Eliminar
                                </button>
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default GestorImagenCloudinary;
