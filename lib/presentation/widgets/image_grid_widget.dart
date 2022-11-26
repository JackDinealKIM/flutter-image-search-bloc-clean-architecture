import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/search_image.dart';
import '../bloc/search/search_bloc.dart';
import '../pages/image_page.dart';

class ImageGridWidget extends StatelessWidget {
  final List<SearchImage> images;
  final bool isFavorited;

  const ImageGridWidget({super.key, required this.images, this.isFavorited = false});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      itemBuilder: (BuildContext s, int index) {
        return _imageBody(context: context, index: index);
      },
      itemCount: images.length,
    );
  }

  Widget _imageBody({required BuildContext context, required int index}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ImagePage.routeName, arguments: {'imageUrl': images[index].imageUrl, 'title': images[index].siteName}),
      child: isFavorited ? _imageContainer(thumbnailUrl: images[index].thumbnailUrl) : _resultContainer(index: index, context: context),
    );
  }

  Widget _resultContainer({required int index, required BuildContext context}) {
    return Stack(
      children: [
        _imageContainer(thumbnailUrl: images[index].thumbnailUrl),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Text(
              images[index].siteName,
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
                final searchBloc = context.read<SearchBloc>();
                searchBloc.add(UpdateSearchImageEvent(image: SearchImage.copyWith((searchBloc.state as Loaded).images[index]), index: index));
              },
              icon: Icon(
                images[index].isFavorited ? Icons.favorite : Icons.favorite_outline,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageContainer({required String thumbnailUrl}) {
    return Image.network(
      thumbnailUrl,
      fit: BoxFit.cover,
    );
  }
}
