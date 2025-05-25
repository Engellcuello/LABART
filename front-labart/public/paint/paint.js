// CONSTANTS
const MODES = {
    DRAW: 'draw',
    ERASE: 'erase',
    RECTANGLE: 'rectangle',
    ELLIPSE: 'ellipse',
    PICKER: 'picker',
    FILL: 'fill'
};





// UTILITIES
const $ = selector => document.querySelector(selector);
const $$ = selector => document.querySelectorAll(selector);

// ELEMENTS
const $canvas = $('#canvas');
const $colorPicker = $('#color-picker');
const $clearBtn = $('#clear-btn');
const $drawBtn = $('#draw-btn');
const $eraseBtn = $('#erase-btn');
const $rectangleBtn = $('#rectangle-btn');
const $pickerBtn = $('#picker-btn');
const $fillBtn = $('#rellenar-btn');
const $undoBtn = $('#undo-btn');
const $redoBtn = $('#redo-btn');
const color_boton_history = document.getElementById('color_chse');


// Crear elemento para el cursor personalizado
const $customCursor = document.createElement('div');
$customCursor.style.position = 'absolute';
$customCursor.style.border = '1px solid black'; // Borde del cursor
$customCursor.style.borderRadius = '50%'; // Forma circular
$customCursor.style.backgroundColor = 'transparent'; // Fondo transparente
$customCursor.style.pointerEvents = 'none'; // No interferir con eventos del mouse
document.body.appendChild($customCursor);

const ctx = $canvas.getContext('2d');
$canvas.width = $canvas.clientWidth;
$canvas.height = $canvas.clientHeight;

// STATE
let isDrawing = false;
let isShiftPressed = false;
let startX, startY;
let lastX = 0;
let lastY = 0;
let mode = MODES.DRAW;
let brushSize = 2; // Tamaño del pincel predeterminado
let imageData

// Undo/Redo State
let undoStack = [];
let redoStack = [];

// EVENTS
$canvas.addEventListener('mousedown', startDrawing);
$canvas.addEventListener('mousemove', draw);
$canvas.addEventListener('mouseup', stopDrawing);
$canvas.addEventListener('mouseleave', stopDrawing);

$colorPicker.addEventListener('change', handleChangeColor);
$clearBtn.addEventListener('click', clearCanvas);

document.addEventListener('keydown', handleKeyDown);
document.addEventListener('keyup', handleKeyUp);

$pickerBtn.addEventListener('click', () => setMode(MODES.PICKER));
$eraseBtn.addEventListener('click', () => setMode(MODES.ERASE));
$rectangleBtn.addEventListener('click', () => setMode(MODES.RECTANGLE));
$drawBtn.addEventListener('click', () => setMode(MODES.DRAW));
$fillBtn.addEventListener('click', () => setMode(MODES.FILL));

// Undo and Redo buttons
$undoBtn.addEventListener('click', undo);
$redoBtn.addEventListener('click', redo);



// Guardar estado actual y limpiar redo stack
function saveState() {
    undoStack.push(ctx.getImageData(0, 0, $canvas.width, $canvas.height));
    redoStack = []; // Limpiar redo stack después de una nueva acción
}

// Deshacer la última acción
function undo() {
    if (undoStack.length > 0) {
        redoStack.push(ctx.getImageData(0, 0, $canvas.width, $canvas.height)); // Guardar estado actual en redo stack
        const lastState = undoStack.pop();
        ctx.putImageData(lastState, 0, 0);
    }
}

// Rehacer la última acción
function redo() {
    if (redoStack.length > 0) {
        undoStack.push(ctx.getImageData(0, 0, $canvas.width, $canvas.height)); // Guardar estado actual en undo stack
        const lastState = redoStack.pop();
        ctx.putImageData(lastState, 0, 0);
    }
}

function setBrushSize(size) {
    brushSize = size;
    ctx.lineWidth = size;
    updateCursor(); // Actualizar tamaño del cursor
}

function startDrawing(event) {
    if (event.button !== 0) return;
    
    isDrawing = true;
    const { offsetX, offsetY } = event;
    [startX, startY] = [offsetX, offsetY];
    [lastX, lastY] = [offsetX, offsetY];
    imageData = ctx.getImageData(0, 0, $canvas.width, $canvas.height);

    saveState(); 
} 

