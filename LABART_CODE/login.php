
<?php
require_once '../PHP/Controlador/controladorUsuario.php';
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LABART</title>
    <link rel="stylesheet" href="login.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://kit.fontawesome.com/7a51261991.js" crossorigin="anonymous"></script>
    <link rel="icon" href="../img/solo_logo.png" type="image/x-icon">
</head>

    <style>
        body {
            background-image: url(../img/login/image.png);
            background-repeat: no-repeat;
            background-size: cover;
            height: 100%;
            overflow: hidden;
        }
    </style>

    <script>

            const fechaActual = new Date(); // Obtener la fecha actual
            const fechaFormateada = fechaActual.toISOString().slice(0, 10); // Formatear a 'YYYY-MM-DD'
            document.getElementById('fecha_actual').value = fechaFormateada; // Asignar al campo oculto


    </script>

<body>

    <div class="formulario_register col-md-3 col-lg-6" id="div1">

        <div class="seccion1 seccion_1">
            <div class="logo">
                <img src="../img/concepto_logo.png" alt="">
            </div>
            <div class="indicador col-md-6 col-lg-8 mx-auto ">
                <button class=""></button>

                <button class=" active" id="ind_register"></button>

                <button class="" id="" onclick="mostrar()"></button>
            </div>
            <div class="texto_indicador">
                <h1 class="Texto_indicador">Crea una Cuenta</h1>
            </div>
        </div>

        <div class="formulario col-md-16">
            <form action="../PHP/Controlador/controladorUsuario.php" method="post">

                <div class="upload">
                    <img src="/img/login/6522581.png" width=100 height=100 alt="">
                    <div class="round">
                        <input type="file" id="Img_usuario" name="Img_usuario" value="none">
                        <i class="fa fa-camera" style="color: #ffff;"></i>
                    </div>
                </div>

                <div class="input-container">
                    <input type="text" id="Nombre_usuario" name="Nombre_usuario" class="input-field" placeholder="" pattern="{A-Za-z0-9}" required>
                    <label for="inputField" class="input-label">
                        <i class="fa-solid fa-user" style="color: #ffff;"></i>
                        Nombre de Usuario
                    </label>
                </div>

                <div class="input-container">
                    <input type="email" id="Correo_usuario" name="Correo_usuario" class="input-field" placeholder="" required>
                    <label for="inputField " class="input-label">
                        <i class="fa-solid fa-envelope " style="color: #ffff;"></i>
                        Correo Electronico
                    </label>
                </div>

                <div class="input-container">
                    <input type="password" id="Contraseña" name="Contraseña" class="input-field" placeholder="" required>
                    <label for="inputField " class="input-label label-special">
                        <i class="fa-solid fa-lock" style="color: #ffff;"></i>
                        Contraseña
                    </label>
                </div>
                <div class="input-container generos">
                    <input type="radio" id="ID_sexo1" name="ID_sexo" value="1" class="genero1" required>
                    <label for="ID_sexo1" class="genero">Hombre</label>
                    
                    <input type="radio" id="ID_sexo2" name="ID_sexo" value="2" class="genero2">
                    <label for="ID_sexo2" class="genero">Mujer</label>
                    
                    <input type="radio" id="ID_sexo3" name="ID_sexo" value="3" class="genero3">
                    <label for="ID_sexo3" class="genero">Otro</label>
                </div>


                <input type="hidden" name="ID_rol" value="1">
                <input type="hidden" name="Cont_Explicit" value="0">
                <input type="hidden" name="Notificaciones" value="0">

                <div class="terminos">
                    <label for="terminos-condiciones">
                        <input type="checkbox" id="terminos-condiciones" name="terminos-condiciones">
                        Aceptar términos y condiciones
                    </label>
                </div>
                <div class="enviar col-sm-8 col-md-12">
                    <button class="icon_buscar" type="submit" name="Acciones" value="Crear Usuario">
                        <p class="t_boton_login">Continuar <i class="fa-solid fa-arrow-right flecha"></i></p>
                        
                    </button>
                </div>
                <div class=" texto_terminos_condiciones">
                                Tienes que llenar todos los campos para seguir al siguiente paso
                </div>
            </form>
        </div>
        <div class="seccion2 text-center mt-3">
            <button class="boton_indicador ubicacion input-container" id="toggleButton " onclick="mostrar()">
                Inicia Sesion
            </button>
            <div class="ayuda text-center mt-2">
                <p class="correro_ayuda">
                    <i class="fa-solid fa-envelope " style="color: #ffff;"></i>
                    Ayudalabart@gmail.com

                </p>
            </div>
        </div>
    </div>


    <div class="formulario_register formulario_login col-md-4 col-lg-6" id="div2">

        <div class="seccion1 seccion_posicion">
            <div class="logo">
                <img src="../img/concepto_logo.png" alt="">
            </div>
            <div class="indicador col-md-6 col-lg-8">
                <button class="indicador_etc"></button>

                <button class="" id="" onclick="nomostrar()"></button>

                <button class="" id="ind_login"></button>
            </div>
            <div class="texto_indicador">
                <h1 class="Texto_indicador texto_login">Iniciar Sesion</h1>
            </div>
        </div>

        <div class="formulario formulario_posicion col-md-14 col-lg-18">
       
        <form action="../PHP/Controlador/controladorUsuario.php" method="post">

                <div class="input-container input_login mt-3" id="input_login input_user_login login_input">
                    <input type="text" name="Nombre_usuario" id="Nombre_usuario" class="input-field w-250" placeholder="" required>
                    <label for="inputField" class="input-label input_special_login">
                        <i class="fa-solid fa-user" style="color: #ffff;"></i>
                        Usuario
                    </label>
                </div>

                <div class="input-container input_login mt-4" id="input_login">
                    <input type="password"  name="Contraseña" id="Contraseña" class="input-field " placeholder="" required>
                    <label for="inputField " class="input-label label-special">
                        <i class="fa-solid fa-lock" style="color: #ffff;"></i>
                        Contraseña
                    </label>
                </div>
                <div class="enviar enviar_login mb-3">
                    <button class="icon_buscar" type="submit" id="boton_login" name="Acciones" value="Consultar credenciales">
                        <p class="t_boton_login">Iniciar Sesión</p>
                    </button>
                </div>
                <div class="texto_terminos_condiciones" id="texto_login_register">
                    ¿Aun no tienes una cuenta? <br>
                    registrate ahora
                </div>
            </form>
        </div>

        <div class="seccion2 text-center mt-3">
            <button class="boton_indicador" id="toggleButton" onclick="nomostrar()">
                Registrate
            </button>
            <div class="ayuda text-center mt-2" id="correo_login">
                <p class="correro_ayuda">
                    <i class="fa-solid fa-envelope " style="color: #ffff;"></i>
                    Ayudalabart@gmail.com

                </p>
            </div>
        </div>
    </div>

    <div class="slider">
        <div class="list">
            <div class="item">
                <img class="imagen_login"
                    src="../img/login/Default_The_starry_night_painting_of_Vincent_van_Gogh_combined_2 (1).jpg" alt="">
            </div>
            <div class="item">
                <img class="imagen_login"
                    src="../img/login/alchemyrefiner_alchemymagic_3_44c6c9e8-02f0-443a-a5d3-8b30797795fd_0.jpg" alt="">
            </div>
            <div class="item">
                <img class="imagen_login" src="../img/login/Default_2.jpg" alt="">
            </div>
            <div class="item">
                <img class="imagen_login"
                    src="../img/login/Default_Blond_Android_red_1_2d80a0e1-6bc7-400c-a122-5b7eba29ecab_0.jpg" alt="">
            </div>
            <div class="item">
                <img class="imagen_login"
                    src="../img/login/Default_Old_Male_Painter_drawing_an_old_women_2_87ad1412-6c0f-4adf-a8bc-428300841c01_0.jpg"
                    alt="">
            </div>
            <div class="item">
                <img class="imagen_login"
                    src="../img/login/Default_Make_a_Girl_with_ginger_coloured_hair_with_a_black_t_s_0.jpg" alt="">
            </div>
            <div class="item">
                <img class="imagen_login"
                    src="../img/login/Default_pinturas_estilo_van_gogh_anoitecer_0_fe4c1539-cf89-4f57-9464-16b5c40eb865_0.jpg"
                    alt="">
            </div>
        </div>

        <div class="buttons">
            <button id="prev">
            </button>
            <button id="next">></button>
        </div>
        <ul class="dots">
            <li class="active"></li>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
        </ul>

    </div>


    
    <script src="js/image_slyder.js"></script>
</body>

</html>