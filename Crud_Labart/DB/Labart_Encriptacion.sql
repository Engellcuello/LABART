-- Crear Base de datos
CREATE DATABASE labart;

USE labart;

-- Clave de cifrado
SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';

-- Crear tabla PQRS
CREATE TABLE PQRS (
    ID_pqrs INT(10) PRIMARY KEY,
    Fecha_pqrs DATE,
    Contenido_pqrs VARBINARY(255),
    ID_estado INT(10),
    ID_usuario INT(10)
);

-- Crear tabla Estado
CREATE TABLE Estado (
    ID_estado INT(10) PRIMARY KEY,
    Nombre_estado VARBINARY(255),
    Descripcion_estado VARBINARY(255)
);

-- Crear tabla Asistente
CREATE TABLE Asistente (
    ID_asistente INT(10) PRIMARY KEY,
    Fecha_peticion DATE,
    Detalle_asistente VARBINARY(100),
    ID_estado INT(10),
    ID_usuario INT(10)
);

-- Crear tabla Usuario
CREATE TABLE Usuario (
    ID_usuario INT(10) PRIMARY KEY,
    Nombre_usuario VARCHAR(20),
    Contraseña VARBINARY(256), -- Encriptado
    Correo_usuario VARBINARY(256), -- Encriptado
    Fecha_usuario DATE,
    Notificaciones BOOLEAN DEFAULT FALSE,
    ID_sexo INT(10),
    Img_usuario MEDIUMBLOB,
    ID_rol INT(10),
    Cont_Explicit BOOLEAN DEFAULT FALSE
);

-- Crear tabla Rol
CREATE TABLE Rol (
    ID_rol INT(10) PRIMARY KEY,
    Nombre_rol VARBINARY(255),
    Descripcion_rol VARBINARY(255),
    ID_estado INT(10)
);

-- Crear tabla Sexo
CREATE TABLE Sexo (
    ID_sexo INT(10) PRIMARY KEY,
    Descripcion_sexo VARCHAR(20),
    Nombre_sexo VARCHAR(12)
);

-- Crear tabla Comentario
CREATE TABLE Comentario (
    ID_comentario INT(10) PRIMARY KEY,
    Contenido_comentario VARBINARY(255),
    Fecha_comentario DATE,
    ID_usuario INT(10),
    ID_publicacion INT(10)
);

-- Crear tabla Publicacion
CREATE TABLE Publicacion (
    ID_publicacion INT(10) PRIMARY KEY,
    Fecha_publicacion DATE,
    Descripcion_publicacion VARCHAR(255),
    Img_publicacion VARCHAR(100),
    Cont_Explicit_publi BOOLEAN DEFAULT FALSE,
    ID_usuario INT(10)
);

-- Crear tabla Categoria
CREATE TABLE Categoria (
    ID_categoria INT(10) PRIMARY KEY,
    Nombre_categoria VARCHAR(20),
    Descripcion_categoria VARCHAR(50)
);

-- Crear tabla Reaccion
CREATE TABLE Reaccion (
    ID_reaccion INT(10) PRIMARY KEY,
    Nombre_reaccion VARCHAR(20),
    Img_reaccion BLOB,
    Descripcion_reaccion VARCHAR(20)
);

-- Crear tabla Publicacion_Reaccion
CREATE TABLE Publicacion_Reaccion (
    ID_publicacion_reaccion INT(10) PRIMARY KEY,
    ID_publicacion INT(10),
    ID_reaccion INT(10)
);

-- Crear tabla Usuario_Reaccion
CREATE TABLE Usuario_Reaccion (
    ID_usuario_reaccion INT(10),
    ID_usuario INT(10),
    ID_reaccion INT(10)
);

-- Crear tabla Usuario_Categoria
CREATE TABLE Publicacion_Categoria (
    ID_publicacion_categoria INT(10) PRIMARY KEY,
    ID_publicacion INT(10),
    ID_categoria INT(10)
);

/* Relaciones de tabla Estado */
ALTER TABLE PQRS
ADD FOREIGN KEY (ID_estado) REFERENCES Estado (ID_estado);

ALTER TABLE Asistente
ADD FOREIGN KEY (ID_estado) REFERENCES Estado (ID_estado);

ALTER TABLE Rol
ADD FOREIGN KEY (ID_estado) REFERENCES Estado (ID_estado);

/* Relaciones de tabla Rol */
ALTER TABLE Usuario ADD FOREIGN KEY (ID_rol) REFERENCES Rol (ID_rol);

/* Relaciones de tabla Usuario*/

ALTER TABLE PQRS
ADD FOREIGN KEY (ID_usuario) REFERENCES Usuario (ID_usuario);

ALTER TABLE Asistente
ADD FOREIGN KEY (ID_usuario) REFERENCES Usuario (ID_usuario);

ALTER TABLE Usuario_reaccion
ADD FOREIGN KEY (ID_usuario) REFERENCES Usuario (ID_usuario);

ALTER TABLE Comentario
ADD FOREIGN KEY (ID_usuario) REFERENCES Usuario (ID_usuario);

ALTER TABLE Publicacion
ADD FOREIGN KEY (ID_usuario) REFERENCES Usuario (ID_usuario);
/* Relaciones de tabla Sexo*/

ALTER TABLE Usuario
ADD FOREIGN KEY (ID_sexo) REFERENCES Sexo (ID_sexo);

/* Relaciones de tabla Publicacion*/

ALTER TABLE Publicacion_reaccion
ADD FOREIGN KEY (ID_publicacion) REFERENCES Publicacion (ID_publicacion);

ALTER TABLE Comentario
ADD FOREIGN KEY (ID_publicacion) REFERENCES Publicacion (ID_publicacion);

/* Relaciones de tabla Reaccion*/

