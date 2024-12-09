import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
axios.defaults.baseURL = 'http://localhost:5000';

const Formulario = () => {
    const [isRegister, setIsRegister] = useState(true);
    const [formData, setFormData] = useState({
        username: '',
        email: '',
        password: '',
        gender: '',
    });
    const navigate = useNavigate();

    const toggleSection = () => {
        setIsRegister(!isRegister);
    };

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData({ ...formData, [name]: value });
    };

    const handleRegister = async (e) => {
        e.preventDefault();
        try {
            await axios.post('/signin', {
                correo_usuario: formData.email,
                Nombre_usuario: formData.username,
                Contrasena: formData.password,
                ID_sexo: formData.gender === 'Hombre' ? 1 : 2,
                ID_rol: 2,
            });
            alert('Cuenta creada correctamente. Ahora puedes iniciar sesión.');
        } catch (error) {
            console.error('Error en el registro:', error);
            alert('Hubo un problema con el registro. Intenta nuevamente.');
        }
    };

    const handleLogin = async (e) => {
        e.preventDefault();
        try {
            const response = await axios.post('/login', {
                correo_usuario: formData.email,
                Contrasena: formData.password,
            });
    
            console.log(response.data); 
            
            const { token_de_acceso, ID_rol } = response.data;
    
            if (token_de_acceso) {
                localStorage.setItem('token', token_de_acceso);
                axios.defaults.headers['Authorization'] = `Bearer ${token_de_acceso}`;
    
                alert('Credenciales Correctas. Token Almacenado.');
    
                // Redirigir según id_rol
                if (ID_rol === 1) {
                    navigate('/crud');
                } else if (ID_rol === 2) {
                    navigate('/home');
                }
            } else {
                alert('Credenciales incorrectas. Intenta nuevamente.');
            }
        } catch (error) {
            console.error('Error en el inicio de sesión:', error);
            alert('Hubo un problema con el inicio de sesión. Intenta nuevamente.');
        }
    };
    
    

    return (
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
                                <img src="../../assets/img/login/6522581.png" width={100} height={100} alt="" />
                                <div className="round">
                                    <input type="file" />
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
                                    
                                required/>
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
                                required/>
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
                                required/>
                                <label htmlFor="inputField" className="input-label label-special">
                                    <i className="fa-solid fa-lock" style={{ color: '#ffff' }}></i>
                                    Contraseña
                                </label>
                            </div>

                            <div className="input-container generos">
                                <input
                                    type="radio"
                                    id="opcion1"
                                    name="gender"
                                    value="Hombre"
                                    className="genero1"
                                    onChange={handleInputChange}
                                required/>
                                <label htmlFor="opcion1" className="genero">Hombre</label>
                                <input
                                    type="radio"
                                    id="opcion2"
                                    name="gender"
                                    value="Mujer"
                                    className="genero2"
                                    onChange={handleInputChange}
                                required/>
                                <label htmlFor="opcion2" className="genero">Mujer</label>
                            </div>

                            <div className="terminos">
                                <center>
                                <label htmlFor="terminos-condiciones">
                                    <input type="checkbox" id="terminos-condiciones" name="terminos-condiciones" />
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
                                required/>
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
                                required/>
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
    );
};

export default Formulario;


