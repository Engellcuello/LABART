import React from 'react';
import { Route, Routes } from 'react-router-dom';

import Home from '../pages/Home/Home';
import Cursos from '../pages/cursos/Curso';
import Usuarios from '../pages/usuarios/Usuarios';
import Masinformacion from '../pages/masinformacion/MasInformacion';

const NavbarRoutes = () => {
    return (
        <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/home" element={<Home />} />
            <Route path="/cursos" element={<Cursos />} />
            <Route path="/usuarios" element={<Usuarios />} />
            <Route path="/mas-informacion" element={<Masinformacion />} />
        </Routes>
    );
};

export default NavbarRoutes;