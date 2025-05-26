import 'package:flutter/material.dart';
import 'package:labart/widgets/categorias_widget_home.dart';

class Home extends StatelessWidget {
 

  static const List<String> imageUrls1 = [
    'https://www.shutterstock.com/image-illustration/david-street-style-graphic-designtextile-600nw-2265632523.jpg',
    'https://cdn.pixabay.com/photo/2017/08/30/17/26/please-2697951_1280.jpg',
    'https://static01.nyt.com/images/2023/05/30/well/30WELL-ART-BRAIN-esp/30WELL-ART-BRAIN-videoSixteenByNineJumbo1600.jpg',
    'https://cdn.pixabay.com/photo/2017/08/30/17/26/please-2697951_1280.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzTXmUOuX_1Av-Hg5grIMhBkSHGPHuKInRWjA24bYje7VzSQmHZ12V0jm0mfPA3DEJC5Q&usqp=CAU',
  ];

  static const List<String> imageUrls2 = [
    'https://cdn.shopify.com/s/files/1/0229/0839/files/bancos_de_imagenes_gratis.jpg?v=1630420628',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmXlb00UyFX09tgmEVL-JztBEFKwLWqyzcSw&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzTXmUOuX_1Av-Hg5grIMhBkSHGPHuKInRWjA24bYje7VzSQmHZ12V0jm0mfPA3DEJC5Q&usqp=CAU',
    'https://cdn.pixabay.com/photo/2017/08/30/17/26/please-2697951_1280.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzTXmUOuX_1Av-Hg5grIMhBkSHGPHuKInRWjA24bYje7VzSQmHZ12V0jm0mfPA3DEJC5Q&usqp=CAU',
  ];

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double paddingTotal = 2.0;
    double paddingSide = paddingTotal / 2;

    return Scaffold(
      appBar: AppBar(title: Text('Publicaciones')),
      body: Padding(
        padding: EdgeInsets.all(paddingTotal),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CategoriasWidgetHome(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: paddingSide),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: imageUrls1.map((url) {
                          return GestureDetector(
                            onTap: () {
                              print('Imagen tocada en el primer div');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.fitWidth,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: paddingSide),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: imageUrls2.map((url) {
                          return GestureDetector(
                            onTap: () {
                              print('Imagen tocada en el segundo div');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.fitWidth,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
