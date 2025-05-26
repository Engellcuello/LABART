import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class SelectImageDialog extends StatelessWidget {
  const SelectImageDialog({
    required this.title,
    super.key,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    const imageLinks = [
      'https://picsum.photos/200',
      'https://picsum.photos/201',
      'https://picsum.photos/202',
      'https://picsum.photos/203',
      'https://picsum.photos/204',
      'https://picsum.photos/205',
      'https://picsum.photos/206',
      'https://picsum.photos/207',
      'https://picsum.photos/208',
      'https://picsum.photos/209',
      'https://picsum.photos/210',
      'https://picsum.photos/211',
      'https://picsum.photos/212',
      'https://picsum.photos/213',
      'https://picsum.photos/214',
      'https://picsum.photos/215',
      'https://picsum.photos/216',
      'https://picsum.photos/217',
      'https://picsum.photos/218',
      'https://picsum.photos/219',
      'https://picsum.photos/220',
    ];
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      content: imageLinks.isEmpty
          ? const Text(
              'No images',
              style: TextStyle(color: Colors.white),
            )
          : FractionallySizedBox(
              heightFactor: 0.5,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (final imageLink in imageLinks) getImage(imageLink),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget getImage(String imageUrl) {
    return FutureBuilder<Uint8List>(
      future: Future(() async {
        final response = await HttpClient().getUrl(Uri.parse(imageUrl));
        final bytes = await consolidateHttpClientResponseBytes(
          await response.close(),
        );
        final imageUint8List = bytes;
        return imageUint8List;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () => Navigator.pop(context, snapshot.data),
            child: FractionallySizedBox(
              widthFactor: 1 / 4,
              child: Image.memory(snapshot.data!),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
