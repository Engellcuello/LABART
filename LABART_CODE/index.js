function mostrar(ID_publicacion) {
    console.log(ID_publicacion); // Verifica que se recibe el ID correctamente
    
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "PHP/AJAX/ajax.php", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onload = function() {
        if (xhr.status === 200) {
            console.log(xhr.responseText); // Para ver qué está devolviendo el servidor
            try {
                var publicacion = JSON.parse(xhr.responseText);
                
                if (!publicacion.error) {
                    document.getElementById('miImagen').src = publicacion.imagen;
                    obtenerResolucion(); // Asegúrate de que esta función esté definida
                    document.getElementById('fechaCreacion').textContent = publicacion.fechaCreacion;
                    document.getElementById('tituloPublicacion').textContent = publicacion.titulo;
                    document.getElementById('descripcionPublicacion').textContent = publicacion.descripcion;
                    document.getElementById('userName').textContent = publicacion.usuario;

                    document.getElementById('contenedor_detalles').style.display = 'block';
                    document.getElementById('home').style.overflowY = 'hidden';
                } else {
                    alert(publicacion.error);
                }
            } catch (e) {
                console.error('Error al parsear JSON:', e);
                alert("La respuesta del servidor no es un JSON válido.");
            }
        } else {
            console.error(xhr.responseText); // Para ver más detalles en caso de error
            alert("Error en la solicitud");
        }
    };

    xhr.send("id=" + encodeURIComponent(ID_publicacion));
}





function nomostrar() {
    document.getElementById('contenedor_detalles').style.display = 'none';
    document.getElementById('home').style.overflowY = 'visible';
}

function mostrar_perfil() {
    document.getElementById('contenedor_detalles').style.display = 'block';
    document.getElementById('home').style.overflowY = 'hidden';
}


function mostrar_guardados() {
    document.getElementById('contenedor_detalles_saves').style.display = 'block';
    document.getElementById('home').style.overflowY = 'hidden';
}

function nomostrar_guardados() {
    document.getElementById('contenedor_detalles_saves').style.display = 'none';
    document.getElementById('home').style.overflowY = 'visible';
}

function mostrar_publicar() {
    document.getElementById('contenedor_new_publicacion').style.display = 'block';
    document.getElementById('home').style.overflowY = 'hidden';
}

function nomostrar_publicar() {
    document.getElementById('contenedor_new_publicacion').style.display = 'none';
    document.getElementById('home').style.overflowY = 'visible';
}

function mostrar_mis_publicaciones() {
    document.getElementById('home_mis_publicaciones').style.display = 'flex';
    document.getElementById('home_publicaciones_guardadas').style.display = 'none';

}

function mostrar_mis_saves() {
    document.getElementById('home_mis_publicaciones').style.display = 'none';
    document.getElementById('home_publicaciones_guardadas').style.display = 'flex';
}

function mostrar_publicar_categoria() {
    document.getElementById('fondo_borroso').style.display = 'block';
    document.getElementById('fondo_borroso').style.visibility = 'visible';
    document.getElementById('fondo_borroso').style.opacity = '1';
    setTimeout(function () {
        document.getElementById('seleccionar_categorias_new_publicacion').style.display = 'block';
    }, 1000);
}

function nomostrar_publicar_categoria() {
    document.getElementById('fondo_borroso').style.display = 'none';
    document.getElementById('fondo_borroso').style.visibility = 'hidden';
    document.getElementById('fondo_borroso').style.opacity = '0';
    document.getElementById('seleccionar_categorias_new_publicacion').style.display = 'none';
}


function mostrar_editar_perfil() {
    document.getElementById('contenedor_editar_perfil').style.display = 'block';
}

function nomostrar_editar_perfil() {
    document.getElementById('contenedor_editar_perfil').style.display = 'none';
}

