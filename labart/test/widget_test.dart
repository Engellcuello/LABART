// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:labart/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}




// USE labart_api;

// WITH 
// -- Definir el margen de similitud de colores (ajustable)
// constantes AS (
//     SELECT 
//         13 AS id_publicacion_referencia,
//         30 AS margen_color -- Margen de diferencia permitido para cada componente RGB (0-255)
// ),

// -- Obtener etiquetas de la publicación de referencia
// etiquetas_referencia AS (
//     SELECT descripcion, score
//     FROM Etiqueta_Publicacion
//     WHERE ID_publicacion = (SELECT id_publicacion_referencia FROM constantes)
// ),

// -- Obtener colores de la publicación de referencia
// colores_referencia AS (
//     SELECT red, green, blue, score
//     FROM Color_Publicacion
//     WHERE ID_publicacion = (SELECT id_publicacion_referencia FROM constantes)
// ),

// -- Obtener categorías de la publicación de referencia
// categorias_referencia AS (
//     SELECT ID_categoria
//     FROM Publicacion_Categoria
//     WHERE ID_publicacion = (SELECT id_publicacion_referencia FROM constantes)
// ),

// -- 1. Publicaciones con las mismas etiquetas (score similar con margen) y colores similares (con margen)
// mismas_etiquetas_colores_similares AS (
//     SELECT 
//         p.ID_publicacion,
//         1 AS prioridad,
//         COUNT(DISTINCT ep.descripcion) AS coincidencias_etiquetas,
//         SUM(ep.score) AS suma_scores_etiquetas,
//         COUNT(DISTINCT cp.ID_color_publicacion) AS coincidencias_colores,
//         SUM(
//             (1 - (ABS(cp.red - cr.red)/255.0)) * 
//             (1 - (ABS(cp.green - cr.green)/255.0)) * 
//             (1 - (ABS(cp.blue - cr.blue)/255.0)) * 
//             ((cp.score + cr.score)/2)
//         ) AS suma_scores_colores,
//         0 AS coincidencias_categorias
//     FROM Publicacion p
//     -- Unir con etiquetas que coinciden en nombre y con score similar (margen de 0.1)
//     JOIN Etiqueta_Publicacion ep ON p.ID_publicacion = ep.ID_publicacion
//     JOIN etiquetas_referencia er ON ep.descripcion = er.descripcion 
//                                AND ABS(ep.score - er.score) <= 0.1  -- Margen de 0.1 para el score
//     -- Unir con colores que están dentro del margen permitido
//     JOIN Color_Publicacion cp ON p.ID_publicacion = cp.ID_publicacion
//     JOIN colores_referencia cr ON 
//         ABS(cp.red - cr.red) <= (SELECT margen_color FROM constantes) AND
//         ABS(cp.green - cr.green) <= (SELECT margen_color FROM constantes) AND
//         ABS(cp.blue - cr.blue) <= (SELECT margen_color FROM constantes)
//     WHERE p.ID_publicacion != (SELECT id_publicacion_referencia FROM constantes)
//     GROUP BY p.ID_publicacion
// ),
// -- 2. Publicaciones con algunas etiquetas en común (no necesariamente mismo score) y algunos colores similares
// etiquetas_colores_comunes AS (
//     SELECT 
//         p.ID_publicacion,
//         2 AS prioridad,
//         COUNT(DISTINCT ep.descripcion) AS coincidencias_etiquetas,
//         SUM(ep.score) AS suma_scores_etiquetas,
//         COUNT(DISTINCT cp.ID_color_publicacion) AS coincidencias_colores,
//         SUM(
//             (1 - (ABS(cp.red - cr.red)/255.0)) * 
//             (1 - (ABS(cp.green - cr.green)/255.0)) * 
//             (1 - (ABS(cp.blue - cr.blue)/255.0)) * 
//             ((cp.score + cr.score)/2)
//         ) AS suma_scores_colores,
//         0 AS coincidencias_categorias
//     FROM Publicacion p
//     JOIN Etiqueta_Publicacion ep ON p.ID_publicacion = ep.ID_publicacion
//     JOIN etiquetas_referencia er ON ep.descripcion = er.descripcion
//     JOIN Color_Publicacion cp ON p.ID_publicacion = cp.ID_publicacion
//     JOIN colores_referencia cr ON 
//         ABS(cp.red - cr.red) <= (SELECT margen_color FROM constantes) AND
//         ABS(cp.green - cr.green) <= (SELECT margen_color FROM constantes) AND
//         ABS(cp.blue - cr.blue) <= (SELECT margen_color FROM constantes)
//     WHERE p.ID_publicacion != (SELECT id_publicacion_referencia FROM constantes)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM mismas_etiquetas_colores_similares)
//     GROUP BY p.ID_publicacion
// ),

