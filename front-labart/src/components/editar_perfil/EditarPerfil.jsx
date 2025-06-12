import React, { useState, useEffect, useRef } from 'react';
import axios from '../../utils/axiosintance';
import { useNavigate } from 'react-router-dom';
import logo from '../../assets/img/concepto_logo.png';
import Swal from 'sweetalert2';

const EditarPerfil = () => {
    const [usuario, setUsuario] = useState({
        Nombre_usuario: '',
        Descripcion_usuario: '',
        correo_usuario: '',
        Fecha_usuario: '',
        Cont_Explicit: false,
        ID_sexo: '',
        ID_rol: '',
        Img_usuario: ''
    });
    const [cargando, setCargando] = useState(true);
    const [error, setError] = useState(null);
    const [exito, setExito] = useState(null);
    const [sexos, setSexos] = useState([]);
    const [roles, setRoles] = useState([]);
    const [imagenPrevia, setImagenPrevia] = useState('');
    const [subiendoImagen, setSubiendoImagen] = useState(false);
    const [mostrarOTPModal, setMostrarOTPModal] = useState(false);
    const [otp, setOtp] = useState('');
    const [otpEnviado, setOtpEnviado] = useState('');
    const [emailOriginal, setEmailOriginal] = useState('');
    const fileInputRef = useRef(null);
    const navegar = useNavigate();

    useEffect(() => {
        const cargarDatos = async () => {
            try {
                const token = localStorage.getItem('token');
                if (!token) {
                    window.location.href = '/login';
                    return;
                }

                const idUsuario = localStorage.getItem('ID_usuario');
                if (!idUsuario) {
                    setError('No se encontró el ID de usuario');
                    return;
                }

                const config = {
                    headers: {
                        'Authorization': `Bearer ${token}`
                    }
                };

                const respuestaUsuario = await axios.get(`http://127.0.0.1:5000/usuario/${idUsuario}`, config);
                setUsuario(respuestaUsuario.data);
                setEmailOriginal(respuestaUsuario.data.correo_usuario); // Guardamos el email original
                if (respuestaUsuario.data.Img_usuario) {
                    setImagenPrevia(respuestaUsuario.data.Img_usuario);
                }

                const respuestaSexos = await axios.get('http://127.0.0.1:5000/sexo', config);
                setSexos(respuestaSexos.data);

                const respuestaRoles = await axios.get('http://127.0.0.1:5000/rol', config);
                setRoles(respuestaRoles.data);

                setCargando(false);
            } catch (err) {
                setError('Error al cargar los datos del usuario');
                console.error(err);
                setCargando(false);
            }
        };

        cargarDatos();
    }, []);

    const subirImagenACloudinary = async (file) => {
        const data = new FormData();
        data.append('file', file);
        data.append('upload_preset', 'Imagenes_perfil');
        data.append('cloud_name', 'dnssxeplk');

        const res = await fetch('https://api.cloudinary.com/v1_1/dnssxeplk/image/upload', {
            method: 'POST',
            body: data
        });

        const result = await res.json();
        return {
            url: result.secure_url,
            public_id: result.public_id
        };
    };

    const manejarCambio = (e) => {
        const { name, value, type, checked } = e.target;
        setUsuario({
            ...usuario,
            [name]: type === 'checkbox' ? checked : value
        });
    };

    const manejarCambioImagen = (e) => {
        const archivo = e.target.files[0];
        if (!archivo) return;

        const vistaPrevia = URL.createObjectURL(archivo);
        setImagenPrevia(vistaPrevia);
    };

    const enviarOTP = async (email) => {
        try {
            Swal.fire({
                title: 'Enviando código de verificación...',
                allowOutsideClick: false,
                didOpen: () => Swal.showLoading()
            });

            const response = await axios.post('http://127.0.0.1:5000/email', {
                destinatario: email
            });

            Swal.close();

            if (response.data.OTP) {
                setOtpEnviado(response.data.OTP);
                setMostrarOTPModal(true);
                return true;
            }
            return false;
        } catch (err) {
            Swal.fire('Error', 'Correo ya registrado intenta con otro', 'error');
            console.error('Error al enviar OTP:', err);
            return false;
        }
    };

    const verificarOTP = () => {
        if (otp !== otpEnviado) {
            Swal.fire('Error', 'El código de verificación no coincide', 'error');
            return false;
        }
        return true;
    };

    const actualizarPerfil = async () => {
        setError(null);
        setExito(null);
        setSubiendoImagen(true);

        try {
            const token = localStorage.getItem('token');
            const idUsuario = localStorage.getItem('ID_usuario');

            if (!token || !idUsuario) {
                setError('No se encontró el token o ID de usuario');
                return;
            }

            if (fileInputRef.current.files[0]) {
                const archivo = fileInputRef.current.files[0];
                const resultado = await subirImagenACloudinary(archivo);
                usuario.Img_usuario = resultado.url;
            }

            const config = {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            };

            // Enviar datos actualizados al backend
            const respuesta = await axios.put(
                `http://127.0.0.1:5000/usuario/${idUsuario}`,
                usuario,
                config
            );

            setExito('Datos actualizados correctamente');
            setMostrarOTPModal(false);

            if (respuesta.data.Img_usuario) {
                setImagenPrevia(respuesta.data.Img_usuario);
            }

            localStorage.setItem('Nombre_usuario', usuario.Nombre_usuario);
            localStorage.setItem('Img_usuario', usuario.Img_usuario);

            // Mostrar mensaje de éxito
            Swal.fire({
                icon: 'success',
                title: 'Perfil actualizado',
                text: 'Tus cambios se han guardado correctamente',
                timer: 2000
            });

        } catch (err) {
            setError(err.response?.data?.error || 'Error al actualizar los datos del usuario');
            console.error('Error detallado:', err.response?.data || err.message);
        } finally {
            setSubiendoImagen(false);
        }
    };

    const manejarEnvio = async (e) => {
        e.preventDefault();

        // Solo requerimos OTP si el email ha cambiado
        if (usuario.correo_usuario !== emailOriginal) {
            const otpEnviado = await enviarOTP(usuario.correo_usuario);
            if (!otpEnviado) return;
        } else {
            // Si el email no cambió, actualizamos directamente
            await actualizarPerfil();
        }
    };

    if (cargando) {
        return <div className="cargando">Cargando datos del usuario...</div>;
    }

    return (
        <div className="contenedor-editar-perfil">
            <div className="contenedor-formulario-completo">
                <div className="contenedor-logo">
                    <img
                        src={logo}
                        alt="Logo del aplicativo"
                        className="logo-aplicativo"
                        style={{ filter: 'none' }}
                    />
                </div>

                <div className="contenedor-formulario">
                    <div className="encabezado-formulario">
                        <button
                            className="boton-volver"
                            onClick={() => navegar('/home')}
                        >
                            ← Volver al inicio
                        </button>
                        <h2>Editar Perfil</h2>
                    </div>

                    {error && <div className="mensaje-error">{error}</div>}
                    {exito && <div className="mensaje-exito">{exito}</div>}

                    <form onSubmit={manejarEnvio}>
                        <div className="grupo-formulario">
                            <label htmlFor="input-imagen">Imagen de Perfil:</label>
                            <div className="contenedor-imagen-perfil">
                                {imagenPrevia && (
                                    <img
                                        src={imagenPrevia}
                                        alt="Vista previa"
                                        className="imagen-perfil"
                                    />
                                )}
                                <input
                                    type="file"
                                    id="input-imagen"
                                    ref={fileInputRef}
                                    onChange={manejarCambioImagen}
                                    accept="image/*"
                                    style={{ display: 'none' }}
                                />
                                <button
                                    type="button"
                                    className="boton-subir-imagen"
                                    onClick={() => fileInputRef.current.click()}
                                    disabled={subiendoImagen}
                                >
                                    {subiendoImagen ? 'Subiendo...' : 'Cambiar Imagen'}
                                </button>
                            </div>
                        </div>

                        <div className="grupo-formulario">
                            <label htmlFor="Nombre_usuario">Nombre de Usuario:</label>
                            <input
                                type="text"
                                id="Nombre_usuario"
                                name="Nombre_usuario"
                                value={usuario.Nombre_usuario || ''}
                                onChange={manejarCambio}
                                required
                            />
                        </div>

                        <div className="grupo-formulario">
                            <label htmlFor="Descripcion_usuario">Descripción:</label>
                            <input
                                type="text"
                                id="Descripcion_usuario"
                                name="Descripcion_usuario"
                                value={usuario.Descripcion_usuario || ''}
                                onChange={manejarCambio}
                            />
                        </div>

                        <div className="grupo-formulario">
                            <label htmlFor="correo_usuario">Correo Electrónico:</label>
                            <input
                                type="email"
                                id="correo_usuario"
                                name="correo_usuario"
                                value={usuario.correo_usuario || ''}
                                onChange={manejarCambio}
                                required
                            />
                        </div>

                        <div className="grupo-formulario">
                            <label htmlFor="Fecha_usuario">Fecha de Registro:</label>
                            <input
                                type="text"
                                id="Fecha_usuario"
                                name="Fecha_usuario"
                                value={usuario.Fecha_usuario || ''}
                                disabled
                            />
                        </div>

                        <div className="grupo-formulario">
                            <label htmlFor="ID_sexo">Sexo:</label>
                            <select
                                id="ID_sexo"
                                name="ID_sexo"
                                value={usuario.ID_sexo || ''}
                                onChange={manejarCambio}
                                required
                            >
                                <option value="">Seleccione un sexo</option>
                                {sexos.map(sexo => (
                                    <option key={sexo.ID_sexo} value={sexo.ID_sexo}>
                                        {sexo.Nombre_sexo}
                                    </option>
                                ))}
                            </select>
                        </div>

                        <div className="grupo-formulario">
                            <label htmlFor="ID_rol">Rol:</label>
                            <input
                                id="ID_rol"
                                name="ID_rol"
                                value={roles.find(rol => rol.ID_rol === usuario.ID_rol)?.Nombre_rol || ''}
                                onChange={manejarCambio}
                                required
                                disabled
                            />
                        </div>


                        <div className="grupo-formulario-checkbox">
                            <input
                                type="checkbox"
                                id="Cont_Explicit"
                                name="Cont_Explicit"
                                checked={usuario.Cont_Explicit || false}
                                onChange={manejarCambio}
                            />
                            <label htmlFor="Cont_Explicit">Permitir contenido explícito</label>
                        </div>

                        <div className="contenedor-botones">
                            <button type="submit" className="boton-actualizar" disabled={subiendoImagen}>
                                {subiendoImagen ? 'Actualizando...' : 'Actualizar Perfil'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            {/* Modal de OTP */}
            {mostrarOTPModal && (
                <div className="modal-otp">
                    <div className="modal-contentt">
                        <h2>Verificación de Código</h2>
                        <p>Ingresa el código de verificación que enviamos a tu correo electrónico</p>
                        <input
                            type="text"
                            value={otp}
                            onChange={(e) => setOtp(e.target.value)}
                            placeholder="Código de 6 dígitos"
                            maxLength={6}
                        />
                        <div className="modal-buttonss">
                            <button
                                type="button"
                                onClick={() => setMostrarOTPModal(false)}
                                className="btn-cancelar"
                            >
                                Cancelar
                            </button>
                            <button
                                type="button"
                                onClick={() => {
                                    if (verificarOTP()) {
                                        actualizarPerfil();
                                    }
                                }}
                                className="btn-verificar"
                            >
                                Verificar
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default EditarPerfil;
