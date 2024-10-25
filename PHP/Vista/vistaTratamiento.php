<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tratamiento</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
    <style>
        body {
            background-color: #09B7D6;
        }

        .container {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }

        h1,
        h3 {
            color: #343a40;
        }

        form {
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
        }

        .btn {
            border-radius: 5px;
        }

        table {
            margin-top: 20px;
        }

        th,
        td {
            vertical-align: middle !important;
            text-align: center;
        }

        .formulario {
            margin-bottom: -20px;
            align-items: center
        }
    </style>
    <center>
        <div class="container mt-5">
            <h1 class="mb-3">Tratamiento</h1>
            <a class="btn btn-secondary" href="../index.php">Volver menú principal</a>
            <hr>
            <h3>Lista de Tratamientos</h3>
            <form action="../Controlador/controladorTratamiento.php" method="post">
                <button class="btn btn-primary mb-3" type="submit" name="Acciones" value="Refrescar tabla">Refrescar tabla</button>
            </form>
            <div class="table-responsive mt-3">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>TraNumero </th>
                            <th>TraFechaAsignado</th>
                            <th>TraDescripcion</th>
                            <th>TraFechaInicio</th>
                            <th>TraFechaFin</th>
                            <th>TraObservaciones</th>
                            <th>TraPaciente</th>
                            <th>TraEstado</th>
                            <td><strong>Actualizar Tratamiento</strong></td>
                            <td><strong>Cambiar Estado</strong></td>
                        </tr>

                    </thead>
                    <tbody>
                        <?php
                        while ($fila = mysqli_fetch_assoc($resultado)) {

                            //Solicita todos los datos en caso de cometer error al registrarlo, poder modificarlo.
                            //Permite cambiar el estado en caso de querer  volver activar Medico.

                            echo "<tr>";
                            echo "<td>" . $fila['TraNumero'] . "</td>";
                            echo "<td>" . $fila['TraFechaAsignado'] . "</td>";
                            echo "<td>" . $fila['TraDescripcion'] . "</td>";
                            echo "<td>" . $fila['TraFechaInicio'] . "</td>";
                            echo "<td>" . $fila['TraFechaFin'] . "</td>";
                            echo "<td>" . $fila['TraObservaciones'] . "</td>";
                            echo "<td>" . $fila['TraPaciente'] . "</td>";
                            echo "<td>" . $fila['TraEstado'] . "</td>";
                            echo '<td>
                                <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#updateModal' . $fila['TraNumero'] . '">Editar</button>
                              </td>';

                            echo '<td>
                              <form action="../Controlador/controladorTratamiento.php" method="post">
                                  <input type="hidden" name="TraNumero" value="' . $fila['TraNumero'] . '">
                                  <button class="btn btn-danger formulario" type="submit" name="Acciones" value="Borrar Tratamiento">Cambiar</button>
                              </form>
                            </td>';
                            echo "</tr>";
                            echo '<div class="modal fade" id="updateModal' . $fila['TraNumero'] . '" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">';
                            echo '<div class="modal-dialog">';
                            echo '<div class="modal-content">';
                            echo '<div class="modal-header">';
                            echo '<h5 class="modal-title" id="updateModalLabel">Actualizar Paciente - ID: ' . $fila['TraNumero'] . '</h5>';
                            echo '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>';
                            echo '</div>';
                            echo '<div class="modal-body">';
                            echo '<form action="../Controlador/controladorTratamiento.php" method="post">';
                            echo '<input type="hidden" name="TraNumero" value="' . $fila['TraNumero'] . '">';
                            echo '<div class="mb-3">
                                <label class="form-label">Fecha Asignada</label>
                                <input class="form-control" name="TraFechaAsignado" type="Date" value="' . $fila['TraFechaAsignado'] . '">
                              </div>';
                            echo '<div class="mb-3">
                              <label class="form-label">Tratamiento Descripcion</label>
                              <input class="form-control" name="TraDescripcion" type="text" value="' . $fila['TraDescripcion'] . '">
                            </div>';
                            echo '<div class="mb-3">
                                <label class="form-label">Fecha Inicio</label>
                                <input class="form-control" name="TraFechaInicio" type="Date" value="' . $fila['TraFechaInicio'] . '">
                              </div>';
                              echo '<div class="mb-3">
                                <label class="form-label">Fecha Fin</label>
                                <input class="form-control" name="TraFechaFin" type="Date" value="' . $fila['TraFechaFin'] . '">
                              </div>';
                              echo '<div class="mb-3">
                                <label class="form-label">Tratamiento Observaciones</label>
                                <input class="form-control" name="TraObservaciones" type="text" value="' . $fila['TraObservaciones'] . '">
                              </div>';
                              echo '<div class="mb-3">
                                    <label for="TraPaciente" class="form-label">Paciente Tratamiento</label>
                                    <select class="form-control" id="TraPaciente" name="TraPaciente">
                                    <option value="">Seleccionar Paciente</option>';

                                    foreach ($pacientes as $paciente) {
                                        $selected = ($paciente['PacIdentificacion'] == $fila['TraPaciente']) ? 'selected' : '';
                                        echo '<option value="' . $paciente['PacIdentificacion'] . '" ' . $selected . '>'
                                            . $paciente['PacNombres'] . ' ' . $paciente['PacApellidos'] .
                                            '</option>';
                                    }

                            echo '  </select>
                                </div>';
                              echo '<div class="mb-3">
                              <label class="form-label">Estado</label>
                              <select class="form-select" name="TraEstado">
                                  <option value="Activo">Activo</option>
                                  <option value="Inactivo">Inactivo</option>
                              </select>
                            </div>';
                            echo '<button class="btn btn-warning" type="submit" name="Acciones" value="Actualizar Tratamiento">Actualizar Tratamiento</button>';
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
            <div>
            <h3>Agregar Tratamiento</h3>
    <form action="../Controlador/controladorTratamiento.php" method="post">
        <div class="mb-3">
            <label for="TraNumero" class="form-label">Número Tratamiento</label>
            <input class="form-control" id="TraNumero" name="TraNumero" type="text">
        </div>
        <div class="mb-3">
            <label for="TraFechaAsignado" class="form-label">Fecha Asignada</label>
            <input class="form-control" id="TraFechaAsignado" name="TraFechaAsignado" type="date">
        </div>
        <div class="mb-3">
            <label for="TraDescripcion" class="form-label">Descripción del Tratamiento</label>
            <input class="form-control" id="TraDescripcion" name="TraDescripcion" type="text">
        </div>
        <div class="mb-3">
            <label for="TraFechaInicio" class="form-label">Fecha de Inicio</label>
            <input class="form-control" id="TraFechaInicio" name="TraFechaInicio" type="date">
        </div>
        <div class="mb-3">
            <label for="TraFechaFin" class="form-label">Fecha de Fin</label>
            <input class="form-control" id="TraFechaFin" name="TraFechaFin" type="date">
        </div>
        <div class="mb-3">
            <label for="TraObservaciones" class="form-label">Observaciones</label>
            <input class="form-control" id="TraObservaciones" name="TraObservaciones" type="text">
        </div>
        <div class="mb-3">
        <label for="TraPaciente" class="form-label">Paciente</label>
        <select class="form-control" id="TraPaciente" name="TraPaciente">
            <option value="">Seleccionar Paciente</option>
            <?php foreach ($pacientes as $paciente): ?>
                <option value="<?= $paciente['PacIdentificacion']; ?>">
                    <?= $paciente['PacNombres'] . " " . $paciente['PacApellidos']; ?>
                </option>
            <?php endforeach; ?>
        </select>
    </div>


                                



                    <button class="btn btn-success" type="submit" name="Acciones" value="Crear Tratamiento">Crear Tratamiento</button>
                </form>
            </div>
        </div>
        <br><br>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>