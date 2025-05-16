import React, { useState } from 'react';
import axios from 'axios';
import Swal from 'sweetalert2';
import { useNavigate } from 'react-router-dom';
axios.defaults.baseURL = 'http://localhost:5000';
import PasswordResetModal from '../verificar_contrasena/verificacion';

const Formulario = () => {
    const [isRegister, setIsRegister] = useState(true);
    const [formData, setFormData] = useState({
        username: '',
        email: '',
        password: '',
        imageUrl: '',
    });
    const [selectedFile, setSelectedFile] = useState(null);
    const [mostrarPasswordModal, setMostrarPasswordModal] = useState(false);
    const [mostrarOTPModal, setMostrarOTPModal] = useState(false);
    const [otp, setOtp] = useState('');
    const [otpEnviado, setOtpEnviado] = useState('');
    const navigate = useNavigate();

    const toggleSection = () => {
        setIsRegister(!isRegister);
    };

    const abrirPasswordModal = () => {
        setMostrarPasswordModal(true);
    };

    const cerrarPasswordModal = () => {
        setMostrarPasswordModal(false);
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    const preset_name = 'Imagenes_perfil';
    const cloud_name = 'dnssxeplk';

    const uploadImage = async (file) => {
        if (!file) {
            return null; // No mostramos advertencia ya que la imagen no es obligatoria
        }

        const data = new FormData();
        data.append('file', file);
        data.append('upload_preset', preset_name);

        Swal.fire({
            title: 'Subiendo imagen...',
            text: 'Por favor, espere mientras se carga la imagen.',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            },
        });

        try {
            const response = await fetch(`https://api.cloudinary.com/v1_1/${cloud_name}/image/upload`, {
                method: 'POST',
                body: data,
            });
            const result = await response.json();
            Swal.close();
            return result.secure_url;
        } catch (error) {
            console.error('Error al subir la imagen:', error);
            Swal.fire('Error', 'No se pudo subir la imagen. Intenta nuevamente.', 'error');
            return null;
        }
    };

    const handleFileChange = (e) => {
        const file = e.target.files[0];
        if (file) {
            setSelectedFile(file);
            const previewUrl = URL.createObjectURL(file);
            setFormData({...formData, imageUrl: previewUrl});
        }
    };

    const verificarEmail = async (email) => {
        try {
            const response = await axios.get(`/usuario/check-email?email=${email}`);
            return response.data.existe;
        } catch (error) {
            console.error('Error al verificar email:', error);
            return false;
        }
    };

    const enviarOTP = async () => {
        try {
            Swal.fire({
                title: 'Enviando código de verificación...',
                allowOutsideClick: false,
                didOpen: () => Swal.showLoading()
            });

            const response = await axios.post('/email', {
                destinatario: formData.email
            });

            Swal.close();
            
            if (response.data.OTP) {
                setOtpEnviado(response.data.OTP);
                setMostrarOTPModal(true);
                return true;
            }
            return false;
        } catch (error) {
            Swal.fire('Error', 'Correo ya registrado intenta con otro o restablece la contraseña', 'error');
            console.error('Error al enviar OTP:', error);
            return false;
        }
    };

    const handleRegister = async (e) => {
        e.preventDefault();
        
        // 1. Verificar si el email ya está registrado
        const emailExiste = await verificarEmail(formData.email);
        if (emailExiste) {
            Swal.fire('Error', 'Este correo electrónico ya está registrado', 'error');
            return;
        }

        // 2. Enviar OTP y mostrar modal
        const otpEnviadoCorrectamente = await enviarOTP();
        if (!otpEnviadoCorrectamente) {
            return;
        }
    };

    const verificarOTP = async () => {
        if (otp !== otpEnviado) {
            Swal.fire('Error', 'El código de verificación no coincide', 'error');
            return false;
        }

        // Si el OTP es correcto, proceder con el registro
        try {
            const imageUrl = await uploadImage(selectedFile);
            
            const usuarioData = {
                Nombre_usuario: formData.username,
                correo_usuario: formData.email,
                contrasena: formData.password,
                Img_usuario: imageUrl || 'default.jpg',
                ID_rol: 2
            };

            Swal.fire({
                title: 'Registrando usuario...',
                allowOutsideClick: false,
                didOpen: () => Swal.showLoading()
            });

            const response = await axios.post('/signin', usuarioData);
            
            Swal.fire({
                icon: 'success',
                title: 'Registro exitoso',
                text: 'Tu cuenta ha sido creada correctamente',
                timer: 2000
            });

            // Cerrar modal OTP
            setMostrarOTPModal(false);
            
            // Redirigir a login
            setIsRegister(false);
            
        } catch (error) {
            Swal.fire('Error', 'Hubo un problema al registrar el usuario', 'error');
            console.error('Error al registrar:', error);
        }
    };

    const handleLogin = async (e) => {
        e.preventDefault();
        try {
            const response = await axios.post('/login', {
                correo_usuario: formData.email,
                Contrasena: formData.password,
            });

            const { token_de_acceso, ID_usuario, Nombre_usuario, ID_rol } = response.data;

            if (!token_de_acceso) {
                throw new Error('No se recibió token de acceso');
            }

            axios.defaults.headers['Authorization'] = `Bearer ${token_de_acceso}`;
            const userResponse = await axios.get(`/usuario/${ID_usuario}`);
            const userData = userResponse.data;
            const Img_usuario = userData.Img_usuario;

            localStorage.setItem('token', token_de_acceso);
            localStorage.setItem('ID_usuario', ID_usuario);
            localStorage.setItem('Nombre_usuario', Nombre_usuario);
            localStorage.setItem('Img_usuario', Img_usuario || '');

            const redirectPath = ID_rol === 1 ? '/crud' : '/home';
            navigate(redirectPath);

            Swal.fire({
                icon: 'success',
                title: 'Bienvenido!',
                text: `Hola ${Nombre_usuario}`,
                timer: 2000
            });

        } catch (error) {
            console.error('Error en login:', error);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.response?.data?.message || 'Error al iniciar sesión',
            });
        }
    };

    return (
        <div className='contenedor-main'>
            <div className='container-Formulario'>
                <div className="formulario_register">
                    {isRegister ? (
                        <div className="seccion1 seccion_pos">
                            {/* Sección Registro */}
                            <div className="logo">
                                <img src="/img/concepto logo.png" alt="" />
                            </div>
                            <div className="indicador col-md-4 col-lg-7">
                                <button className=""></button>
                                <button className="active" id="ind_register"></button>
                                <button className="" id="" onClick={toggleSection}></button>
                            </div>
                            <div className="texto_indicador">
                                <h1 className="Texto_indicador">Crea una Cuenta</h1>
                            </div>
                            <div className="formulario col-md-16">
                                <form onSubmit={handleRegister}>
                                    <div className="upload">
                                        <img src={formData.imageUrl || '../../assets/img/login/6522581.png'} width={100} height={100} alt="" />
                                        <div className="round">
                                            <input 
                                                type="file" 
                                                onChange={handleFileChange} 
                                                accept="image/*" 
                                            />
                                            <i className="fa fa-camera" style={{ color: '#ffff' }}></i>
                                        </div>
                                    </div>

                                    <div className="input-container">
                                        <input
                                            type="text"
                                            name="username"
                                            className="input-field"
                                            placeholder=""
                                            value={formData.username}
                                            pattern="^[a-zA-Z0-9]{3,20}$"
                                            onChange={handleInputChange}
                                            title="El nombre de usuario debe tener entre 3 y 20 caracteres y solo puede contener letras y números."
                                            required />
                                        <label htmlFor="inputField" className="input-label">
                                            <i className="fa-solid fa-user" style={{ color: '#ffff' }}></i>
                                            Nombre de Usuario
                                        </label>
                                    </div>

                                    <div className="input-container">
                                        <input
                                            type="email"
                                            name="email"
                                            className="input-field"
                                            placeholder=""
                                            value={formData.email}
                                            pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                            onChange={handleInputChange}
                                            title="Introduce un correo electrónico válido."
                                            required />
                                        <label htmlFor="inputField" className="input-label">
                                            <i className="fa-solid fa-envelope" style={{ color: '#ffff' }}></i>
                                            Correo Electronico
                                        </label>
                                    </div>

                                    <div className="input-container">
                                        <input
                                            type="password"
                                            name="password"
                                            className="input-field"
                                            placeholder=""
                                            value={formData.password}
                                            pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"
                                            onChange={handleInputChange}
                                            title="La contraseña debe tener al menos 8 caracteres, incluyendo una letra y un número."
                                            required />
                                        <label htmlFor="inputField" className="input-label label-special">
                                            <i className="fa-solid fa-lock" style={{ color: '#ffff' }}></i>
                                            Contraseña
                                        </label>
                                    </div>

                

                                    <div className="terminos">
                                        <center>
                                            <label htmlFor="terminos-condiciones">
                                                <input type="checkbox" id="terminos-condiciones" name="terminos-condiciones" required />
                                                Aceptar términos y condiciones
                                            </label>
                                        </center>
                                    </div>

                                    <div className="enviar col-sm-8 col-md-12">
                                        <button className="icon_buscar" type="submit">
                                            <p className="t_boton_login">Continuar <i className="fa-solid fa-arrow-right flecha"></i></p>
                                        </button>
                                    </div>
                                    <div className="texto_terminos_condiciones">
                                        Tienes que llenar todos los campos para seguir al siguiente paso
                                    </div>
                                </form>
                            </div>
                            <div className="seccion2 text-center mt-3">
                                <button className="boton_indicador ubicacion" id="toggleButton" onClick={toggleSection}>
                                    Inicia Sesion
                                </button>
                                <div className="ayuda text-center mt-2">
                                    <p className="correro_ayuda">
                                        <i className="fa-solid fa-envelope" style={{ color: '#ffff' }}></i>
                                        Ayudalabart@gmail.com
                                    </p>
                                </div>
                            </div>
                        </div>
                    ) : (
                        <div className="seccion1 seccion_posicion">
                            {/* Sección Login */}
                            <div className="logo">
                                <img src="/img/concepto logo.png" alt="" />
                            </div>
                            <div className="indicador col-md-4 col-lg-7">
                                <button className="indicador_etc"></button>
                                <button className="" id="" onClick={toggleSection}></button>
                                <button className="" id="ind_login"></button>
                            </div>
                            <div className="texto_indicador">
                                <h1 className="Texto_indicador texto_login">Iniciar Sesion</h1>
                            </div>
                            <div className="formulario formulario_posicion col-md-14 col-lg-18">
                                <form onSubmit={handleLogin}>
                                    <div className="input-container input_login mt-3">
                                        <input
                                            type="text"
                                            name="email"
                                            className="input-field w-250"
                                            placeholder=""
                                            value={formData.email}
                                            pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                            onChange={handleInputChange}
                                            title="Introduce un correo electrónico válido."
                                            required />
                                        <label htmlFor="inputField" className="input-label input_special_login">
                                            <i className="fa-solid fa-user" style={{ color: '#ffff' }}></i>
                                            Correo
                                        </label>
                                    </div>

                                    <div className="input-container input_login mt-4">
                                        <input
                                            type="password"
                                            name="password"
                                            className="input-field"
                                            placeholder=""
                                            value={formData.password}
                                            onChange={handleInputChange}
                                            required />
                                        <label htmlFor="inputField" className="input-label label-special">
                                            <i className="fa-solid fa-lock" style={{ color: '#ffff' }}></i>
                                            Contraseña
                                        </label>
                                    </div>

                                    <div className="enviar enviar_login mb-3">
                                        <button className="icon_buscar" type="submit" id="boton_login">
                                            <p className="t_boton_login">Iniciar Sesión</p>
                                        </button>
                                    </div>

                                    <div className="texto_terminos_condiciones" id="texto_login_register" onClick={abrirPasswordModal} style={{ cursor: 'pointer' }}>
                                        Restablecer contraseña
                                    </div>

                                    <div className="texto_terminos_condiciones" id="texto_login_register">
                                        ¿Aun no tienes una cuenta? <br />
                                        registrate ahora
                                    </div>
                                </form>
                            </div>

                            <div className="seccion2 text-center mt-3">
                                <button className="boton_indicador" id="toggleButton" onClick={toggleSection}>
                                    Registrate
                                </button>
                                <div className="ayuda text-center mt-2" id="correo_login">
                                    <p className="correro_ayuda">
                                        <i className="fa-solid fa-envelope" style={{ color: '#ffff' }}></i>
                                        Ayudalabart@gmail.com
                                    </p>
                                </div>
                            </div>
                        </div>
                    )}
                </div>
            </div>

            {mostrarPasswordModal && (
                <PasswordResetModal 
                    onClose={cerrarPasswordModal} 
                />
            )}

            {/* Modal OTP */}
            {mostrarOTPModal && (
                <div className="modal-otp">
                    <div className="modal-content">
                        <h2>Verificación de Código</h2>
                        <p>Ingresa el código de verificación que enviamos a tu correo electrónico</p>
                        <input
                            type="text"
                            value={otp}
                            onChange={(e) => setOtp(e.target.value)}
                            placeholder="Código de 6 dígitos"
                            maxLength={6}
                        />
                        <div className="modal-buttons">
                            <button onClick={() => setMostrarOTPModal(false)}>Cancelar</button>
                            <button onClick={verificarOTP}>Verificar</button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default Formulario;