ALTER TABLE Usuario_reaccion
ADD FOREIGN KEY (ID_reaccion) REFERENCES Reaccion (ID_reaccion);

ALTER TABLE Publicacion_reaccion
ADD FOREIGN KEY (ID_reaccion) REFERENCES Reaccion (ID_reaccion);

ALTER TABLE Publicacion_Categoria
ADD FOREIGN KEY (ID_publicacion) REFERENCES Publicacion (ID_publicacion);

ALTER TABLE Publicacion_Categoria
ADD FOREIGN KEY (ID_categoria) REFERENCES Categoria (ID_categoria);

-- Insertar datos en la tabla Estado
INSERT INTO Estado (ID_estado, Nombre_estado, Descripcion_estado)
VALUES 
(1, AES_ENCRYPT('Activo', @encryption_key), AES_ENCRYPT('Estado activo', @encryption_key)),
(2, AES_ENCRYPT('Inactivo', @encryption_key), AES_ENCRYPT('Estado inactivo', @encryption_key)),
(3, AES_ENCRYPT('Pendiente', @encryption_key), AES_ENCRYPT('Estado pendiente', @encryption_key)),
(4, AES_ENCRYPT('Resuelto', @encryption_key), AES_ENCRYPT('Estado resuelto', @encryption_key)),
(5, AES_ENCRYPT('Archivado', @encryption_key), AES_ENCRYPT('Estado archivado', @encryption_key)),
(6, AES_ENCRYPT('En revisión', @encryption_key), AES_ENCRYPT('Estado en revisión', @encryption_key)),
(7, AES_ENCRYPT('Aprobado', @encryption_key), AES_ENCRYPT('Estado aprobado', @encryption_key)),
(8, AES_ENCRYPT('Rechazado', @encryption_key), AES_ENCRYPT('Estado rechazado', @encryption_key)),
(9, AES_ENCRYPT('En proceso', @encryption_key), AES_ENCRYPT('Estado en proceso', @encryption_key)),
(10, AES_ENCRYPT('Cancelado', @encryption_key), AES_ENCRYPT('Estado cancelado', @encryption_key));

-- Insertar datos en la tabla Rol
INSERT INTO Rol (ID_rol, Nombre_rol, Descripcion_rol, ID_estado)
VALUES 
(1, AES_ENCRYPT('usuario_registrado', @encryption_key), AES_ENCRYPT('Rol de usuario registrado', @encryption_key), 1),
(2, AES_ENCRYPT('administrador', @encryption_key), AES_ENCRYPT('Rol de administrador', @encryption_key), 1);

-- Insertar datos en la tabla Sexo
INSERT INTO Sexo (ID_sexo, Descripcion_sexo, Nombre_sexo)
VALUES 
(1, 'Masculino', 'Masculino'),
(2, 'Femenino', 'Femenino'),
(3, 'Otro', 'Otro');

-- Insertar datos en la tabla Reaccion
INSERT INTO Reaccion (ID_reaccion, Nombre_reaccion, Img_reaccion, Descripcion_reaccion)
VALUES 
(1, 'Me gusta', NULL, 'Me gusta'),
(2, 'Me encanta', NULL, 'Me encanta'),
(3, 'Me divierte', NULL, 'Me divierte'),
(4, 'Me sorprende', NULL, 'Me sorprende'),
(5, 'Me entristece', NULL, 'Me entristece'),
(6, 'Increible', NULL, 'Increible'),
(7, 'Me enoja', NULL, 'Me enoja');

