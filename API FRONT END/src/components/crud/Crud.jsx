import React from 'react';
import '../../assets/styles/crud/style.css';
import 'bootstrap-icons/font/bootstrap-icons.css';

const Crud = () => {
  return (
    <div className="wrapper">
      <header className="header-mobile">
        <button className="open-menu" id="toggle-menu">
          <i className="bi bi-list" />
        </button>
      </header>
      <aside id="aside-menu">
        <button className="close-menu" id="close-menu">
          <i className="bi bi-x" />
        </button>
        <header>
          <h1 className="logo">CRUD DB LABART</h1>
        </header>
        <nav>
          <ul className="menu">
            <li>
              <button id="todos" className="boton-menu boton-categoria" onclick="location.href='../index.php';">
                <i className="bi bi-hand-index-thumb" /> Todas Las Tablas
              </button>
            </li>
            <li>
              <button id="abrigos" className="boton-menu boton-categoria active">
                <i className="bi bi-hand-index-thumb-fill" /> Tabla Sexo
              </button>
            </li>
          </ul>
        </nav>
        <footer>
          <a />
        </footer>
      </aside>
      <main>
        <h2 className="titulo-principal" id="titulo-principal">ESCOGER UNA TABLA</h2>
        <div id="contenedor-productos" className="contenedor-productos">
          <div className="contenedor">
            <div className="col-md-4">
              <a href="Controlador/controladorUsuario.php" className="enviar">Tabla Usuario</a>
              <a href="Controlador/controladorSexo.php" className="enviar">Tabla Sexo</a>
              <a href="Controlador/controladorEstado.php" className="enviar">Tabla Estado</a>
              <a href="Controlador/controladorRol.php" className="enviar">Tabla Roles</a>
              <a href="Controlador/controladorPqrs.php" className="enviar">Tabla Pqrs</a>
            </div>
          </div>
        </div>
      </main>
    </div>

  );
};

export default Crud;