function mostrar_ajustes_lenguaje() {
    document.getElementById('contenedor_ajustes_2').style.display = 'block';
    document.getElementById('contenedor_ajustes_2').style.opacity = '1';
    document.getElementById('contenedor_ajustes_2').style.visibility = 'visible';

    setTimeout(function () {
        document.getElementById('contenedor_ajustes_id_detale').style.opacity = '1';
        document.getElementById('contenedor_ajustes_id_detale').style.visibility = 'visible';
        document.getElementById('contenedor_ajustes_id_detale').style.display = 'block';
    }, 500);
}

function nomostrar_ajustes_lenguaje() {
    document.getElementById('contenedor_ajustes_2').style.display = 'none';
    document.getElementById('contenedor_ajustes_id_detale').style.opacity = '0';
    document.getElementById('contenedor_ajustes_id_detale').style.visibility = 'hidden';
    document.getElementById('contenedor_ajustes_id_detale').style.display = 'none';
    document.getElementById('contenedor_ajustes_2').style.opacity = '1';
    document.getElementById('contenedor_ajustes_2').style.visibility = 'visible';
}


function verificarYOcultar_detalles() {
    const fondoBorroso = document.getElementById('fondo_borroso');
    if (fondoBorroso.style.display === 'block') {
        nomostrar_ajustes_lenguaje();
    } else {
        nomostrar_ajustes_lenguaje();
    }
}



function verificarYOcultar() {
    const fondoBorroso = document.getElementById('fondo_borroso');
    if (fondoBorroso.style.display === 'block') {
        nomostrar_publicar_categoria();
    } else {
        nomostrar_publicar();
    }
}

function verificarYOcultar_editar() {
    const fondoBorroso = document.getElementById('fondo_borroso');
    if (fondoBorroso.style.display === 'block') {
        nomostrar_editar_perfil();
    } else {
        nomostrar_editar_perfil();
    }
}


function nomostrar_ajustes() {
    document.getElementById('contenedor_ajustes').style.display = 'none';
    document.getElementById('home').style.overflowY = 'visible';

}

function mostrar_ajustes() {
    document.getElementById('contenedor_ajustes').style.display = 'block';
    document.getElementById('home').style.overflowY = 'hidden';

}





//codigo subir archivo
document.addEventListener('DOMContentLoaded', () => {
    let uploadButton = document.getElementById("input_subir_archivo");
    let chosenImage = document.getElementById("img_subir_archivo");
    let closeIcon = document.getElementById("close_img_archivo");
    let infoInputArchivo = document.getElementById("info_input_archivo");
    let centroInputArchivo = document.getElementById("centro_input_archivo");
    let contenedor_subir_publicacion = document.getElementById("contenedor_subir_publicacion");

    uploadButton.onchange = () => {
        let file = uploadButton.files[0];
        if (file) {
            let reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = () => {
                chosenImage.setAttribute("src", reader.result);
                chosenImage.style.display = "block";
                closeIcon.style.display = "flex";
                infoInputArchivo.style.display = "none";
                centroInputArchivo.style.display = "none";
                uploadButton.style.display = "none";
                contenedor_subir_publicacion.style.marginTop = "25px";
            }
        }
    }

    closeIcon.onclick = () => {
        chosenImage.style.display = "none";
        closeIcon.style.display = "none";
        infoInputArchivo.style.display = "block";
        centroInputArchivo.style.display = "flex";
        uploadButton.value = "";
        uploadButton.style.display = "block";
        contenedor_subir_publicacion.style.marginTop = "50%";
    }
});

var imagen = document.getElementById('miImagen');
var resolucion = document.getElementById('resolucionImagen');

// Función para obtener la resolución de la imagen
function obtenerResolucion() {
    var imagen = document.getElementById('miImagen');
    var resolucion = document.getElementById('resolucionImagen');
    var ancho = this.naturalWidth; // Ancho de la imagen
    var alto = this.naturalHeight; // Alto de la imagen
    resolucion.textContent = ancho + 'px ' + alto + 'px'; // Actualiza el contenido del span
    imagen.addEventListener('load', obtenerResolucion);
}

// Llama a la función para obtener la resolución cuando la imagen se haya cargado completamente
imagen.addEventListener('load', obtenerResolucion);