// -- 3. Publicaciones con etiquetas similares pero NINGÚN color similar
// etiquetas_similares_sin_colores AS (
//     SELECT 
//         p.ID_publicacion,
//         3 AS prioridad,
//         COUNT(DISTINCT ep.descripcion) AS coincidencias_etiquetas,
//         SUM(ep.score) AS suma_scores_etiquetas,
//         0 AS coincidencias_colores,
//         0 AS suma_scores_colores,
//         0 AS coincidencias_categorias
//     FROM Publicacion p
//     JOIN Etiqueta_Publicacion ep ON p.ID_publicacion = ep.ID_publicacion
//     JOIN etiquetas_referencia er ON ep.descripcion = er.descripcion
//     WHERE p.ID_publicacion != (SELECT id_publicacion_referencia FROM constantes)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM mismas_etiquetas_colores_similares)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM etiquetas_colores_comunes)
//       AND NOT EXISTS (
//           SELECT 1 
//           FROM Color_Publicacion cp
//           JOIN colores_referencia cr ON 
//               ABS(cp.red - cr.red) <= (SELECT margen_color FROM constantes) AND
//               ABS(cp.green - cr.green) <= (SELECT margen_color FROM constantes) AND
//               ABS(cp.blue - cr.blue) <= (SELECT margen_color FROM constantes)
//           WHERE cp.ID_publicacion = p.ID_publicacion
//       )
//     GROUP BY p.ID_publicacion
// ),

// -- 4. Publicaciones con colores similares pero NINGUNA etiqueta en común
// colores_similares_sin_etiquetas AS (
//     SELECT 
//         p.ID_publicacion,
//         4 AS prioridad,
//         0 AS coincidencias_etiquetas,
//         0 AS suma_scores_etiquetas,
//         COUNT(DISTINCT cp.ID_color_publicacion) AS coincidencias_colores,
//         SUM(
//             (1 - (ABS(cp.red - cr.red)/255.0)) * 
//             (1 - (ABS(cp.green - cr.green)/255.0)) * 
//             (1 - (ABS(cp.blue - cr.blue)/255.0)) * 
//             ((cp.score + cr.score)/2)
//         ) AS suma_scores_colores,
//         0 AS coincidencias_categorias
//     FROM Publicacion p
//     JOIN Color_Publicacion cp ON p.ID_publicacion = cp.ID_publicacion
//     JOIN colores_referencia cr ON 
//         ABS(cp.red - cr.red) <= (SELECT margen_color FROM constantes) AND
//         ABS(cp.green - cr.green) <= (SELECT margen_color FROM constantes) AND
//         ABS(cp.blue - cr.blue) <= (SELECT margen_color FROM constantes)
//     WHERE p.ID_publicacion != (SELECT id_publicacion_referencia FROM constantes)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM mismas_etiquetas_colores_similares)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM etiquetas_colores_comunes)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM etiquetas_similares_sin_colores)
//       AND NOT EXISTS (
//           SELECT 1 
//           FROM Etiqueta_Publicacion ep
//           JOIN etiquetas_referencia er ON ep.descripcion = er.descripcion
//           WHERE ep.ID_publicacion = p.ID_publicacion
//       )
//     GROUP BY p.ID_publicacion
// ),

// -- 5. Publicaciones con categorías en común
// categorias_comunes AS (
//     SELECT 
//         p.ID_publicacion,
//         5 AS prioridad,
//         0 AS coincidencias_etiquetas,
//         0 AS suma_scores_etiquetas,
//         0 AS coincidencias_colores,
//         0 AS suma_scores_colores,
//         COUNT(*) AS coincidencias_categorias
//     FROM Publicacion p
//     JOIN Publicacion_Categoria pc ON p.ID_publicacion = pc.ID_publicacion
//     JOIN categorias_referencia cr ON pc.ID_categoria = cr.ID_categoria
//     WHERE p.ID_publicacion != (SELECT id_publicacion_referencia FROM constantes)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM mismas_etiquetas_colores_similares)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM etiquetas_colores_comunes)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM etiquetas_similares_sin_colores)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM colores_similares_sin_etiquetas)
//     GROUP BY p.ID_publicacion
// ),