function draw(event) {
    if (!isDrawing || event.buttons !== 1) return;

    const { offsetX, offsetY } = event;

    if (mode === MODES.DRAW || mode === MODES.ERASE) {
        ctx.globalCompositeOperation = mode === MODES.ERASE ? 'destination-out' : 'source-over';
        const distance = Math.hypot(offsetX - lastX, offsetY - lastY);
        const angle = Math.atan2(offsetY - lastY, offsetX - lastX);

        for (let i = 0; i < distance; i += brushSize / 10) {
            const x = lastX + Math.cos(angle) * i;
            const y = lastY + Math.sin(angle) * i;
            ctx.beginPath();
            ctx.arc(x, y, brushSize / 2, 0, Math.PI * 2);
            ctx.fill();
        }
        [lastX, lastY] = [offsetX, offsetY];
        return;
    }

    if (mode === MODES.RECTANGLE) {
        ctx.putImageData(imageData, 0, 0);
        

        let width = offsetX - startX;
        let height = offsetY - startY;

        if (isShiftPressed) {
            const sideLength = Math.min(Math.abs(width), Math.abs(height));
            width = width > 0 ? sideLength : -sideLength;
            height = height > 0 ? sideLength : -sideLength;
        }

        

        ctx.strokeStyle = ctx.strokeStyle; // Establece un color de trazo predeterminado si no se ha configurado
        ctx.lineWidth = brushSize; // Asegúrate de que el tamaño del trazo sea el correcto
        ctx.strokeRect(startX, startY, width, height); // Dibuja el rectángulo con el trazo
        return;
    }

    if (mode === MODES.FILL) {
        const x = Math.floor(offsetX);
        const y = Math.floor(offsetY);
        fillExpanded(x, y, ctx.fillStyle);
        return;
    }
}

// Algoritmo flood fill simple
function fillExpanded(x, y, color) {
    const offset = brushSize; // Usar el tamaño del pincel como expansión
    const imageData = ctx.getImageData(0, 0, $canvas.width, $canvas.height);
    const data = imageData.data;
    const startColor = getColorAt(x, y, data);
    const fillColor = hexToRgb(color);

    // Verificar si el color de fondo es el mismo que el color de relleno
    if (arraysEqual(startColor, fillColor)) return;

    // Crear una cola para el algoritmo flood fill
    const queue = [[x, y]];
    const visited = new Set();
    const key = (x, y) => `${x},${y}`;

    // Rellenar el área detectada
    while (queue.length > 0) {
        const [cx, cy] = queue.shift();
        const currentKey = key(cx, cy);

        if (cx < 0 || cx >= $canvas.width || cy < 0 || cy >= $canvas.height || visited.has(currentKey)) continue;

        if (arraysEqual(getColorAt(cx, cy, data), startColor)) {
            // Rellenar el píxel actual
            setColorAt(cx, cy, fillColor, data);
            visited.add(currentKey);

            // Agregar los píxeles vecinos a la cola
            queue.push([cx + 1, cy]);
            queue.push([cx - 1, cy]);
            queue.push([cx, cy + 1]);
            queue.push([cx, cy - 1]);
        }
    }

    // Aplicar cambios en el canvas
    ctx.putImageData(imageData, 0, 0);

    // Rellenar el área expandida alrededor del área de relleno
    ctx.fillStyle = color; // Asegúrate de que el color de relleno esté establecido correctamente

}

// Obtiene el color de un píxel en una posición específica
function getColorAt(x, y, data) {
    const index = (y * $canvas.width + x) * 4;
    return [data[index], data[index + 1], data[index + 2], data[index + 3]];
}

// Establece el color de un píxel en una posición específica
function setColorAt(x, y, color, data) {
    const index = (y * $canvas.width + x) * 4;
    data[index] = color[0];
    data[index + 1] = color[1];
    data[index + 2] = color[2];
    data[index + 3] = color[3];
}

// Función para convertir un color hexadecimal a RGB
function hexToRgb(hex) {
    const r = parseInt(hex.slice(1, 3), 16);
    const g = parseInt(hex.slice(3, 5), 16);
    const b = parseInt(hex.slice(5, 7), 16);
    return [r, g, b, 255]; // Alpha se establece en 255 (completamente opaco)
}

// Verifica si dos arrays son iguales
function arraysEqual(a, b) {
    if (a.length !== b.length) return false;
    for (let i = 0; i < a.length; i++) {
        if (a[i] !== b[i]) return false;
    }
    return true;
}

function stopDrawing() {
    isDrawing = false;
    ctx.beginPath();
}

function handleChangeColor(event) {
    ctx.strokeStyle = event.target.value;
    ctx.fillStyle = event.target.value; // Asegurar que el color de relleno también cambie
    $customCursor.style.borderColor = event.target.value; // Cambiar el color del borde del cursor personalizado
}

function handleKeyDown(event) {
    if (event.key === 'Shift') {
        isShiftPressed = true;
    }
}

