import 'package:flutter/material.dart';

import '../../domain/entities/search_image.dart';
import '../pages/image_page.dart';

class ImageGridWidget extends StatelessWidget {
  final List<SearchImage> images;

  const ImageGridWidget({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      itemBuilder: (BuildContext s, int index) {
        return _imageBody(context: context, image: images[index]);
      },
      itemCount: images.length,
    );
  }

  Widget _imageBody({required BuildContext context, required SearchImage image}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ImagePage.routeName, arguments: {'imageUrl': image.imageUrl, 'title': image.siteName}),
      child: Stack(
        children: [
          Image.network(
            image.thumbnailUrl,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Text(
                image.siteName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 50,
              width: 50,
              child: IconButton(
                onPressed: () {
                  // TODO reverse current favorite status
                },
                icon: Icon(
                  image.isFavorited ? Icons.favorite : Icons.favorite_outline,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
