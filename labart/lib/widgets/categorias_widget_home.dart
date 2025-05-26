import 'package:flutter/material.dart';

int contador = 0;

class CategoriasWidgetHome extends StatelessWidget {
  final List<String> imageUrls = [
    'https://www.shutterstock.com/image-illustration/david-street-style-graphic-designtextile-600nw-2265632523.jpg',
    'https://ethic.es/wp-content/uploads/2022/12/vangog-2.jpg',
    'https://cdn.pixabay.com/photo/2024/04/08/10/27/ai-generated-8683187_640.png',
    'https://www.ttamayo.com/wp-content/uploads/2023/06/digital-sketches-ashline.jpeg',
    'https://static.vecteezy.com/system/resources/previews/047/513/563/non_2x/happy-cartoon-cat-with-a-big-smile-and-playful-expression-free-vector.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgiHMyIZ7v8FtQ-pWa0xgBJyVIg2y5ItKD4w&s',
    'https://gpoarca.com/cdn/shop/articles/Daniel-Libeskind_4472x.jpg?v=1553193575',
  ];

  CategoriasWidgetHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0.0,
      ).copyWith(bottom: 16.0), // Añadido margen abajo
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleAndArrowButton(),
          SizedBox(height: 16),
          _buildImageList(),
        ],
      ),
    );
  }

  Widget _buildTitleAndArrowButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Categorías',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            // Acción al presionar la flecha
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: Icon(
              Icons.arrow_forward,
              color: Colors.black.withOpacity(0.5),
              size: 24,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildImageList() {
    return SizedBox(
      height: 180, // Altura de las imágenes
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Desplazamiento horizontal
        itemCount: imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildImageCard(imageUrls[index]);
        },
      ),
    );
  }

  // Card para cada imagen
  Widget _buildImageCard(String imageUrl) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 2.0,
      ), // Margen entre las imágenes
      width: 120, // Ancho de las imágenes
      height: 280, // Altura de las imágenes
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Text(
              'Categoría ${contador += 1}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.camera_alt, color: Colors.white, size: 15.0),
            ),
          ),
        ],
      ),
    );
  }
}