function handleKeyUp(event) {
    if (event.key === 'Shift') {
        isShiftPressed = false;
    }
}

function clearCanvas() {
    saveState();
    ctx.clearRect(0, 0, $canvas.width, $canvas.height);
}

async function setMode(newMode) {
    let previousMode = mode;
    mode = newMode;
    $('div.active')?.classList.remove('active');

    if (mode === MODES.DRAW) {
        $drawBtn.classList.add('active');
        $canvas.style.cursor = 'pointer';
        ctx.globalCompositeOperation = 'source-over';
        ctx.lineWidth = brushSize;
        updateCursor();
        return;
    }

    if (mode === MODES.RECTANGLE) {
        $rectangleBtn.classList.add('active');
        $canvas.style.cursor = 'nw-resize';
        ctx.globalCompositeOperation = 'source-over';
        ctx.lineWidth = brushSize;
        $customCursor.style.display = 'none';
        return;
    }

    if (mode === MODES.ERASE) {
        $eraseBtn.classList.add('active');
        $canvas.style.cursor = 'none';
        ctx.globalCompositeOperation = 'destination-out';
        ctx.lineWidth = brushSize;
        updateCursor();
        return;
    }


    if (mode === MODES.PICKER) {
        $pickerBtn.classList.add('active');
        const eyeDropper = new window.EyeDropper();
        try {
            const result = await eyeDropper.open();
            const { sRGBHex } = result;
            ctx.strokeStyle = sRGBHex;
            ctx.fillStyle = sRGBHex;
            $colorPicker.value = sRGBHex;
            setMode(previousMode);
        } catch (e) {
            // Si hubo un error o el usuario no seleccionó ningún color
        }
        return;
    }
}

// Manejador de eventos para el cambio de tamaño del pincel
document.querySelectorAll('.brush-size').forEach(button => {
    button.addEventListener('click', () => {
        const size = parseInt(button.dataset.size);
        setBrushSize(size);
    });
});

// Actualizar el tamaño del cursor según el tamaño del pincel
function updateCursor() {
    $customCursor.style.width = `${brushSize}px`;
    $customCursor.style.height = `${brushSize}px`;
}

// Inicializar tamaño del cursor personalizado
updateCursor();


function saveCanvasAsImage() {
    const dataUrl = $canvas.toDataURL('image/png'); // Obtén el contenido del canvas en formato base64 (PNG)
    
    const link = document.createElement('a'); // Crear un enlace temporal
    link.href = dataUrl; // Establecer el href del enlace con la URL base64
    link.download = 'canvas_image.png'; // Nombre del archivo de descarga
    link.click(); // Simular un clic en el enlace para descargar la imagen
}

// Asignar el evento al botón de guardar
const $saveBtn = $('#save-btn'); // Asume que tienes un botón con id "save-btn"
$saveBtn.addEventListener('click', saveCanvasAsImage);

// Seguir el cursor
$canvas.addEventListener('mousemove', (event) => {
    $customCursor.style.left = `${event.pageX - brushSize / 2}px`;
    $customCursor.style.top = `${event.pageY - brushSize / 2}px`;
});

$canvas.addEventListener('mouseenter', () => {
    $customCursor.style.display = 'block';
});

$canvas.addEventListener('mouseleave', () => {
    $customCursor.style.display = 'none';
});



document.addEventListener('DOMContentLoaded', function () {
    const loadImageBtn = document.getElementById('load-image-btn');
    const imageInput = document.getElementById('image-input');
    const removeImageBtn = document.getElementById('remove-image-btn');

    loadImageBtn.addEventListener('click', () => {
        imageInput.click(); // dispara el input oculto
    });

    imageInput.addEventListener('change', (event) => {
        const file = event.target.files[0];
        if (file) {
            const img = new Image();
            img.onload = () => {
                const canvas = document.getElementById('canvas');
                const ctx = canvas.getContext('2d');
                
                // Obtener dimensiones del canvas
                const canvasWidth = canvas.width;
                const canvasHeight = canvas.height;
                
                // Ajustar las dimensiones de la imagen al tamaño del canvas
                const imgWidth = img.width;
                const imgHeight = img.height;

                // Redimensionar la imagen si es más grande que el canvas
                const scaleWidth = canvasWidth / imgWidth;
                const scaleHeight = canvasHeight / imgHeight;
                const scale = Math.min(scaleWidth, scaleHeight);

                // Calcular el tamaño de la imagen redimensionada
                const newWidth = imgWidth * scale;
                const newHeight = imgHeight * scale;

                // Centrar la imagen en el canvas
                const offsetX = (canvasWidth - newWidth) / 2;
                const offsetY = (canvasHeight - newHeight) / 2;

                // Redibujar la imagen en el canvas con las nuevas dimensiones
                ctx.clearRect(0, 0, canvas.width, canvas.height); // Limpiar el canvas
                ctx.drawImage(img, offsetX, offsetY, newWidth, newHeight);
            };
            img.src = URL.createObjectURL(file);
        }
    });

    removeImageBtn.addEventListener('click', () => {
        const canvas = document.getElementById('canvas');
        const ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, canvas.width, canvas.height);
    });

    // Mostrar Picker si el navegador tiene soporte
    if (typeof window.EyeDropper !== 'undefined') {
        const pickerBtn = document.getElementById('picker-btn'); // ← asegúrate de que exista este ID
        if (pickerBtn) {
            pickerBtn.removeAttribute('disabled');
        }
    }
});







