<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HOME</title>
    <link rel="StyleSheet" href="../Crud_Labart/style.css">
    <link rel="StyleSheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">
</head>

<body>
<div class="wrapper">
        <header class="header-mobile">
            <button class="open-menu" id="toggle-menu">
                <i class="bi bi-list"></i>
            </button>
        </header>
        <aside id="aside-menu">
            <button class="close-menu" id="close-menu">
                <i class="bi bi-x"></i>
            </button>
            <header>
                <h1 class="logo">CRUD DB LABART</h1>
            </header>
            <nav>
                <ul class="menu">
                    <li>
                        <button id="todos" class="boton-menu boton-categoria" onclick="location.href='../index.php';">
                            <i class="bi bi-hand-index-thumb"></i> Todas Las Tablas
                        </button>
                    </li>
                    <li>
                        <button id="abrigos" class="boton-menu boton-categoria active">
                            <i class="bi bi-hand-index-thumb-fill"></i> Tabla Sexo
                        </button>
                    </li>
                </ul>
            </nav>
            <footer>
                <a></a>
            </footer>
        </aside>
        <main>
        <h2 class="titulo-principal" id="titulo-principal">ESCOGER UNA TABLA</h2>
            <div id="contenedor-productos" class="contenedor-productos">
                <div class="contenedor">
                <div class="col-md-4">
                <a href="Controlador/controladorUsuario.php" class="enviar">Tabla Usuario</a>
                
                <a href="Controlador/controladorSexo.php" class="enviar">Tabla Sexo</a>
               
                <a href="Controlador/controladorEstado.php" class="enviar">Tabla Estado</a>
               
                <a href="Controlador/controladorRol.php" class="enviar">Tabla Roles</a>
               
                <a href="Controlador/controladorPqrs.php" class="enviar">Tabla Pqrs</a>
                </div>
                </div>
            </div>           
        </main>
    </div>
    <script src="../Crud_Labart/Vista/aside.js"></script>
</body>
</html>