-- Insertar datos en la tabla Usuario
INSERT INTO Usuario (ID_usuario, Nombre_usuario, Contraseña, Correo_usuario, Fecha_usuario, Notificaciones, ID_sexo, Img_usuario, ID_rol)
VALUES 
(1, 'usuario1', AES_ENCRYPT('contraseña1', @encryption_key), AES_ENCRYPT('usuario1@ejemplo.com', @encryption_key), '2024-01-01', TRUE, 1, NULL, 1),
(2, 'usuario2', AES_ENCRYPT('contraseña2', @encryption_key), AES_ENCRYPT('usuario2@ejemplo.com', @encryption_key), '2024-01-02', FALSE, 2, NULL, 1),
(3, 'usuario3', AES_ENCRYPT('contraseña3', @encryption_key), AES_ENCRYPT('usuario3@ejemplo.com', @encryption_key), '2024-01-03', TRUE, 1, NULL, 2),
(4, 'usuario4', AES_ENCRYPT('contraseña4', @encryption_key), AES_ENCRYPT('usuario4@ejemplo.com', @encryption_key), '2024-01-04', FALSE, 2, NULL, 1),
(5, 'usuario5', AES_ENCRYPT('contraseña5', @encryption_key), AES_ENCRYPT('usuario5@ejemplo.com', @encryption_key), '2024-01-05', TRUE, 1, NULL, 2),
(6, 'usuario6', AES_ENCRYPT('contraseña6', @encryption_key), AES_ENCRYPT('usuario6@ejemplo.com', @encryption_key), '2024-01-06', FALSE, 2, NULL, 1),
(7, 'usuario7', AES_ENCRYPT('contraseña7', @encryption_key), AES_ENCRYPT('usuario7@ejemplo.com', @encryption_key), '2024-01-07', TRUE, 1, NULL, 2),
(8, 'usuario8', AES_ENCRYPT('contraseña8', @encryption_key), AES_ENCRYPT('usuario8@ejemplo.com', @encryption_key), '2024-01-08', FALSE, 2, NULL, 1),
(9, 'usuario9', AES_ENCRYPT('contraseña9', @encryption_key), AES_ENCRYPT('usuario9@ejemplo.com', @encryption_key), '2024-01-09', TRUE, 1, NULL, 2),
(10, 'usuario10', AES_ENCRYPT('contraseña10', @encryption_key), AES_ENCRYPT('usuario10@ejemplo.com', @encryption_key), '2024-01-10', FALSE, 2, NULL, 1),
(11, 'usuario11', AES_ENCRYPT('contraseña11', @encryption_key), AES_ENCRYPT('usuario11@ejemplo.com', @encryption_key), '2024-01-11', TRUE, 1, NULL, 2),
(12, 'usuario12', AES_ENCRYPT('contraseña12', @encryption_key), AES_ENCRYPT('usuario12@ejemplo.com', @encryption_key), '2024-01-12', FALSE, 2, NULL, 1),
(13, 'usuario13', AES_ENCRYPT('contraseña13', @encryption_key), AES_ENCRYPT('usuario13@ejemplo.com', @encryption_key), '2024-01-13', TRUE, 1, NULL, 2),
(14, 'usuario14', AES_ENCRYPT('contraseña14', @encryption_key), AES_ENCRYPT('usuario14@ejemplo.com', @encryption_key), '2024-01-14', FALSE, 2, NULL, 1),
(15, 'usuario15', AES_ENCRYPT('contraseña15', @encryption_key), AES_ENCRYPT('usuario15@ejemplo.com', @encryption_key), '2024-01-15', TRUE, 1, NULL, 2),
(16, 'usuario16', AES_ENCRYPT('contraseña16', @encryption_key), AES_ENCRYPT('usuario16@ejemplo.com', @encryption_key), '2024-01-16', FALSE, 2, NULL, 1),
(17, 'usuario17', AES_ENCRYPT('contraseña17', @encryption_key), AES_ENCRYPT('usuario17@ejemplo.com', @encryption_key), '2024-01-17', TRUE, 1, NULL, 2),
(18, 'usuario18', AES_ENCRYPT('contraseña18', @encryption_key), AES_ENCRYPT('usuario18@ejemplo.com', @encryption_key), '2024-01-18', FALSE, 2, NULL, 1),
(19, 'usuario19', AES_ENCRYPT('contraseña19', @encryption_key), AES_ENCRYPT('usuario19@ejemplo.com', @encryption_key), '2024-01-19', TRUE, 1, NULL, 2),
(20, 'usuario20', AES_ENCRYPT('contraseña20', @encryption_key), AES_ENCRYPT('usuario20@ejemplo.com', @encryption_key), '2024-01-20', FALSE, 2, NULL, 1);

-- Insertar datos en la tabla Categoria
INSERT INTO Categoria (ID_categoria, Nombre_categoria, Descripcion_categoria)
VALUES 
(1, 'Pintura', 'Obras que utilizan pintura como medio principal, incluyendo óleo, acrílico, acuarela, entre otros.'),
(2, 'Escultura', 'Trabajos tridimensionales creados a partir de materiales como piedra, madera, metal, o arcilla.'),
(3, 'Fotografía', 'Imágenes capturadas a través de cámaras, ya sean analógicas o digitales.'),
(4, 'Dibujo', 'Obras realizadas mediante técnicas de dibujo como lápiz, carboncillo, o tinta.'),
(5, 'Grabado', 'Técnicas de impresión sobre papel u otros soportes, incluyendo xilografía, litografía, y grabado en relieve.'),
(6, 'Arte Digital', 'Creaciones artísticas generadas o modificadas mediante herramientas digitales y software.'),
(7, 'Arte Conceptual', 'Obras cuyo enfoque principal es la idea o concepto detrás de la pieza más que el objeto en sí.'),
(8, 'Arte Callejero', 'Incluye murales, graffiti y otras formas de arte realizadas en espacios públicos o urbanos.'),
(9, 'Arte Abstracto', 'Obras que se alejan de la representación figurativa y se centran en formas, colores y texturas.'),
(10, 'Arte Decorativo', 'Obras diseñadas para adornar espacios, como muebles, cerámica, o tejidos.'),
(11, 'Arte Contemporáneo', 'Obras y movimientos artísticos del presente o reciente pasado, reflejando tendencias actuales.'),
(12, 'Arte Moderno', 'Obras de finales del siglo XIX hasta mediados del siglo XX, que rompieron con las tradiciones anteriores.'),
(13, 'Arte Pop', 'Movimiento que se inspira en la cultura popular y los medios de comunicación de masas.'),
(14, 'Arte Minimalista', 'Estilo que se caracteriza por la simplicidad y la reducción a los elementos más básicos.'),
(15, 'Arte Primitivo', 'Obras creadas por culturas no occidentales o que imitan estilos de culturas antiguas y primitivas.'),
(16, 'Arte Religioso', 'Obras que representan temas y figuras religiosas de diversas tradiciones y creencias.'),
(17, 'Arte Figurado', 'Obras que representan figuras humanas, animales u objetos reconocibles del mundo real.'),
(18, 'Arte Experimental', 'Obras que exploran nuevas técnicas, materiales y métodos en el proceso creativo.'),
(19, 'Arte Ecológico', 'Obras que abordan temas relacionados con la naturaleza, el medio ambiente y la sostenibilidad.'),
(20, 'Arte de Performance', 'Obras que se realizan en vivo y a menudo involucran la acción del artista como parte de la pieza.');


-- Generar fechas aleatorias y títulos

SET @fecha_maxima = CURDATE(); -- Fecha actual

