<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TABLA USUARIO</title>
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
            <h2 class="titulo-principal" id="titulo-principal">INGRESAR DATOS</h2>
            <div id="contenedor-productos" class="contenedor-productos">
    <div class="contenedor">
        <h3>Agregar Usuarios</h3>
        <form action="../Controlador/controladorUsuario.php" method="post">
            <div class="row">
                <div class="col-md-4 mt-1">
                    <label for="ID_usuario" class="form-label">Número Usuario</label>
                    <input class="form-control" id="ID_usuario" name="ID_usuario" type="text" pattern="{0-9}" required>
                </div>

                <div class="col-md-4">
                    <label for="Nombre_usuario" class="form-label">Nombre usuario</label>
                    <input class="form-control" id="Nombre_usuario" name="Nombre_usuario" type="text" pattern="{A-Za-z}" required>
                </div>

                <div class="col-md-4">
                    <label for="Contraseña" class="form-label">Contraseña Usuario</label>
                    <input class="form-control" id="Contraseña" name="Contraseña" type="password" pattern="{A-Za-z0-9}" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <label for="Correo_usuario" class="form-label">Correo Usuario</label>
                    <input class="form-control" id="Correo_usuario" name="Correo_usuario" type="text" required>
                </div>

                <div class="col-md-4">
                    <label for="Fecha_usuario" class="form-label">Fecha Usuario</label>
                    <input class="form-control" id="Fecha_usuario" name="Fecha_usuario" type="date" required>
                </div>

                <div class="col-md-4">
                    <label for="Notificaciones" class="form-label">Activar Notificaciones</label>
                        <!-- Opción para Activar las Notificaciones -->
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="Notificaciones" value="1" required>
                            <label class="form-check-label">Activar</label>
                        </div>
                        
                        <!-- Opción para Desactivar las Notificaciones -->
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="Notificaciones" value="0" required>
                            <label class="form-check-label">Desactivar</label>
                        </div>
                </div>
              
            <div class="row mt-3">
                <div class="col-md-4">
                    <label for="ID_sexo" class="form-label">Sexo</label>
                    <select class="form-select" id="ID_sexo" name="ID_sexo" required>
                        <option value="">Seleccionar Sexo</option>
                        <?php foreach ($sexos as $sexo): ?>
                            <option value="<?= $sexo['ID_sexo']; ?>">
                                <?= $sexo['Nombre_sexo']; ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>

                <div class="col-md-4">
                    <label for="Img_usuario" class="form-label">Imagen usuario</label>
                    <input class="form-control" id="Img_usuario" name="Img_usuario" type="file">
                </div>

                <div class="col-md-4">
                    <label for="ID_rol" class="form-label">Rol</label>
                    <select class="form-select" id="ID_rol" name="ID_rol" required>
                        <option value="">Seleccionar Rol</option>
                        <?php foreach ($roles as $rol): ?>
                            <option value="<?= $rol['ID_rol']; ?>">
                                <?= $rol['Nombre_rol']; ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
            
            </div>
            <div class="row mt-3 justify-content-center">
            <div class="col-md-4">
                    <label for="Cont_explicit" class="form-label">Activar Contenido explicito</label>
                    <div class="form-check">
                             <input class="form-check-input" type="radio" name="Cont_Explicit" value="1"required>
                    <label class="form-check-label">Activar</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="Cont_Explicit" value="0" required>
                        <label class="form-check-label">Desactivar</label>
                    </div>
                </div>
            </div>
            </div>

            <button class="Boton_refrescar mt-3" type="submit" name="Acciones" value="Crear Usuario">Crear Usuario</button>
        </form>
    </div>
