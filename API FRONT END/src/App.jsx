import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Formulario from './components/login/sesion.jsx';
import 'bootstrap/dist/css/bootstrap.min.css';
import '@fortawesome/fontawesome-free/css/all.min.css';
import Home from './components/home/Home.jsx';
import Crud from './components/crud/Crud.jsx';
import Slider from './components/slyder/slider.jsx';
import './assets/styles/form/estilo.css';
import './assets/styles/crud/style.css';
import './assets/styles/home/style.css';
import './assets/styles/home/rs.css';

const App = () => {
    return (
        <Router>
            <Routes>
                <Route
                    path="/"
                    element={
                        <>
                            <div className="container-main">
                                <Formulario />
                                <Slider />
                            </div>
                        </>
                    }
                />
                <Route path="/home" element={<Home />} />
                <Route path="/crud" element={<Crud />} />
            </Routes>
        </Router>
    );
};

export default App;