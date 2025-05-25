import React, { useState, useEffect } from 'react';
import axios from '../../utils/axiosintance';
import { useNavigate } from 'react-router-dom';
import logo from '../../assets/img/concepto_logo.png';
import pribut from '../../assets/img/primary-button.svg';
import ModalAjustes from '../modal_configuracion/configuracion';
import PqrsModal from '../Pqrs/PqrsModal';
import ModalDetalles from '../home/DetallesModal';
import PublicacionPropiaModal from '../perfil/Detalles_propia';
import Swal from 'sweetalert2';

const BusquedaAvanzada = () => {
    const [usuario, setUsuario] = useState("");
    const [ImgUsuario, setImgUsuario] = useState("");
    const [idUsuario, setIdUsuario] = useState(null);
    const [mostrarModal, setMostrarModal] = useState(false);
    const [showPqrsModal, setShowPqrsModal] = useState(false);
    const [busqueda, setBusqueda] = useState("");
    const [tipoBusqueda, setTipoBusqueda] = useState("todo");
    const [publicaciones, setPublicaciones] = useState([]);
    const [cargando, setCargando] = useState(false);
    const [showPropiaModal, setShowPropiaModal] = useState(false);
    const [selectedPublicacion, setSelectedPublicacion] = useState(null);
    const [modalPublicacionId, setModalPublicacionId] = useState(null);
    const [contenidoExplicito, setContenidoExplicito] = useState(false);
    const navigate = useNavigate();

    // Obtener datos del usuario logueado
    useEffect(() => {
        const Nombre_usuario = localStorage.getItem("Nombre_usuario") || "Invitado";
        const Img_usuario = localStorage.getItem("Img_usuario");
        const idUsuarioLocal = localStorage.getItem("ID_usuario");
        const contenidoExplicit = localStorage.getItem("Cont_Explicit_user") === 'true';

        setUsuario(Nombre_usuario);
        setImgUsuario(Img_usuario);
        setIdUsuario(idUsuarioLocal);
        setContenidoExplicito(contenidoExplicit);
    }, []);

    // Efecto para el scroll cuando el modal está abierto
    useEffect(() => {
        if (showPropiaModal || modalPublicacionId !== null) {
            document.documentElement.classList.add('html-no-scroll');
        } else {
            document.documentElement.classList.remove('html-no-scroll');
        }
        return () => {
            document.documentElement.classList.remove('html-no-scroll');
        };
    }, [showPropiaModal, modalPublicacionId]);

    // Buscar publicaciones al escribir
    useEffect(() => {
        if (busqueda.trim() === "") {
            setPublicaciones([]);
            return;
        }

        const timer = setTimeout(() => {
            buscarPublicaciones();
        }, 500);

        return () => clearTimeout(timer);
    }, [busqueda, tipoBusqueda]);

    const buscarPublicaciones = async () => {
        setCargando(true);
        try {
            const response = await axios.get(`http://127.0.0.1:5000/buscar_publicaciones?q=${busqueda}&tipo=${tipoBusqueda}`);
            setPublicaciones(response.data);
        } catch (error) {
            console.error("Error al buscar publicaciones:", error);
            setPublicaciones([]);
        } finally {
            setCargando(false);
        }
    };

    const abrirModalAjustes = () => {
        setMostrarModal(true);
        document.documentElement.classList.add('html-no-scroll');
    };

    const cerrarModalAjustes = () => {
        setMostrarModal(false);
        document.documentElement.classList.remove('html-no-scroll');
    };

    const handleClickPublicacionExplicita = async (publicacion) => {
        const idUsuarioLocal = localStorage.getItem("ID_usuario");
        const esPublicacionPropia = String(publicacion.usuario.ID_usuario) === String(idUsuarioLocal);

        // Si es publicación propia, mostrar siempre sin censura
        if (esPublicacionPropia) {
            mostrarDetalles(publicacion);
            return;
        }

        // Si es de otro usuario y es explícita con filtro activado
        if (publicacion.Cont_Explicit_publi && !contenidoExplicito) {
            Swal.fire({
                icon: 'warning',
                title: 'Contenido explícito',
                text: 'Esta publicación contiene contenido explícito. Activa "Mostrar contenido explícito" en ajustes para verla.',
                confirmButtonText: 'Ir a ajustes',
                showCancelButton: true,
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    setMostrarModal(true);
                }
            });
        } else {
            mostrarDetalles(publicacion);
        }
    };

    // Función para mostrar el modal adecuado según si es publicación propia o no
    const mostrarDetalles = async (publicacion) => {
        const idUsuarioLocal = localStorage.getItem("ID_usuario");
        
        try {
            // Obtener los datos completos de la publicación
            const response = await axios.get(`/publicacion/${publicacion.ID_publicacion}`);
            const publicacionCompleta = response.data;

            if (idUsuarioLocal && String(publicacionCompleta.ID_usuario) === String(idUsuarioLocal)) {
                // Es una publicación propia
                setSelectedPublicacion(publicacionCompleta);
                setShowPropiaModal(true);
                setModalPublicacionId(null);
            } else {
                // Es una publicación de otro usuario
                setModalPublicacionId(publicacionCompleta.ID_publicacion);
                setShowPropiaModal(false);
            }
            document.documentElement.classList.add('html-no-scroll');
        } catch (error) {
            console.error('Error al obtener detalles de la publicación:', error);
        }
    };

    const cerrarDetalles = () => {
        setModalPublicacionId(null);
        document.documentElement.classList.remove('html-no-scroll');
    };

    const cerrarPropiaModal = () => {
        setShowPropiaModal(false);
        document.documentElement.classList.remove('html-no-scroll');
    };

    const renderizarColumnas = (numColumnas) => {
        if (!Array.isArray(publicaciones)) {
            return null;
        }

        const columnas = Array.from({ length: numColumnas }, () => []);

        publicaciones.forEach((publicacion, index) => {
            columnas[index % numColumnas].push(publicacion);
        });

        return columnas.map((columna, i) => (
            <div key={i} className={`columnas columna${i + 1}`}>
                <div className="tarjetas">
                    {columna.map((publicacion) => {
                        const idUsuarioLocal = localStorage.getItem("ID_usuario");
                        const esPublicacionPropia = String(publicacion.usuario.ID_usuario) === String(idUsuarioLocal);
                        const debeMostrarFiltro = publicacion.Cont_Explicit_publi && !contenidoExplicito && !esPublicacionPropia;

                        return (
                            <div key={publicacion.ID_publicacion} className="tarjeta">
                                <div
                                    className={`imagen-contenedor ${debeMostrarFiltro ? 'contenido-explicito' : ''}`}
                                    onClick={() => handleClickPublicacionExplicita(publicacion)}
                                >
                                    <img
                                        src={publicacion.Img_publicacion}
                                        alt={`Publicación ${publicacion.Titulo_publicacion}`}
                                    />
                                    {debeMostrarFiltro && (
                                        <div className="advertencia-explicito">
                                            <i className="fa-solid fa-eye-slash"></i>
                                            <span>Contenido explícito</span>
                                        </div>
                                    )}
                                </div>
                            </div>
                        );
                    })}
                </div>
            </div>
        ));
    };

    return (
        <div className='contenedor_buscar_usuario'>
            <div className='contenedor_todo'>
                <div className="container_all">
                    <nav className="menu_nav">
                        <div className="menu">
                            <div className="logo">
                                <img className="img_logo" src={logo} alt="Logo LABART" />
                            </div>
                            <div className="options_menu">
                                <a href="/home" className="opciones texto">
                                    <i className="fa-solid fa-house iconos" style={{ color: '#545454' }} />
                                    <h4 className="texto_h">Inicio</h4>
                                </a>
                                <a href="/categoria" className="opciones texto">
                                    <i className="fa-regular fa-compass iconos" style={{ color: '#545454' }} />
                                    <h4 className='texto_h'>Explorar</h4>
                                </a>
                                <a href="/buscar-usuario" className="opciones indicador_actual texto">
                                    <div className="indicador_opcion" />
                                    <i className="icon_selected fa-solid fa-magnifying-glass iconos lupa-ajustada" />
                                    <h4 className='text_selected texto_h'>Buscar Usuario</h4>
                                </a>
                                <a href="/asistente" className="opciones texto">
                                    <i className="icons fa-regular fa-lightbulb iconos" style={{ color: '#545454' }} />
                                    <h4 className='texto_h'>IA</h4>
                                </a>
                                <a href="paint/paint.html" className="opciones texto">
                                    <i className="icons fa-solid fa-palette iconos" style={{ color: '#545454' }} />
                                    <h4 className='texto_h'>Crea Tu Arte</h4>
                                </a>
                                <a href="/notificaciones" className="texto">
                                    <div className="opciones">
                                        <i className="icons fa-regular fa-bell iconos" style={{ color: '#545454' }} />
                                        <h4 className='texto_h'>Notificaciones</h4>
                                    </div>
                                </a>
                                <h3 className='posicion_h'>Settings</h3>
                                <a href="/perfil" className="opciones texto">
                                    <i className="icons fa-regular fa-user iconos" style={{ color: '#545454' }} />
                                    <h4 className='texto_h'>Mi Perfil</h4>
                                </a>
                                <div
                                    className="opciones"
                                    onClick={abrirModalAjustes}
                                    style={{ cursor: 'pointer' }}
                                >
                                    <i className="icons fa-solid fa-gear iconos" style={{ color: '#545454' }} />
                                    <h4 className='texto_h'>Configuraciones</h4>
                                </div>
                            </div>
                        </div>
                        <div className="box">
                            <div className="ayuda">
                                <div className="overlap-group">
                                    <img
                                        className="primary-button"
                                        src={pribut}
                                        onClick={() => {
                                            setShowPqrsModal(true);
                                            document.documentElement.classList.add('html-no-scroll');
                                        }}
                                        alt="Botón de ayuda PQRS"
                                        style={{ cursor: 'pointer' }}
                                    />
                                </div>
                            </div>
                        </div>
                    </nav>

                    <section className="seccion_busqueda">
                        <div className="contenedor_busqueda">
                            <h1>Buscar Publicaciones</h1>

                            <div className="filtros-busqueda">
                                <label>
                                    <input
                                        type="radio"
                                        name="tipoBusqueda"
                                        value="todo"
                                        checked={tipoBusqueda === "todo"}
                                        onChange={() => setTipoBusqueda("todo")}
                                    />
                                    Todo
                                </label>
                                <label>
                                    <input
                                        type="radio"
                                        name="tipoBusqueda"
                                        value="titulo"
                                        checked={tipoBusqueda === "titulo"}
                                        onChange={() => setTipoBusqueda("titulo")}
                                    />
                                    Títulos
                                </label>
                                <label>
                                    <input
                                        type="radio"
                                        name="tipoBusqueda"
                                        value="usuario"
                                        checked={tipoBusqueda === "usuario"}
                                        onChange={() => setTipoBusqueda("usuario")}
                                    />
                                    Usuarios
                                </label>
                                <label>
                                    <input
                                        type="radio"
                                        name="tipoBusqueda"
                                        value="etiqueta"
                                        checked={tipoBusqueda === "etiqueta"}
                                        onChange={() => setTipoBusqueda("etiqueta")}
                                    />
                                    Etiquetas
                                </label>
                                <label>
                                    <input
                                        type="radio"
                                        name="tipoBusqueda"
                                        value="categoria"
                                        checked={tipoBusqueda === "categoria"}
                                        onChange={() => setTipoBusqueda("categoria")}
                                    />
                                    Categoría
                                </label>
                            </div>

                            <div className="buscador_usuarios">
                                <i className="fa-solid fa-magnifying-glass icono_busqueda"></i>
                                <input
                                    type="text"
                                    placeholder={`Buscar por ${tipoBusqueda === 'todo' ? 'título, usuario o etiqueta' : tipoBusqueda}...`}
                                    value={busqueda}
                                    onChange={(e) => setBusqueda(e.target.value)}
                                    className="input_busqueda"
                                />
                            </div>

                            {cargando && <div className="cargando">Buscando publicaciones...</div>}

                            <div className="resultados_busqueda_publicaciones">
                                {publicaciones.length > 0 ? (
                                    <div className="resultados-columnas-container">
                                        <div className="resultados-columnas-inner">
                                            <div className="home_columnas home_columnas_5c">
                                                {renderizarColumnas(5)}
                                            </div>
                                            <div className="home_columnas home_columnas_4c">
                                                {renderizarColumnas(4)}
                                            </div>
                                            <div className="home_columnas home_columnas_3c">
                                                {renderizarColumnas(3)}
                                            </div>
                                            <div className="home_columnas home_columnas_2c">
                                                {renderizarColumnas(2)}
                                            </div>
                                            <div className="home_columnas home_columnas_1c">
                                                {renderizarColumnas(1)}
                                            </div>
                                        </div>
                                    </div>
                                ) : (
                                    busqueda && !cargando && <div className="sin_resultados">No se encontraron publicaciones</div>
                                )}
                            </div>
                        </div>
                    </section>
                </div>

                {/* Modales */}
                <ModalDetalles
                    idPublicacion={modalPublicacionId}
                    onClose={cerrarDetalles}
                    onOpenPropia={(publicacion) => {
                        setSelectedPublicacion(publicacion);
                        setShowPropiaModal(true);
                        setModalPublicacionId(null);
                        document.documentElement.classList.add('html-no-scroll');
                    }}
                />

                <PublicacionPropiaModal
                    mostrar={showPropiaModal}
                    onClose={cerrarPropiaModal}
                    publicacion={selectedPublicacion}
                    onOpenDetalles={(idPublicacion) => {
                        setModalPublicacionId(idPublicacion);
                        setShowPropiaModal(false);
                        document.documentElement.classList.add('html-no-scroll');
                    }}
                />

                <ModalAjustes
                    mostrar={mostrarModal}
                    onCerrar={cerrarModalAjustes}
                />

                {showPqrsModal && (
                    <PqrsModal onClose={() => {
                        setShowPqrsModal(false);
                        document.documentElement.classList.remove('html-no-scroll');
                    }} />
                )}
            </div>
        </div>
    );
};

export default BusquedaAvanzada;