</div>

                                        


                        <!-- Tabla de usuarios -->
                        <h3 class="mt-3">Lista de Usuarios</h3>
                        <form action="../Controlador/controladorUsuario.php" method="post">
                            <button class="Boton_refrescar mb-3" type="submit" name="Acciones"  value="Refrescar tabla">Refrescar tabla</button>
                        </form>
                        <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>ID_usuario</th>
                                    <th>Nombre_usuario</th>
                                    <th>Contraseña</th>
                                    <th>Correo_usuario</th>
                                    <th>Fecha_usuario</th>
                                    <th>Notificaciones</th>
                                    <th>ID_sexo</th>
                                    <th>Img_usuario</th>
                                    <th>ID_rol</th>
                                    <th>Cont_Explicit</th>
                                    <th>Actualizar</th>
                                    <th>Notificaciones a '0'</th>
                                </tr>
                            </thead>

                            <tbody>
                                <?php
                                while ($fila = mysqli_fetch_assoc($resultado)) {
                                    echo "<tr>";
                                    echo "<td>{$fila['ID_usuario']}</td>";
                                    echo "<td>{$fila['Nombre_usuario']}</td>";
                                    echo "<td>{$fila['Contraseña']}</td>";
                                    echo "<td>{$fila['Correo_usuario']}</td>";
                                    echo "<td>{$fila['Fecha_usuario']}</td>";
                                    echo "<td>{$fila['Notificaciones']}</td>";
                                    echo "<td>{$fila['ID_sexo']}</td>";
                                    echo "<td>{$fila['Img_usuario']}</td>";
                                    echo "<td>{$fila['ID_rol']}</td>";
                                    echo "<td>{$fila['Cont_Explicit']}</td>";
                                    
                                    // Botón para abrir el modal de actualizacion
                                    echo "<td><button class='Boton_refrescar' style='padding: 0.60rem 1rem; font-size: 1rem;' data-bs-toggle='modal' data-bs-target='#updateModal{$fila['ID_usuario']}'>Editar</button></td>";

                                    echo "<td>
                                    <form action='../Controlador/controladorUsuario.php' method='post'>
                                        <input type='hidden' name='ID_usuario' value='{$fila['ID_usuario']}'>
                                        <button class='btn btn-danger' type='submit' name='Acciones' style='padding: 0.60rem 1rem; font-size: 1rem;' value='Borrar Usuario'>Cambiar</button>
                                    </form>
                                    </td>";

                                    // Modal para actualizar usuarios
                                    echo '<div class="modal fade" id="updateModal' . $fila['ID_usuario'] . '" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">';
                                    echo '<div class="modal-dialog">';
                                    echo '<div class="modal-content">';
                                    echo '<div class="modal-header">';
                                    echo '<h5 class="modal-title" id="updateModalLabel">Actualizar Usuario - ID: ' . $fila['ID_usuario'] . '</h5>';
                                    echo '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>';
                                    echo '</div>';
                                    echo '<div class="modal-body">';
                                    echo '<form action="../Controlador/controladorUsuario.php" method="post">';
                                    echo '<input type="hidden" name="ID_usuario" value="' . $fila['ID_usuario'] . '">';
                                    echo '<div class="mb-3">
                                        <label class="form-label">Nombre Usuario</label>
                                        <input class="form-control" name="Nombre_usuario" type="text" value="' . $fila['Nombre_usuario'] . '">
                                    </div>';
                                    echo '<div class="mb-3">
                                        <label class="form-label">Contraseña Usuario</label>
                                        <input class="form-control" name="Contraseña" type="password" value="' . $fila['Contraseña'] . '">
                                    </div>';
                                    echo '<div class="mb-3">
                                        <label class="form-label">Correo Usuario</label>
                                        <input class="form-control" name="Correo_usuario" type="text" value="' . $fila['Correo_usuario'] . '">
                                    </div>';

                                    echo '<div class="mb-3">
                                        <label class="form-label">Fecha Usuario</label>
                                        <input class="form-control" name="Fecha_usuario" type="date" value="' . $fila['Fecha_usuario'] . '">
                                    </div>';

                                    echo '<div class="mb-3">
                                        <label class="form-label">Notificaciones</label>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="Notificaciones" value="1"' . ($fila['Notificaciones'] == 1 ? ' checked' : '') . '>
                                            <label class="form-check-label">Activar</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="Notificaciones" value="0"' . ($fila['Notificaciones'] == 0 ? ' checked' : '') . '>
                                            <label class="form-check-label">Desactivar</label>
                                        </div>
                                    </div>';



                                    echo '<div class="mb-3">
                                        <label for="ID_sexo" class="form-label">Sexo Usuario</label>
                                        <select class="form-control" id="ID_sexo " name="ID_sexo">
                                            <option value="">Seleccionar Sexo</option>';
                                    foreach ($sexos as $sexo) {
                                        $selected = ($sexo['ID_sexo'] == $fila['ID_sexo']) ? 'selected' : '';
                                        echo '<option value="' . $sexo['ID_sexo'] . '" ' . $selected . '>'
                                            . $sexo['Nombre_sexo'] .
                                            '</option>';
                                    }
                                    
                                    echo '</select>
                                    </div>';

                                    echo '<div class="mb-3">
                                        <label class="form-label">Imagen Usuario</label>
                                        <input class="form-control" name="Img_usuario" type="file" value="' . $fila['Img_usuario'] . '">
                                    </div>';


                                    echo '<div class="mb-3">
                                        <label for="ID_rol" class="form-label">Rol Usuario</label>
                                        <select class="form-control" id="ID_rol" name="ID_rol">
                                            <option value="">Seleccionar Rol</option>';
                                    
                                    foreach ($roles as $rol) {
                                        $selected = ($rol['ID_rol'] == $fila['ID_rol']) ? 'selected' : '';
                                        echo '<option value="' . $rol['ID_rol'] . '" ' . $selected . '>'
                                            . $rol['Nombre_rol'] .
                                            '</option>';
                                    }

                                    echo '</select>
                                    </div>';


                                    echo '<div class="mb-3">
                                    <label class="form-label">Contenido explícito</label>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="Cont_Explicit" value="1"' . ($fila['Cont_Explicit'] == 1 ? ' checked' : '') . '>
                                        <label class="form-check-label">Activar</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="Cont_Explicit" value="0"' . ($fila['Cont_Explicit'] == 0 ? ' checked' : '') . '>
                                        <label class="form-check-label">Desactivar</label>
                                    </div>
                                </div>';


                                   
                                    echo '<button class="Boton_refrescar" type="submit" name="Acciones" value="Actualizar Usuario">Actualizar Usuario</button>';
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
