import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:search_images/presentation/widgets/image_grid_widget.dart';

class ImagePage extends StatefulWidget {
  static const String routeName = "/image";

  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  Widget build(BuildContext context) {
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

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
          enableLoadState: true,
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
              initialAlignment: InitialAlignment.center,
            );
          },
          onDoubleTap: (ExtendedImageGestureState state) {
            ///you can use define pointerDownPosition as you can,
            ///default value is double tap pointer down postion.
            var pointerDownPosition = state.pointerDownPosition;
            double begin = state.gestureDetails!.totalScale!;
            double end;

            if (begin == 1) {
              end = 1.5;
            } else {
              end = 1;
            }

            _animation = _animationController.drive(Tween<double>(begin: begin, end: end));

            animationListener() {
              state.handleDoubleTap(scale: _animation.value, doubleTapPosition: pointerDownPosition);
            }

            _animation.removeListener(animationListener);
            _animationController.stop();
            _animationController.reset();
            _animation.addListener(animationListener);
            _animationController.forward();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