-- Inserciones para publicaciones
INSERT INTO Publicacion (ID_publicacion, Fecha_publicacion, Descripcion_publicacion, Img_publicacion, Cont_Explicit_publi, ID_usuario)
VALUES
    (1, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 1', 'img/publicaciones/img1.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (2, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 2', 'img/publicaciones/img2.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (3, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 3', 'img/publicaciones/img3.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (4, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 4', 'img/publicaciones/img4.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (5, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 5', 'img/publicaciones/img5.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (6, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 6', 'img/publicaciones/img6.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (7, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 7', 'img/publicaciones/img7.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (8, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 8', 'img/publicaciones/img8.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (9, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 9', 'img/publicaciones/img9.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (10, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 10', 'img/publicaciones/img10.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (11, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 11', 'img/publicaciones/img11.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (12, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 12', 'img/publicaciones/img12.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (13, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 13', 'img/publicaciones/img13.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (14, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 14', 'img/publicaciones/img14.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (15, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 15', 'img/publicaciones/img15.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (16, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 16', 'img/publicaciones/img16.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (17, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 17', 'img/publicaciones/img17.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (18, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 18', 'img/publicaciones/img18.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (19, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 19', 'img/publicaciones/img19.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (20, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 20', 'img/publicaciones/img20.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (21, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 21', 'img/publicaciones/img21.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (22, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 22', 'img/publicaciones/img22.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (23, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 23', 'img/publicaciones/img23.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (24, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 24', 'img/publicaciones/img24.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (25, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 25', 'img/publicaciones/img25.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (26, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 26', 'img/publicaciones/img26.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (27, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 27', 'img/publicaciones/img27.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (28, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 28', 'img/publicaciones/img28.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (29, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 29', 'img/publicaciones/img29.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (30, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 30', 'img/publicaciones/img30.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    
    (31, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 31', 'img/publicaciones/img31.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (32, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 32', 'img/publicaciones/img32.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (33, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 33', 'img/publicaciones/img33.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (34, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 34', 'img/publicaciones/img34.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (35, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 35', 'img/publicaciones/img35.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (36, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 36', 'img/publicaciones/img36.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (37, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 37', 'img/publicaciones/img37.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (38, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 38', 'img/publicaciones/img38.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (39, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 39', 'img/publicaciones/img39.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (40, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 40', 'img/publicaciones/img40.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (41, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 41', 'img/publicaciones/img41.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (42, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 42', 'img/publicaciones/img42.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (43, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 43', 'img/publicaciones/img43.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (44, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 44', 'img/publicaciones/img44.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (45, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 45', 'img/publicaciones/img45.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (46, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 46', 'img/publicaciones/img46.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (47, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 47', 'img/publicaciones/img47.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (48, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 48', 'img/publicaciones/img48.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (49, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 49', 'img/publicaciones/img49.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (50, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 50', 'img/publicaciones/img50.jpg', FALSE, FLOOR(1 + RAND() * 20)),

    (51, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 51', 'img/publicaciones/img51.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (52, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 52', 'img/publicaciones/img52.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (53, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 53', 'img/publicaciones/img53.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (54, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 54', 'img/publicaciones/img54.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (55, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 55', 'img/publicaciones/img55.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (56, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 56', 'img/publicaciones/img56.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (57, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 57', 'img/publicaciones/img57.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (58, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 58', 'img/publicaciones/img58.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (59, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 59', 'img/publicaciones/img59.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (60, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 60', 'img/publicaciones/img60.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (61, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 61', 'img/publicaciones/img61.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (62, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 62', 'img/publicaciones/img62.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (63, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 63', 'img/publicaciones/img63.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (64, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 64', 'img/publicaciones/img64.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (65, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 65', 'img/publicaciones/img65.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (66, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 66', 'img/publicaciones/img66.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (67, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 67', 'img/publicaciones/img67.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (68, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 68', 'img/publicaciones/img68.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (69, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 69', 'img/publicaciones/img69.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (70, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 70', 'img/publicaciones/img70.jpg', FALSE, FLOOR(1 + RAND() * 20)),

    (71, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 71', 'img/publicaciones/img71.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (72, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 72', 'img/publicaciones/img72.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (73, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 73', 'img/publicaciones/img73.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (74, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 74', 'img/publicaciones/img74.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (75, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 75', 'img/publicaciones/img75.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (76, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 76', 'img/publicaciones/img76.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (77, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 77', 'img/publicaciones/img77.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (78, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 78', 'img/publicaciones/img78.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (79, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 79', 'img/publicaciones/img79.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (80, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 80', 'img/publicaciones/img80.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (81, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 81', 'img/publicaciones/img81.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (82, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 82', 'img/publicaciones/img82.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (83, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 83', 'img/publicaciones/img83.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (84, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 84', 'img/publicaciones/img84.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (85, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 85', 'img/publicaciones/img85.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (86, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 86', 'img/publicaciones/img86.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (87, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 87', 'img/publicaciones/img87.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (88, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 88', 'img/publicaciones/img88.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (89, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 89', 'img/publicaciones/img89.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (90, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 90', 'img/publicaciones/img90.jpg', FALSE, FLOOR(1 + RAND() * 20)),

    (91, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 91', 'img/publicaciones/img91.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (92, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 92', 'img/publicaciones/img92.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (93, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 93', 'img/publicaciones/img93.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (94, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 94', 'img/publicaciones/img94.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (95, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 95', 'img/publicaciones/img95.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (96, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 96', 'img/publicaciones/img96.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (97, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 97', 'img/publicaciones/img97.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (98, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 98', 'img/publicaciones/img98.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (99, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 99', 'img/publicaciones/img99.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (100, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 100', 'img/publicaciones/img100.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (101, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 101', 'img/publicaciones/img101.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (102, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 102', 'img/publicaciones/img102.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (103, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 103', 'img/publicaciones/img103.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (104, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 104', 'img/publicaciones/img104.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (105, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 105', 'img/publicaciones/img105.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (106, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 106', 'img/publicaciones/img106.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (107, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 107', 'img/publicaciones/img107.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (108, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 108', 'img/publicaciones/img108.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (109, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 109', 'img/publicaciones/img109.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (110, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 110', 'img/publicaciones/img110.jpg', FALSE, FLOOR(1 + RAND() * 20)),


    (111, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 111', 'img/publicaciones/img111.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (112, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 112', 'img/publicaciones/img112.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (113, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 113', 'img/publicaciones/img113.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (114, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 114', 'img/publicaciones/img114.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (115, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 115', 'img/publicaciones/img115.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (116, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 116', 'img/publicaciones/img116.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (117, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 117', 'img/publicaciones/img117.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (118, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 118', 'img/publicaciones/img118.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (119, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 119', 'img/publicaciones/img119.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (120, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 120', 'img/publicaciones/img120.jpg', TRUE, FLOOR(1 + RAND() * 20)),
    (121, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 121', 'img/publicaciones/img121.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (122, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 122', 'img/publicaciones/img122.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (123, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 123', 'img/publicaciones/img123.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (124, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 124', 'img/publicaciones/img124.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (125, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 125', 'img/publicaciones/img125.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (126, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 126', 'img/publicaciones/img126.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (127, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 127', 'img/publicaciones/img127.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (128, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 128', 'img/publicaciones/img128.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (129, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 129', 'img/publicaciones/img129.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (130, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 130', 'img/publicaciones/img130.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (131, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 131', 'img/publicaciones/img131.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (132, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 132', 'img/publicaciones/img132.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (133, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 133', 'img/publicaciones/img133.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (134, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 134', 'img/publicaciones/img134.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (135, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 135', 'img/publicaciones/img135.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (136, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 136', 'img/publicaciones/img136.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (137, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 137', 'img/publicaciones/img137.jpg', FALSE, FLOOR(1 + RAND() * 20)),
    (138, DATE_SUB(@fecha_maxima, INTERVAL FLOOR(RAND() * 365) DAY), 'Publicacion 138', 'img/publicaciones/img138.jpg', FALSE, FLOOR(1 + RAND() * 20));


-- Inserciones para Asistente
INSERT INTO Asistente (
    ID_asistente,
    Fecha_peticion,
    Detalle_asistente,
    ID_estado,
    ID_usuario
) VALUES
    (1, '2024-01-01', AES_ENCRYPT('¿Qué es el arte abstracto y cómo se diferencia del arte figurativo?', @encryption_key), 1, 1),
    (2, '2024-01-02', AES_ENCRYPT('¿Cuáles son las principales técnicas de pintura utilizadas por los artistas contemporáneos?', @encryption_key), 1, 2),
    (3, '2024-01-03', AES_ENCRYPT('¿Cómo se ha desarrollado el arte digital en los últimos años?', @encryption_key), 2, 3),
    (4, '2024-01-04', AES_ENCRYPT('¿Qué influencia tuvo el arte pop en la cultura moderna?', @encryption_key), 3, 4),
    (5, '2024-01-05', AES_ENCRYPT('¿Quiénes son algunos de los artistas más influyentes del Renacimiento?', @encryption_key), 1, 5),
    (6, '2024-01-06', AES_ENCRYPT('¿Qué es el surrealismo y cómo afecta la percepción del arte?', @encryption_key), 2, 6),
    (7, '2024-01-07', AES_ENCRYPT('¿Cómo se realizan las técnicas de grabado en relieve?', @encryption_key), 3, 7),
    (8, '2024-01-08', AES_ENCRYPT('¿Cuáles son las principales corrientes del arte contemporáneo?', @encryption_key), 1, 8),
    (9, '2024-01-09', AES_ENCRYPT('¿Qué materiales se utilizan comúnmente en la escultura moderna?', @encryption_key), 2, 9),
    (10, '2024-01-10', AES_ENCRYPT('¿Cómo influyen los medios digitales en la creación de arte hoy en día?', @encryption_key), 3, 10),
    (11, '2024-01-11', AES_ENCRYPT('¿Qué es el arte minimalista y cuáles son sus características?', @encryption_key), 1, 11),
    (12, '2024-01-12', AES_ENCRYPT('¿Cómo se clasifica el arte de performance y qué elementos lo definen?', @encryption_key), 2, 12),
    (13, '2024-01-13', AES_ENCRYPT('¿Qué papel juega el arte en la preservación del medio ambiente?', @encryption_key), 3, 13),
    (14, '2024-01-14', AES_ENCRYPT('¿Cuáles son las diferencias entre el arte moderno y el arte contemporáneo?', @encryption_key), 1, 14),
    (15, '2024-01-15', AES_ENCRYPT('¿Cómo se pueden interpretar los símbolos en el arte religioso?', @encryption_key), 2, 15),
    (16, '2024-01-16', AES_ENCRYPT('¿Qué caracteriza al arte figurado y cómo se diferencia del arte abstracto?', @encryption_key), 3, 16),
    (17, '2024-01-17', AES_ENCRYPT('¿Cuáles son las tendencias actuales en el arte experimental?', @encryption_key), 1, 17),
    (18, '2024-01-18', AES_ENCRYPT('¿Qué técnicas se utilizan en el arte callejero y cómo se han popularizado?', @encryption_key), 2, 18),
    (19, '2024-01-19', AES_ENCRYPT('¿Cómo afecta el arte a la cultura popular y viceversa?', @encryption_key), 3, 19),
    (20, '2024-01-20', AES_ENCRYPT('¿Qué es el arte decorativo y cuáles son sus principales aplicaciones?', @encryption_key), 1, 20);


-- Inserciones Tabla PQRS
INSERT INTO PQRS (
    ID_pqrs,
    Fecha_pqrs,
    Contenido_pqrs,
    ID_estado,
    ID_usuario
)
VALUES
    (1, '2024-01-01', AES_ENCRYPT('Me encantaría que LABART agregara una función para buscar imágenes similares.', @encryption_key), 1, 1),
    (2, '2024-01-02', AES_ENCRYPT('Sería útil tener una opción para organizar los tableros por fecha de creación.', @encryption_key), 2, 2),
    (3, '2024-01-03', AES_ENCRYPT('Una función de etiquetado automático de imágenes ayudaría a categorizar mejor los pins.', @encryption_key), 3, 3),
    (4, '2024-01-04', AES_ENCRYPT('Me gusta mucho la interfaz, pero los tiempos de carga podrían mejorar.', @encryption_key), 1, 4),
    (5, '2024-01-05', AES_ENCRYPT('Sería genial integrar un editor de imágenes dentro de la aplicación.', @encryption_key), 2, 5),
    (6, '2024-01-06', AES_ENCRYPT('Agregar una opción de filtros para búsqueda avanzada mejoraría la experiencia.', @encryption_key), 3, 6),
    (7, '2024-01-07', AES_ENCRYPT('La aplicación funciona muy bien, pero el sistema de notificaciones necesita ajustes.', @encryption_key), 1, 7),
    (8, '2024-01-08', AES_ENCRYPT('Una sección de tendencias o lo más popular podría ser interesante.', @encryption_key), 2, 8),
    (9, '2024-01-09', AES_ENCRYPT('Aprecio la variedad de categorías, pero sería útil poder crear categorías personalizadas.', @encryption_key), 3, 9),
    (10, '2024-01-10', AES_ENCRYPT('La opción de compartir en redes sociales debería ser más visible.', @encryption_key), 1, 10),
    (11, '2024-01-11', AES_ENCRYPT('Sería excelente contar con un historial de búsquedas y pins recientes.', @encryption_key), 2, 11),
    (12, '2024-01-12', AES_ENCRYPT('Las imágenes se ven borrosas a veces. Mejorar la calidad de las imágenes cargadas sería útil.', @encryption_key), 3, 12),
    (13, '2024-01-13', AES_ENCRYPT('Añadir una función de arrastrar y soltar para organizar los tableros sería muy conveniente.', @encryption_key), 1, 13),
    (14, '2024-01-14', AES_ENCRYPT('Me encantaría ver más integraciones con herramientas de diseño gráfico.', @encryption_key), 2, 14),
    (15, '2024-01-15', AES_ENCRYPT('La opción de buscar por colores dominantes en las imágenes sería fantástica.', @encryption_key), 3, 15),
    (16, '2024-01-16', AES_ENCRYPT('El diseño es muy atractivo, pero los botones podrían ser un poco más grandes para facilitar su uso.', @encryption_key), 1, 16),
    (17, '2024-01-17', AES_ENCRYPT('Agregar recomendaciones personalizadas basadas en mis intereses mejoraría la experiencia.', @encryption_key), 2, 17),
    (18, '2024-01-18', AES_ENCRYPT('Las notificaciones por correo electrónico podrían ser más específicas y menos frecuentes.', @encryption_key), 3, 18),
    (19, '2024-01-19', AES_ENCRYPT('Una opción de modo oscuro para la aplicación sería un gran plus.', @encryption_key), 1, 19),
    (20, '2024-01-20', AES_ENCRYPT('Implementar una función de chat para discutir pins con otros usuarios sería genial.', @encryption_key), 6, 20),
    (21, '2024-01-21', AES_ENCRYPT('La capacidad de agrupar pins en carpetas dentro de tableros sería muy útil.', @encryption_key), 8, 10),
    (22, '2024-01-22', AES_ENCRYPT('Me gusta cómo se ven las imágenes, pero mejorar la velocidad de carga de la aplicación sería ideal.', @encryption_key), 10, 11),
    (23, '2024-01-23', AES_ENCRYPT('Sería interesante tener una vista previa en miniatura para las imágenes antes de hacer clic.', @encryption_key), 8, 12),
    (24, '2024-01-24', AES_ENCRYPT('Agregar más opciones de personalización para los perfiles de usuario podría ser divertido.', @encryption_key), 5, 13),
    (25, '2024-01-25', AES_ENCRYPT('Incorporar una función para guardar pins como borradores antes de publicarlos sería útil.', @encryption_key), 1, 14),
    (26, '2024-01-26', AES_ENCRYPT('El contenido recomendado a veces no es relevante. Mejorar el algoritmo de recomendaciones.', @encryption_key), 6, 15),
    (27, '2024-01-27', AES_ENCRYPT('Permitir que los usuarios colaboren en tableros compartidos podría ser una buena adición.', @encryption_key), 8, 16),
    (28, '2024-01-28', AES_ENCRYPT('Una opción para seguir a otros usuarios y ver sus publicaciones en mi feed sería genial.', @encryption_key), 7, 17),
    (29, '2024-01-29', AES_ENCRYPT('Facilitar la integración con otras plataformas de diseño y edición podría ser beneficioso.', @encryption_key), 1, 18),
    (30, '2024-01-30', AES_ENCRYPT('Incluir más tutoriales o guías sobre cómo usar la aplicación sería útil para nuevos usuarios.', @encryption_key), 3, 19),
    (31, '2024-01-31', AES_ENCRYPT('Agregar una opción para ordenar los pins por popularidad o fecha sería útil.', @encryption_key), 1, 20),
    (32, '2024-02-01', AES_ENCRYPT('Me encantaría tener una función de búsqueda por temas específicos dentro de las categorías.', @encryption_key), 2, 1),
    (33, '2024-02-02', AES_ENCRYPT('Las herramientas de edición de imágenes podrían ser más avanzadas para los usuarios pro.', @encryption_key), 3, 2);


-- Inserciones Tabla Comentario
INSERT INTO Comentario (ID_comentario, Contenido_comentario, Fecha_comentario, ID_usuario, ID_publicacion) VALUES
    (1, 'Comentario sobre la publicacion 1', '2024-09-01', 3, 12),
    (2, 'Este es un comentario en la publicacion 2', '2024-09-02', 7, 45),
    (3, 'Muy interesante el contenido de la publicacion 3', '2024-09-03', 10, 23),
    (4, 'No estoy de acuerdo con la publicacion 4', '2024-09-04', 2, 78),
    (5, 'Excelente publicacion, me ha gustado mucho', '2024-09-05', 14, 56),
    (6, 'Comentario en la publicacion 5', '2024-09-06', 8, 91),
    (7, 'Interesante punto de vista en la publicacion 6', '2024-09-07', 16, 103),
    (8, 'Me encanta la publicacion 7', '2024-09-08', 11, 33),
    (9, 'No entiendo la publicacion 8', '2024-09-09', 4, 11),
    (10, 'Comentario constructivo sobre la publicacion 9', '2024-09-10', 12, 67),
    (11, '¡Gran publicacion!', '2024-09-11', 15, 19),
    (12, 'El contenido de la publicacion 10 es muy util', '2024-09-12', 6, 29),
    (13, 'No me gusta la publicacion 11', '2024-09-13', 18, 76),
    (14, 'Comentario positivo sobre la publicacion 12', '2024-09-14', 5, 51),
    (15, '¿Podrias explicar mas sobre la publicacion 13?', '2024-09-15', 9, 88),
    (16, 'La publicacion 14 necesita mas detalles', '2024-09-16', 13, 104),
    (17, 'Interesante pero podria mejorar la publicacion 15', '2024-09-17', 20, 43),
    (18, 'Comentario sobre la publicacion 16', '2024-09-18', 17, 132),
    (19, 'No estoy seguro sobre la publicacion 17', '2024-09-19', 1, 22),
    (20, 'Buen trabajo en la publicacion 18', '2024-09-20', 19, 137);


-- Inserciones Tabla Publicacion_Reaccion
INSERT INTO
    Publicacion_Reaccion (
        ID_publicacion_reaccion,
        ID_publicacion,
        ID_reaccion
    )
VALUES (1, 1, 1),
    (2, 1, 2),
    (3, 2, 3),
    (4, 2, 4),
    (5, 3, 5),
    (6, 3, 6),
    (7, 4, 1),
    (8, 4, 2),
    (9, 5, 3),
    (10, 5, 4),
    (11, 6, 5),
    (12, 6, 6),
    (13, 7, 1),
    (14, 7, 2),
    (15, 8, 3),
    (16, 8, 4),
    (17, 9, 5),
    (18, 9, 6),
    (19, 10, 1),
    (20, 10, 2),
    (21, 11, 3),
    (22, 11, 4),
    (23, 12, 5),
    (24, 12, 6);




-- Insertar datos en la tabla Usuario_Reaccion
INSERT INTO
    Usuario_Reaccion (
        ID_usuario_reaccion,
        ID_usuario,
        ID_reaccion
    )
VALUES (1, 1, 1),
    (2, 1, 2),
    (3, 2, 3),
    (4, 2, 4),
    (5, 3, 5),
    (6, 3, 6),
    (7, 4, 1),
    (8, 4, 2),
    (9, 5, 3),
    (10, 5, 4),
    (11, 6, 5),
    (12, 6, 6),
    (13, 7, 1),
    (14, 7, 2),
    (15, 8, 3),
    (16, 8, 4),
    (17, 9, 5),
    (18, 9, 6),
    (19, 10, 1),
    (20, 10, 2),
    (21, 11, 3),
    (22, 11, 4),
    (23, 12, 5),
    (24, 12, 6);


-- Inserciones Tabla Publicacion_Categoria
INSERT INTO Publicacion_Categoria (ID_publicacion_categoria, ID_publicacion, ID_categoria) VALUES
    (1, 12, 3),
    (2, 45, 7),
    (3, 87, 5),
    (4, 34, 10),
    (5, 56, 8),
    (6, 23, 1),
    (7, 78, 15),
    (8, 92, 12),
    (9, 19, 4),
    (10, 104, 9),
    (11, 67, 16),
    (12, 35, 6),
    (13, 115, 20),
    (14, 88, 13),
    (15, 29, 11),
    (16, 53, 2),
    (17, 130, 17),
    (18, 71, 14),
    (19, 98, 18),
    (20, 46, 19);


 -- Consulta para mostrar datos desencriptados de Usuario
SELECT
    ID_usuario,
    Nombre_usuario,
    AES_DECRYPT(Contraseña, @encryption_key) AS Contraseña,
    AES_DECRYPT(
        Correo_usuario,
        @encryption_key
    ) AS Correo_usuario,
    Fecha_usuario,
    Notificaciones,
    ID_sexo,
    Img_usuario,
    ID_rol
FROM Usuario;


-- 1. Publicaciones con reacciones
-- Esta consulta lista todas las publicaciones que tienen al menos una reacción.
-- Problema resuelto: Permite identificar las publicaciones que han generado interacciones por parte de los usuarios.
SELECT
    p.ID_publicacion,
    p.Fecha_publicacion,
    p.Descripcion_publicacion
FROM
    Publicacion p
WHERE
    EXISTS (
        SELECT 1
        FROM Publicacion_Reaccion pr
        WHERE p.ID_publicacion = pr.ID_publicacion
    );

-- 2. Usuarios con comentarios recientes
-- Esta consulta muestra los usuarios que han hecho comentarios en los últimos 30 días, desencriptando su correo electrónico.
-- Problema resuelto: Permite identificar a los usuarios que han estado activos recientemente en términos de interacción.
SELECT
    u.ID_usuario,
    u.Nombre_usuario,
    AES_DECRYPT(u.Correo_usuario, @encryption_key) AS Correo_usuario
FROM
    Usuario u
WHERE
    EXISTS (
        SELECT 1
        FROM Comentario c
        WHERE u.ID_usuario = c.ID_usuario
          AND c.Fecha_comentario >= CURDATE() - INTERVAL 30 DAY
    );

-- 3. Mostrar Comentarios en Publicaciones de Usuarios con Rol Específico
-- Esta consulta lista los comentarios realizados en publicaciones por usuarios que tienen un rol específico, en este caso el rol con ID 2.
-- Problema resuelto: Permite analizar los comentarios hechos por usuarios con un rol específico dentro del sistema (ej. administradores, moderadores).
SELECT
    c.ID_comentario,
    c.Contenido_comentario,
    c.Fecha_comentario,
    c.ID_usuario,
    c.ID_publicacion
FROM
    Comentario c
WHERE
    c.ID_usuario IN (
        SELECT
            u.ID_usuario
        FROM
            Usuario u
        WHERE
            u.ID_rol = 2 -- Ejemplo de rol específico, cambiar según necesidad
    );



-- 4. Publicaciones con reacciones específicas
-- Esta consulta muestra las publicaciones que tienen una reacción específica, en este caso la reacción con ID 3.
-- Problema resuelto: Ayuda a filtrar publicaciones que han recibido un tipo de reacción específica (como "me gusta", "amor", etc.).
SELECT
    p.ID_publicacion,
    p.Fecha_publicacion,
    p.Descripcion_publicacion
FROM
    Publicacion p
WHERE
    EXISTS (
        SELECT 1
        FROM Publicacion_Reaccion pr
        WHERE p.ID_publicacion = pr.ID_publicacion
          AND pr.ID_reaccion = 3
    );

-- 5. Usuarios con roles específicos
-- Esta consulta muestra los usuarios que tienen un rol específico, desencriptando su correo electrónico.
-- Problema resuelto: Permite extraer la información de usuarios que desempeñan un rol determinado en el sistema (ej. administrador, usuario regular).
SELECT
    u.ID_usuario,
    u.Nombre_usuario,
    AES_DECRYPT(u.Correo_usuario, @encryption_key) AS Correo_usuario
FROM
    Usuario u
WHERE
    u.ID_rol = 2;

-- 6. Estado de PQRS y su contenido
-- Esta consulta muestra los detalles de las PQRS (Peticiones, Quejas, Reclamos, Sugerencias) junto con su estado, desencriptando la información.
-- Problema resuelto: Permite visualizar el estado actual de las PQRS y su contenido detallado, lo cual es útil para el seguimiento y gestión.
SELECT
    pq.ID_pqrs,
    pq.Fecha_pqrs,
    AES_DECRYPT(pq.Contenido_pqrs, @encryption_key) AS Contenido_pqrs,
    AES_DECRYPT(e.Nombre_estado, @encryption_key) AS Nombre_estado,
    AES_DECRYPT(e.Descripcion_estado, @encryption_key) AS Descripcion_estado
FROM
    PQRS pq
JOIN
    Estado e ON pq.ID_estado = e.ID_estado
WHERE
    pq.ID_usuario = 1;

-- 7. Publicaciones de usuarios con notificaciones activas
-- Esta consulta muestra las publicaciones hechas por usuarios que tienen las notificaciones activas.
-- Problema resuelto: Permite identificar las publicaciones de usuarios que están configurados para recibir notificaciones, lo que puede ayudar en la interacción continua.
SELECT
    p.ID_publicacion,
    p.Fecha_publicacion,
    p.Descripcion_publicacion
FROM
    Publicacion p
JOIN
    Usuario u ON p.ID_usuario = u.ID_usuario
WHERE
    u.Notificaciones = TRUE;

-- 8. Asistentes con estados específicos
-- Esta consulta muestra los asistentes que tienen un estado específico (en este caso, estado con ID 3) desencriptando los detalles de cada asistente.
-- Problema resuelto: Facilita la revisión de asistentes según su estado, útil para la gestión de procesos de atención o seguimiento.
SELECT
    a.ID_asistente,
    a.Fecha_peticion,
    AES_DECRYPT(a.Detalle_asistente, @encryption_key) AS Detalle_asistente
FROM
    Asistente a
WHERE
    a.ID_estado = 3;


-- 9. Mostrar Publicaciones con Comentarios de Usuarios que Tienen Notificaciones Activadas
-- Esta consulta muestra las publicaciones que han sido comentadas por usuarios que tienen activadas las notificaciones.
-- Problema resuelto: Identifica publicaciones que están recibiendo comentarios por parte de usuarios activos en cuanto a notificaciones.
SELECT
    p.ID_publicacion,
    p.Fecha_publicacion,
    p.Descripcion_publicacion,
    p.Img_publicacion
FROM
    Publicacion p
WHERE
    p.ID_publicacion IN (
        SELECT
            c.ID_publicacion
        FROM
            Comentario c
        JOIN
            Usuario u ON c.ID_usuario = u.ID_usuario
        WHERE
            u.Notificaciones = TRUE
    );

-- 10. Mostrar Publicaciones que Tienen Comentarios y el Usuario que las Realizó
-- Esta consulta muestra las publicaciones que tienen comentarios y el nombre del usuario que realizó el comentario.
-- Problema resuelto: Permite ver qué usuarios están interactuando con qué publicaciones, lo cual es útil para analizar la actividad en la plataforma.
SELECT
    p.ID_publicacion,
    p.Fecha_publicacion,
    p.Descripcion_publicacion, 
    p.Img_publicacion,
    u.ID_usuario,
    u.Nombre_usuario
FROM
    Publicacion p
JOIN
    Comentario c ON p.ID_publicacion = c.ID_publicacion
JOIN
    Usuario u ON c.ID_usuario = u.ID_usuario
GROUP BY
    p.ID_publicacion, u.ID_usuario
ORDER BY
    p.Fecha_publicacion DESC;