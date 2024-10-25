<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TABLA SEXO</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="wrapper justify-content-center">
        <header class="header-mobile">
            <button class="open-menu" id="open-menu">
                <i class="bi bi-list"></i>
            </button>
        </header>
        <aside>
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
                        <button id="abrigos" class="boton-menu boton-categoria active"><i class="bi bi-hand-index-thumb-fill"></i> Tabla Sexo</button>
                    </li>
                </ul>
            </nav>
            <footer>
                <a></a>
            </footer>
        </aside>
        <main>
            <h2 class="titulo-principal" id="titulo-principal">INGRESAR DATOS</h2>
            <div id="contenedor-productos" class="contenedor-productos">
                <div class="contenedor">
                    <!-- Formulario para agregar Sexos -->
                    <h3>Agregar Sexos</h3>
                    <form action="../Controlador/controladorSexo.php" method="post">
                        <div class="row mt-3">
                            <div class="col-md-4">
                                <label for="ID_sexo" class="form-label">Número Sexo</label>
                                <input class="form-control" id="ID_sexo" name="ID_sexo" type="text">
                            </div>

                            <div class="col-md-4">
                                <label for="Descripcion_sexo" class="form-label">Descripcion Sexo</label>
                                <input class="form-control" id="Descripcion_sexo" name="Descripcion_sexo" type="text">
                            </div>

                            <div class="col-md-4">
                                <label for="Nombre_sexo" class="form-label">Nombre Sexo</label>
                                <input class="form-control" id="Nombre_sexo" name="Nombre_sexo" type="text">
                            </div>
                        </div>


                        <button class="Boton_refrescar mt-3" type="submit" name="Acciones" value="Crear Sexo">Crear Sexo</button>

                    </form>




                        <!-- Tabla de Sexo -->
                        <h3 class="mt-3">Lista de Sexo</h3>
                        <form action="../Controlador/controladorSexo.php" method="post">
                            <button class="Boton_refrescar mb-3" type="submit" name="Acciones" value="Refrescar tabla">Refrescar tabla</button>
                        </form>
                        <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>ID_sexo</th>
                                    <th>Descripcion_sexo</th>
                                    <th>Nombre_sexo</th>
                                    <th>Editar Sexo</th>
                                    <th>Cambiar Sexo 'Indefinido'</th>
                                </tr>
                            </thead>

                            <tbody>
                                <?php
                                while ($fila = mysqli_fetch_assoc($resultado)) {
                                    echo "<tr>";
                                    echo "<td>{$fila['ID_sexo']}</td>";
                                    echo "<td>{$fila['Descripcion_sexo']}</td>";
                                    echo "<td>{$fila['Nombre_sexo']}</td>";

                                    
                                    // Botón para abrir el modal de actualización
                                    echo "<td><button class='Boton_refrescar' style='padding: 0.40rem 0.5rem; font-size: 1rem;' data-bs-toggle='modal' data-bs-target='#updateModal{$fila['ID_sexo']}'>Editar</button></td>";

                                    // Botón para sexo
                                    echo "<td>
                                        <form action='../Controlador/controladorSexo.php' method='post'>
                                            <input type='hidden' name='ID_sexo' value='{$fila['ID_sexo']}'>
                                            <button class='btn btn-danger' style='padding: 0.40rem 0.5rem; font-size: 1rem;' type='submit' name='Acciones' value='Borrar Sexo'>Cambiar</button>
                                        </form>
                                    </td>";
                                    echo "</tr>";

                                    // Modal para actualizar el sexo
                                    echo '<div class="modal fade" id="updateModal' . $fila['ID_sexo'] . '" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">';
                                    echo '<div class="modal-dialog">';
                                    echo '<div class="modal-content">';
                                    echo '<div class="modal-header">';
                                    echo '<h5 class="modal-title" id="updateModalLabel">Actualizar Estado - ID: ' . $fila['ID_sexo'] . '</h5>';
                                    echo '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>';
                                    echo '</div>';
                                    echo '<div class="modal-body">';
                                    echo '<form action="../Controlador/controladorSexo.php" method="post">';
                                    echo '<input type="hidden" name="ID_sexo" value="' . $fila['ID_sexo'] . '">';
                                    echo '<div class="mb-3">
                                        <label class="form-label">Descripcion Sexo</label>
                                        <input class="form-control" name="Descripcion_sexo" type="text" value="' . $fila['Descripcion_sexo'] . '">
                                    </div>';
                                    echo '<div class="mb-3">
                                        <label class="form-label">Nombre Sexo</label>
                                        <input class="form-control" name="Nombre_sexo" type="text" value="' . $fila['Nombre_sexo'] . '">
                                    </div>';
                                    echo '<button class="Boton_refrescar" type="submit" name="Acciones" value="Actualizar Sexo">Actualizar Sexo</button>';
                                    echo '</form>';
                                    echo '</div>';
                                    echo '</div>';
                                    echo '</div>';
                                    echo '</div>';
                                    
                                }
                                ?>
                            </tbody>
                        </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