// coidgo para boton reaccion tarjeta publicacion NO FUNCIONOOOOOOOO
document.addEventListener('DOMContentLoaded', () => {
    const boton = document.getElementById('boton_publicacion_reaccion');
    const tooltip = document.getElementById('tooltip');
    console.log(boton); // Verifica si se selecciona correctamente el botón
    console.log(tooltip); // Verifica si se selecciona correctamente el tooltip
    let hoverTimeout;

    boton.addEventListener('mouseenter', () => {
        console.log('Mouse entered'); // Verifica si el evento mouseenter se está disparando correctamente
        hoverTimeout = setTimeout(() => {
            console.log('2 seconds passed'); // Verifica si el temporizador de 2 segundos está funcionando correctamente
            tooltip.classList.add('show');
        }, 2000); // Espera 2 segundos
    });

    boton.addEventListener('mouseleave', () => {
        console.log('Mouse left'); // Verifica si el evento mouseleave se está disparando correctamente
        clearTimeout(hoverTimeout);
        tooltip.classList.remove('show');
    });
});




class CustomSelect {
    constructor(originalSelect) {
        this.originalSelect = originalSelect;
        this.customSelect = document.createElement("div");
        this.customSelect.classList.add("select");

        this.originalSelect.querySelectorAll("option").forEach((optionElement) => {
            const itemElement = document.createElement("div");

            itemElement.classList.add("select__item");
            itemElement.textContent = optionElement.textContent;
            this.customSelect.appendChild(itemElement);

            if (optionElement.selected) {
                this._select(itemElement);
            }

            itemElement.addEventListener("click", () => {
                if (
                    this.originalSelect.multiple &&
                    itemElement.classList.contains("select__item--selected")
                ) {
                    this._deselect(itemElement);
                } else {
                    this._select(itemElement);
                }
            });
        });

        this.originalSelect.insertAdjacentElement("afterend", this.customSelect);
        this.originalSelect.style.display = "none";
    }

    _select(itemElement) {
        const index = Array.from(this.customSelect.children).indexOf(itemElement);

        if (!this.originalSelect.multiple) {
            this.customSelect.querySelectorAll(".select__item").forEach((el) => {
                el.classList.remove("select__item--selected");
            });
        }

        this.originalSelect.querySelectorAll("option")[index].selected = true;
        itemElement.classList.add("select__item--selected");
    }

    _deselect(itemElement) {
        const index = Array.from(this.customSelect.children).indexOf(itemElement);

        this.originalSelect.querySelectorAll("option")[index].selected = false;
        itemElement.classList.remove("select__item--selected");
    }
}

document.querySelectorAll(".custom-select").forEach((selectElement) => {
    new CustomSelect(selectElement);
});



const defaultFile = 'https://stonegatesl.com/wp-content/uploads/2021/01/avatar-300x300.jpg';

const file = document.getElementById('foto');
const img = document.getElementById('img');
file.addEventListener('change', e => {
    if (e.target.files[0]) {
        const reader = new FileReader();
        reader.onload = function (e) {
            img.src = e.target.result;
        }
        reader.readAsDataURL(e.target.files[0])
    } else {
        img.src = defaultFile;
    }
});


function abrir_guardados() {
    // Guardar estado en sessionStorage
    sessionStorage.setItem('mostrarGuardados', 'true');

    // Redirigir a la nueva página
    window.location.href = '/labart/seccions/perfil/perfil.html';
}




function googleTranslateElementInit() {
    new google.translate.TranslateElement({
        pageLanguage: 'es', // Cambia según el idioma por defecto de tu página
        includedLanguages: 'es,en', // Idiomas que quieres incluir
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE
    }, 'google_translate_element');
}

function cambiarIdioma(idioma) {
    const select = document.querySelector('.skiptranslate select'); // Seleccionamos el menú de idiomas

    if (select) {
        select.value = idioma; // Cambiamos el valor del select
        select.dispatchEvent(new Event('change')); // Disparamos el evento de cambio
    }
}

