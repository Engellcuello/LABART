<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TABLA CATEGORIA</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../Vista/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>
    <div class="wrapper">
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
                        <button id="abrigos" class="boton-menu boton-categoria active"><i class="bi bi-hand-index-thumb-fill"></i> Tabla Categoria</button>
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
                    <!-- Formulario para agregar citas -->
                    <h3>Agregar Citas</h3>
                    <form action="../Controlador/controladorCitas.php" method="post">
                        <div class="row mt-3">
                            <div class="col-md-4">
                                <label for="CitNumero" class="form-label">Número Cita</label>
                                <input class="form-control" id="CitNumero" name="CitNumero" type="text">
                            </div>

                            <div class="col-md-4">
                                <label for="CitFecha" class="form-label">Fecha Cita</label>
                                <input class="form-control" id="CitFecha" name="CitFecha" type="date">
                            </div>

                            <div class="col-md-4">
                                <label for="CitHora" class="form-label">Hora Cita</label>
                                <input class="form-control" id="CitHora" name="CitHora" type="time">
                            </div>
                        </div>

                        <div class="row mt-3">
                            <div class="col-md-4">
                                <label for="CitPaciente" class="form-label">Paciente</label>
                                <select class="form-select" id="CitPaciente" name="CitPaciente">
                                    <option value="">Seleccionar Paciente</option>
                                    <?php foreach ($pacientes as $paciente): ?>
                                        <option value="<?= $paciente['PacIdentificacion']; ?>">
                                            <?= $paciente['PacNombres'] . ' ' . $paciente['PacApellidos']; ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label for="CitMedico" class="form-label">Medico</label>
                                <select class="form-select" id="CitMedico" name="CitMedico">
                                    <option value="">Seleccionar Medico</option>
                                    <?php foreach ($medicos as $medico): ?>
                                        <option value="<?= $medico['MedIdentificacion']; ?>">
                                            <?= $medico['MedNombres'] . ' ' . $medico['MedApellidos']; ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label for="CitConsultorio" class="form-label">Consultorio</label>
                                <select class="form-select" id="CitConsultorio" name="CitConsultorio">
                                    <option value="">Seleccionar Consultorio</option>
                                    <?php foreach ($consultorios as $consultorio): ?>
                                        <option value="<?= $consultorio['ConNumero']; ?>">
                                            <?= $consultorio['ConNombre']; ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                        </div>

                        <div class="row mt-3 justify-content-center">
                            <div class="col-md-4">
                                <label class="form-label">Estado Cita</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="CitEstado" id="CitEstadoA" value="Asignada">
                                    <label class="form-check-label" for="CitEstadoA">Asignada</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="CitEstado" id="CitEstadoC" value="Cumplida">
                                    <label class="form-check-label" for="CitEstadoC">Cumplida</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="CitEstado" id="CitEstadoS" value="Solicitada">
                                    <label class="form-check-label" for="CitEstadoS">Solicitada</label>
                                </div>
                            </div>
                        </div>

                        <button class="btn btn-success mt-3" type="submit" name="Acciones" value="Crear Cita">Crear Cita</button>
                    </form>




                        <!-- Tabla de citas -->
                        <h3 class="mt-3">Lista de Citas</h3>
                        <form action="../Controlador/controladorCitas.php" method="post">
                            <button class="btn btn-primary mb-3" type="submit" name="Acciones" value="Refrescar tabla">Refrescar tabla</button>
                        </form>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>CitNumero</th>
                                    <th>CitFecha</th>
                                    <th>CitHora</th>
                                    <th>CitPaciente</th>
                                    <th>CitMedico</th>
                                    <th>CitConsultorio</th>
                                    <th>CitEstado</th>
                                    <th>Actualizar</th>
                                    <th>Estado a 'Cancelada'</th>
                                </tr>
                            </thead>

                            <tbody>
                                <?php
                                while ($fila = mysqli_fetch_assoc($resultado)) {
                                    echo "<tr>";
                                    echo "<td>{$fila['CitNumero']}</td>";
                                    echo "<td>{$fila['CitFecha']}</td>";
                                    echo "<td>{$fila['CitHora']}</td>";
                                    echo "<td>{$fila['CitPaciente']}</td>";
                                    echo "<td>{$fila['CitMedico']}</td>";
                                    echo "<td>{$fila['CitConsultorio']}</td>";
                                    echo "<td>{$fila['CitEstado']}</td>";
                                    
                                    // Botón para abrir el modal de actualización
                                    echo "<td><button class='btn btn-warning' data-bs-toggle='modal' data-bs-target='#updateModal{$fila['CitNumero']}'>Editar</button></td>";

                                    // Botón para cambiar el estado de la cita
                                    echo "<td>
                                        <form action='../Controlador/controladorCitas.php' method='post'>
                                            <input type='hidden' name='CitNumero' value='{$fila['CitNumero']}'>
                                            <button class='btn btn-danger' type='submit' name='Acciones' value='Borrar Cita'>Cambiar</button>
                                        </form>
                                    </td>";
                                    echo "</tr>";

                                    // Modal para actualizar la cita
                                    echo '<div class="modal fade" id="updateModal' . $fila['CitNumero'] . '" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">';
                                    echo '<div class="modal-dialog">';
                                    echo '<div class="modal-content">';
                                    echo '<div class="modal-header">';
                                    echo '<h5 class="modal-title" id="updateModalLabel">Actualizar Cita - ID: ' . $fila['CitNumero'] . '</h5>';
                                    echo '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>';
                                    echo '</div>';
                                    echo '<div class="modal-body">';
                                    echo '<form action="../Controlador/controladorCitas.php" method="post">';
                                    echo '<input type="hidden" name="CitNumero" value="' . $fila['CitNumero'] . '">';
                                    echo '<div class="mb-3">
                                        <label class="form-label">Fecha cita</label>
                                        <input class="form-control" name="CitFecha" type="date" value="' . $fila['CitFecha'] . '">
                                    </div>';
                                    echo '<div class="mb-3">
                                        <label class="form-label">Cita hora</label>
                                        <input class="form-control" name="CitHora" type="time" value="' . $fila['CitHora'] . '">
                                    </div>';
                                    echo '<div class="mb-3">
                                        <label for="CitPaciente" class="form-label">Paciente Cita</label>
                                        <select class="form-control" id="CitPaciente" name="CitPaciente">
                                            <option value="">Seleccionar Paciente</option>';
                                    
                                    foreach ($pacientes as $paciente) {
                                        $selected = ($paciente['PacIdentificacion'] == $fila['CitPaciente']) ? 'selected' : '';
                                        echo '<option value="' . $paciente['PacIdentificacion'] . '" ' . $selected . '>'
                                            . $paciente['PacNombres'] . ' ' . $paciente['PacApellidos'] .
                                            '</option>';
                                    }
                                    
                                    echo '</select>
                                    </div>';
                                    echo '<div class="mb-3">
                                        <label for="CitMedico" class="form-label">Medico cita</label>
                                        <select class="form-control" id="CitMedico" name="CitMedico">
                                            <option value="">Seleccionar Medico</option>';
                                    
                                    foreach ($medicos as $medico) {
                                        $selected = ($medico['MedIdentificacion'] == $fila['CitMedico']) ? 'selected' : '';
                                        echo '<option value="' . $medico['MedIdentificacion'] . '" ' . $selected . '>'
                                            . $medico['MedNombres'] . ' ' . $medico['MedApellidos'] .
                                            '</option>';
                                    }
                                    
                                    echo '</select>
                                    </div>';
                                    echo '<div class="mb-3">
                                        <label for="CitConsultorio" class="form-label">Consultorio Cita</label>
                                        <select class="form-control" id="CitConsultorio" name="CitConsultorio">
                                            <option value="">Seleccionar Consultorio</option>';
                                    
                                    foreach ($consultorios as $consultorio) {
                                        $selected = ($consultorio['ConNumero'] == $fila['CitConsultorio']) ? 'selected' : '';
                                        echo '<option value="' . $consultorio['ConNumero'] . '" ' . $selected . '>'
                                            . $consultorio['ConNombre'] . '</option>';
                                    }
                                    
                                    echo '</select>
                                    </div>';
                                    echo '<div class="mb-3">
                                        <label class="form-label">Cita Estado</label>
                                        <select class="form-select" name="CitEstado">
                                            <option value="Asignada">Asignada</option>
                                            <option value="Cumplida">Cumplida</option>
                                            <option value="Solicitada">Solicitada</option>
                                        </select>
                                    </div>';
                                    echo '<button class="btn btn-warning" type="submit" name="Acciones" value="Actualizar Cita">Actualizar Cita</button>';
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
            </main>
        </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
