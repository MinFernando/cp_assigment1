import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class ImageLoader {
  ImageProvider loadImage(String url);
}

class NetworkImageLoader implements ImageLoader {
  @override
  ImageProvider loadImage(String url) {
    return NetworkImage(url);
  }
}

class AssetImageLoader implements ImageLoader {
  @override
  ImageProvider loadImage(String url) {
    // placeholder asset image
    return AssetImage('web/assets/cp3.jpg');
  }
}

class MovieWidget extends StatelessWidget {
  final String imageUrl;
  final ImageLoader imageLoader;

  MovieWidget({required this.imageUrl, required this.imageLoader});

  @override
  Widget build(BuildContext context) {
    return Image(image: imageLoader.loadImage(imageUrl));
  }
}


void main() {
  testWidgets('MovieWidget displays an image', (WidgetTester tester) async {  
    final imageLoader = AssetImageLoader();

    await tester.pumpWidget(MaterialApp(
      home: MovieWidget(imageUrl: 'web/assets/cp3.jpg', imageLoader: imageLoader),
    ));    
  });
}
