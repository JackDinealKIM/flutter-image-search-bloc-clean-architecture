import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:search_images/presentation/widgets/image_grid_widget.dart';

class ImagePage extends StatefulWidget {
  static const String routeName = "/image";

  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final String imageUrl = args['imageUrl'] as String;
    final String title = args['title'] as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ExtendedImage.network(
          imageUrl,
          fit: BoxFit.contain,
          //enableLoadState: false,
          mode: ExtendedImageMode.gesture,
          initGestureConfigHandler: (state) {
            return GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 3.0,
              animationMaxScale: 3.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              // inPageView: true,
              initialAlignment: InitialAlignment.center,
            );
          },
        ),
      ),
    );
  }
}
