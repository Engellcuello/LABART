<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TABLA ROL</title>
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
                        <button id="abrigos" class="boton-menu boton-categoria active"><i class="bi bi-hand-index-thumb-fill"></i> Tabla Rol</button>
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
                    <!-- Formulario para agregar Roles -->
                    <h3>Agregar Roles</h3>
                    <form action="../Controlador/controladorRol.php" method="post">
                        <div class="row mt-3">
                            <div class="col-md-4">
                                <label for="ID_rol" class="form-label">Número Rol</label>
                                <input class="form-control" id="ID_rol" name="ID_rol" type="text">
                            </div>

                            <div class="col-md-4">
                                <label for="Nombre_rol" class="form-label">Nombre Rol</label>
                                <input class="form-control" id="Nombre_rol" name="Nombre_rol" type="text">
                            </div>

                            <div class="col-md-4">
                                <label for="Descripcion_rol" class="form-label">Descripcion Rol</label>
                                <input class="form-control" id="Descripcion_rol" name="Descripcion_rol" type="text">
                            </div>
                        </div>

                        <div class="row mt-3 justify-content-center"> 
                          <div class="col-md-4">
                            <label for="ID_estado" class="form-label">Estado</label>
                            <select class="form-select" id="ID_estado" name="ID_estado">
                                <option value="">Seleccionar Estado</option>
                                <?php foreach ($estados as $estado): ?>
                                    <option value="<?php echo $estado['ID_estado']; ?>">
                                        <?php echo $estado['Nombre_estado']; ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>
                        <button class="Boton_refrescar mt-3" type="submit" name="Acciones" value="Crear Rol">Crear Roles</button>
                    </form>




                        <!-- Tabla de Roles -->
                        <h3 class="mt-3">Lista de Roles</h3>
                        <form action="../Controlador/controladorRol.php" method="post">
                            <button class="Boton_refrescar mb-3" type="submit" name="Acciones" value="Refrescar tabla">Refrescar tabla</button>
                        </form>
                        <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>ID_rol</th>
                                    <th>Nombre_rol</th>
                                    <th>Descripcion_rol</th>
                                    <th>ID_estado</th>
                                    <th>Actualizar</th>
                                    <th>Rol a Inexistente</th>
                                </tr>
                            </thead>

                            <tbody>
                                <?php
                                while ($fila = mysqli_fetch_assoc($resultado)) {
                                    echo "<tr>";
                                    echo "<td>{$fila['ID_rol']}</td>";
                                    echo "<td>{$fila['Nombre_rol']}</td>";
                                    echo "<td>{$fila['Descripcion_rol']}</td>";
                                    echo "<td>{$fila['ID_estado']}</td>";
                                    
                                    // Botón para abrir el modal de actualización
                                    echo "<td><button class='Boton_refrescar' style='padding: 0.40rem 0.5rem; font-size: 1rem;' data-bs-toggle='modal' data-bs-target='#updateModal{$fila['ID_rol']}'>Editar</button></td>";

                                    // Botón para cambiar el estado de la cita
                                    echo "<td>
                                        <form action='../Controlador/controladorRol.php' method='post'>
                                            <input type='hidden' name='ID_rol' value='{$fila['ID_rol']}'>
                                            <button class='btn btn-danger' style='padding: 0.40rem 0.5rem; font-size: 0.7rem;' type='submit' name='Acciones' value='Borrar Rol'>Cambiar</button>
                                        </form>
                                    </td>";
                                    echo "</tr>";

                                    // Modal para actualizar la cita
                                    echo '<div class="modal fade" id="updateModal' . $fila['ID_rol'] . '" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">';
                                    echo '<div class="modal-dialog">';
                                    echo '<div class="modal-content">';
                                    echo '<div class="modal-header">';
                                    echo '<h5 class="modal-title" id="updateModalLabel">Actualizar Rol - ID: ' . $fila['ID_rol'] . '</h5>';
                                    echo '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>';
                                    echo '</div>';
                                    echo '<div class="modal-body">';
                                    echo '<form action="../Controlador/controladorRol.php" method="post">';
                                    echo '<input type="hidden" name="ID_rol" value="' . $fila['ID_rol'] . '">';
                                    echo '<div class="mb-3">
                                        <label class="form-label">Nombre Rol</label>
                                        <input class="form-control" name="Nombre_rol" type="text" value="' . $fila['Nombre_rol'] . '">
                                    </div>';
                                    echo '<div class="mb-3">
                                        <label class="form-label">Descripcion Rol</label>
                                        <input class="form-control" name="Descripcion_rol" type="text" value="' . $fila['Descripcion_rol'] . '">
                                    </div>';
                                   
                                    echo '<div class="mb-3">
                                        <label for="ID_estado" class="form-label">Estado Rol</label>
                                        <select class="form-control" id="ID_estado" name="ID_estado">
                                            <option value="">Seleccionar Estado</option>';
                                    
                                    foreach ($estados as $estado) {
                                        $selected = ($estado['ID_estado'] == $fila['ID_estado']) ? 'selected' : '';
                                        echo '<option value="' . $estado['ID_estado'] . '" ' . $selected . '>'
                                            . $estado['Nombre_estado'] . 
                                            '</option>';
                                    }
                                    echo '</select>
                                    </div>';

                                    echo '<button class="Boton_refrescar" type="submit" name="Acciones" value="Actualizar Rol">Actualizar Rol</button>';
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
