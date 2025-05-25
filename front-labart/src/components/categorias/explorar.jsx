import React, { useEffect, useState } from "react";
import axios from '../../utils/axiosintance';
import { useNavigate } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import '../../assets/styles/explorar/explorar.css';
import '../../assets/styles/home/estiloh.css';
import logo from '../../assets/img/concepto_logo.png';
import pribut from '../../assets/img/primary-button.svg';
import ModalAjustes from "../modal_configuracion/configuracion";

const Categorias = () => {
  const [categorias, setCategorias] = useState([]);
  const [mostrarModal, setMostrarModal] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    axios.get("/categoria")
      .then(response => {
        setCategorias(response.data);
      })
      .catch(error => {
        console.error("Error al obtener las categorías: ", error);
      });
  }, []);

  const abrirModalAjustes = () => {
    setMostrarModal(true);
    document.documentElement.classList.add('html-no-scroll');
  };

  const cerrarModalAjustes = () => {
    setMostrarModal(false);
    document.documentElement.classList.remove('html-no-scroll');
  };

  const irAPublicacionesCategoria = (idCategoria) => {
    navigate(`/publicaciones-categoria/${idCategoria}`);
  };

  return (
    <div>
      <meta charSet="utf-8" />
      <title>LABART</title>
      <link rel="icon" href="/LABART/img/solo_logo.png" type="image/x-icon" />
      <div className="container-fluid">
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
              <a href="/categoria" className="opciones indicador_actual texto">
                <div className="indicador_opcion" />
                <i className="icon_selected fa-regular fa-compass iconos" />
                <h4 className='text_selected texto_h'>Explorar</h4>
              </a>
              <a href="/buscar-usuario" className="opciones texto">
                <i className="fa-solid fa-magnifying-glass iconos lupa-ajustada" style={{ color: '#545454' }} />
                <h4 className='texto_h'>Buscar Usuario</h4>
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
        <div className="row">
          <div className="col-md-8 col-lg-9 casa" id="casa">
            <div className="row">
              <div className="text-center contendor_tittle_principal">
                <h1>CATEGORIAS</h1>
              </div>

              <div className="input-group contenedor_bucador">{/* buscador */}</div>
              <div className="contenedor_tarjetas_categorias">
                <div className="row">


                  {categorias.map((categoria, index) => (
                    <div
                      key={index}
                      className="col-lg-3 col-md-4 mb-4 card_categoria"
                      onClick={() => irAPublicacionesCategoria(categoria.ID_categoria)}
                      style={{ cursor: "pointer" }}
                    >
                      <img className="imagenes_categorias" src={categoria.Img_categoria} alt={categoria.Nombre_categoria} />
                      <div className="contenedor_tittle_categoria_fila">
                        <h3 className="titulo_categorias">{categoria.Nombre_categoria}</h3>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
        <ModalAjustes mostrar={mostrarModal} onCerrar={cerrarModalAjustes} />
      </div>
    </div>
  );
};

export default Categorias;