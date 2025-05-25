import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Formulario from './components/login/sesion.jsx';
import 'bootstrap/dist/css/bootstrap.min.css';
import '@fortawesome/fontawesome-free/css/all.min.css';
import Home from './components/home/Home.jsx';
import Crud from './components/crud/Crud.jsx';
import Slider from './components/slyder/slider.jsx';
import Perfil from './components/perfil/perfil.jsx';
import Categorias from './components/categorias/explorar.jsx';
import Asistente from './components/asistente/Asistente.jsx';
import EditarPerfil from './components/editar_perfil/EditarPerfil.jsx';
import PublicacionesCategoria from './components/publicacion_categoria/PublicacionesCategoria.jsx';
import PerfilUsuarioTercero from './components/perfil/perfil_tercero.jsx';
import PublicacionesRecomendadas from './components/recomendados_usuario/PublicacionesRecomendadas.jsx';
import BuscarUsuario from './components/home/Buscador_usuario.jsx'; 
import NotificationsPage from './components/home/Notificaciones.jsx';
import { AuthGuard, RolGuard  } from './components/Autenticador/Authuser.jsx';
import './assets/styles/notificaciones/notificaciones.css';
import './assets/styles/form/estilo.css';
import './assets/styles/home/estiloh.css';
import './assets/styles/home/rs.css';
import './assets/styles/explorar/explorar.css';
import './assets/styles/asistente/Asistente.css';
import './assets/styles/configuracion/configuracion.css';
import './assets/styles/perfil/editar_perfil.css';
import './assets/styles/verificacion/verificacion.css';
import './assets/styles/home/Buscador_usuario.css';


 const backendUrl = "http://127.0.0.1:5000";


const App = () => {
    return (
    <Router>
      <Routes>
        <Route
          path="/"
          element={
            <div className="container-main">
              <Formulario />
              <Slider />
            </div>
          }
        />

        <Route element={<AuthGuard />}>
          <Route path="/home" element={<Home />} />

          <Route element={<RolGuard allowedRoles={['1']} />}>
            <Route path="/crud" element={<Crud />} />
          </Route>
          <Route path="/perfil" element={<Perfil />} />
          <Route path="/categoria" element={<Categorias />} />
          <Route path="/asistente" element={<Asistente />} />
          <Route path="/editar-perfil" element={<EditarPerfil />} />
          <Route path="/publicaciones-categoria/:idCategoria" element={<PublicacionesCategoria />} />
          <Route path="/perfil_tercero/:idUsuario" element={<PerfilUsuarioTercero />} />
          <Route path="/publicaciones-recomendadas" element={<PublicacionesRecomendadas />} />
          <Route path="/buscar-usuario" element={<BuscarUsuario />} />
          <Route path="/notificaciones" element={<NotificationsPage />} />
        </Route>

        <Route path="*" element={<h1>404 - Página no encontrada</h1>} />
      </Routes>
    </Router>
  );
};

export default App;