// -- 6. Otras publicaciones sin relación directa (ordenadas por fecha descendente)
// otras_publicaciones AS (
//     SELECT 
//         p.ID_publicacion,
//         6 AS prioridad,
//         0 AS coincidencias_etiquetas,
//         0 AS suma_scores_etiquetas,
//         0 AS coincidencias_colores,
//         0 AS suma_scores_colores,
//         0 AS coincidencias_categorias,
//         p.Fecha_Publicacion
//     FROM Publicacion p
//     WHERE p.ID_publicacion != (SELECT id_publicacion_referencia FROM constantes)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM mismas_etiquetas_colores_similares)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM etiquetas_colores_comunes)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM etiquetas_similares_sin_colores)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM colores_similares_sin_etiquetas)
//       AND p.ID_publicacion NOT IN (SELECT ID_publicacion FROM categorias_comunes)
//     ORDER BY p.Fecha_Publicacion DESC
// )

// -- Unir todos los resultados
// SELECT 
//     p.ID_publicacion,
//     p.Titulo_publicacion,
//     p.Descripcion_publicacion,
//     p.Img_publicacion,
//     r.prioridad,
//     r.coincidencias_etiquetas,
//     r.suma_scores_etiquetas,
//     r.coincidencias_colores,
//     r.suma_scores_colores,
//     r.coincidencias_categorias,
//     CASE r.prioridad
//         WHEN 1 THEN 'Mismas etiquetas y colores similares'
//         WHEN 2 THEN 'Algunas etiquetas y colores similares'
//         WHEN 3 THEN 'Etiquetas similares sin colores similares'
//         WHEN 4 THEN 'Colores similares sin etiquetas'
//         WHEN 5 THEN 'Mismas categorías'
//         WHEN 6 THEN 'Otras publicaciones'
//     END AS tipo_recomendacion,
//     p.Fecha_Publicacion
// FROM (
//     SELECT ID_publicacion, prioridad, coincidencias_etiquetas, suma_scores_etiquetas, 
//            coincidencias_colores, suma_scores_colores, coincidencias_categorias, NULL AS Fecha_Publicacion 
//     FROM mismas_etiquetas_colores_similares
//     UNION ALL
//     SELECT ID_publicacion, prioridad, coincidencias_etiquetas, suma_scores_etiquetas, 
//            coincidencias_colores, suma_scores_colores, coincidencias_categorias, NULL AS Fecha_Publicacion 
//     FROM etiquetas_colores_comunes
//     UNION ALL
//     SELECT ID_publicacion, prioridad, coincidencias_etiquetas, suma_scores_etiquetas, 
//            coincidencias_colores, suma_scores_colores, coincidencias_categorias, NULL AS Fecha_Publicacion 
//     FROM etiquetas_similares_sin_colores
//     UNION ALL
//     SELECT ID_publicacion, prioridad, coincidencias_etiquetas, suma_scores_etiquetas, 
//            coincidencias_colores, suma_scores_colores, coincidencias_categorias, NULL AS Fecha_Publicacion 
//     FROM colores_similares_sin_etiquetas
//     UNION ALL
//     SELECT ID_publicacion, prioridad, coincidencias_etiquetas, suma_scores_etiquetas, 
//            coincidencias_colores, suma_scores_colores, coincidencias_categorias, NULL AS Fecha_Publicacion 
//     FROM categorias_comunes
//     UNION ALL
//     SELECT ID_publicacion, prioridad, coincidencias_etiquetas, suma_scores_etiquetas, 
//            coincidencias_colores, suma_scores_colores, coincidencias_categorias, Fecha_Publicacion
//     FROM otras_publicaciones
// ) r
// JOIN Publicacion p ON r.ID_publicacion = p.ID_publicacion
// ORDER BY 
//     r.prioridad,
//     CASE WHEN r.prioridad = 6 THEN 0 ELSE 1 END,
//     r.coincidencias_etiquetas DESC,
//     r.suma_scores_etiquetas DESC,
//     r.suma_scores_colores DESC,
//     r.coincidencias_colores DESC,
//     r.coincidencias_categorias DESC,
//     CASE WHEN r.prioridad = 6 THEN p.Fecha_Publicacion ELSE NULL END DESC,
//     CASE WHEN r.prioridad <> 6 THEN p.Fecha_Publicacion ELSE NULL END DESC;