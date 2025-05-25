var scale = 1,
    panning = false,
    pointX = 0,
    pointY = 0,
    start = { x: 0, y: 0 },
    zoom = document.getElementById("canvas"),
    container = document.getElementById("canvas-container");

function setTransform() {
    zoom.style.transform = "translate(" + pointX + "px, " + pointY + "px) scale(" + scale + ")";
}

// Detecta cuando se presiona el botón del medio del mouse
zoom.onmousedown = function (e) {
    e.preventDefault();
    if (e.button === 2) { // Botón del medio del mouse
        start = { x: e.clientX - pointX, y: e.clientY - pointY };
        panning = true;
    }
}

// Detecta cuando se suelta cualquier botón del mouse
zoom.onmouseup = function (e) {
    if (e.button === 2) { // Solo desactivar panning si el botón del medio se suelta
        panning = false;
    }
}

// Movimiento del mouse solo cuando el botón del medio está presionado
zoom.onmousemove = function (e) {
    e.preventDefault();
    if (!panning) return;
    pointX = (e.clientX - start.x);
    pointY = (e.clientY - start.y);
    setTransform();
}

// Zoom y desplazamiento con la rueda del mouse
zoom.onwheel = function (e) {
    e.preventDefault();
    var rect = zoom.getBoundingClientRect();
    var mouseX = e.clientX - rect.left;
    var mouseY = e.clientY - rect.top;

    // Ajusta la tasa de zoom según la escala actual de manera gradual
    var zoomFactor = e.deltaY > 0 ? 1.05 : 1 / 1.05; // Usa un zoom factor más suave
    var newScale = scale * zoomFactor;

    // Limita los valores de escala para evitar el zoom excesivo
    if (newScale < 0.4) newScale = 0.4;
    if (newScale > 4) newScale = 4;

    if (e.shiftKey) {
        // Desplazamiento vertical con Shift
        pointY += e.deltaY;
    } else if (e.altKey) {
        // Desplazamiento horizontal con Alt
        pointX += e.deltaY;
    } else {
        // Ajusta la posición para mantener el punto del mouse en la misma posición relativa
        var scaleDifference = newScale / scale;

        // Suaviza el ajuste de la posición
        pointX -= (mouseX - pointX) * (scaleDifference - 1);
        pointY -= (mouseY - pointY) * (scaleDifference - 1);

        // Aplicar la nueva escala
        scale = newScale;
    }

    setTransform();
}

// Asocia los eventos con el canvas y el contenedor
canvas.onmousedown = onMouseDown;
canvas.onmouseup = onMouseUp;
canvas.onmousemove = onMouseMove;
canvas.onwheel = onWheel;

container.onmousedown = onMouseDown;
container.onmouseup = onMouseUp;
container.onmousemove = onMouseMove;
container.onwheel = onWheel;