// Inicio script para que el boton de seleccionar tamaño sirva dezlizando

const numberDisplay = document.getElementById('numbercontainer');
let isDragging_input = false;
let startX_input;
let startValue = 1;

document.addEventListener('mouseup', () => {
    if (isDragging_input) {
        isDragging_input = false;
        const finalValue = parseInt(numberDisplay.textContent, 10);
        setBrushSize(finalValue); // Llama a la función con el valor final
    }
});

function updateNumber(value) {
    // Limita el valor entre 1 y 150
    value = Math.max(1, Math.min(150, Math.round(value)));
    numberDisplay.textContent = value;
    numberDisplay.style.opacity = '0.9'; // Efecto de desvanecimiento
    setTimeout(() => numberDisplay.style.opacity = '1', 50); // Restaurar opacidad después del efecto
}
numberDisplay.addEventListener('mousedown', (e) => {
    isDragging_input = true;
    startX_input = e.clientX;
    startValue = parseFloat(numberDisplay.textContent) || 1; // Asegura que el valor inicial sea 1
});

document.addEventListener('mousemove', (e) => {
    if (!isDragging_input) return;
    const dx = e.clientX - startX_input;
    const step = 1; // Ajusta la sensibilidad de la actualización
    const newValue = startValue + dx / 10; // Cambia 10 a otro valor para ajustar la sensibilidad
    updateNumber(newValue);
});

// fin code  dezplazar tamaño



//inicio ultimos 10 colores
const colorPicker = document.getElementById('color-picker');
const colorHistory = document.getElementById('color-history');
const MAX_COLORS = 10;

// Inicializar el historial de colores con cuadros blancos
function initializeColorHistory() {
    for (let i = 0; i < MAX_COLORS; i++) {
        addColorToHistory('#ffffff');
    }
}

// Cargar el historial de colores desde localStorage
function loadColorHistory() {
    const colors = JSON.parse(localStorage.getItem('colorHistory')) || [];
    colorHistory.innerHTML = ''; // Limpiar el contenedor antes de añadir
    colors.forEach(color => addColorToHistory(color));
}

// Guardar el historial de colores en localStorage
function saveColorHistory(colors) {
    localStorage.setItem('colorHistory', JSON.stringify(colors));
}

// Agregar un color al historial
function addColorToHistory(color) {
    const colorBox = document.createElement('div');
    colorBox.className = 'color-box';
    colorBox.style.backgroundColor = color;
    colorBox.addEventListener('click', () => {
        colorPicker.value = color;
        ctx.strokeStyle = color;
        ctx.fillStyle = color;
        color_boton_history.style.backgroundColor = color;
    });
    colorHistory.appendChild(colorBox);
}

// Actualizar el historial con un nuevo color
function updateColorHistory(newColor) {
    let colors = JSON.parse(localStorage.getItem('colorHistory')) || [];


    // Verificar si el color ya está en el historial
    if (colors.includes(newColor)) {
        // Actualizar el color del picker si ya está en el historial
        colorPicker.value = newColor;
        return;
    }
    color_boton_history.style.backgroundColor = newColor;

    // Insertar el nuevo color al principio y mover los colores existentes hacia abajo
    colors = [newColor, ...colors];
    // Limitar a los últimos MAX_COLORS colores
    if (colors.length > MAX_COLORS) {
        colors = colors.slice(0, MAX_COLORS);
    }
    saveColorHistory(colors);
    // Actualizar la visualización
    colorHistory.innerHTML = '';
    colors.forEach(color => addColorToHistory(color));
}

// Manejar la selección de color
colorPicker.addEventListener('change', (e) => {
    const newColor = e.target.value;
    updateColorHistory(newColor);
    
});

// Inicializar el historial al iniciar
initializeColorHistory();
loadColorHistory();


