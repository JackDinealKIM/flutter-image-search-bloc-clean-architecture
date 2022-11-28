import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/log.dart';
import '../../domain/entities/search_image.dart';
import '../bloc/favorite/favorite_bloc.dart' as fb;
import '../bloc/search/search_bloc.dart' as sb;
import '../bloc/search/search_bloc.dart';
import '../pages/image_page.dart';

class ImageGridWidget extends StatelessWidget {
  final List<SearchImage> images;
  final bool isSearchTab;
  final int currentPage;
  final String query;

  ImageGridWidget({
    super.key,
    required this.images,
    this.currentPage = 1,
    this.query = '',
    this.isSearchTab = false,
  });

  bool _isLoading  = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (sn) {
        if (query.isNotEmpty && !_isLoading && sn is ScrollUpdateNotification && sn.metrics.pixels == sn.metrics.maxScrollExtent) {
          _isLoading = true;
          BlocProvider.of<SearchBloc>(context).add(GetSearchImagesEvent(query: query, page: currentPage + 1));
        }
        return false;
      },
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
        ),
        itemBuilder: (BuildContext s, int index) {
          return _imageBody(context: context, index: index);
        },
        itemCount: images.length,
      ),
    );
  }

  Widget _imageBody({required BuildContext context, required int index}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ImagePage.routeName, arguments: {'imageUrl': images[index].imageUrl, 'title': images[index].siteName}),
      child: _resultContainer(
        index: index,
        context: context,
      ),
    );
  }

  Widget _resultContainer({required int index, required BuildContext context}) {
    return Stack(
      children: [
        Image.network(
          images[index].thumbnailUrl,
          fit: BoxFit.cover,
        ),
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
                // 검색 Tab

                final searchBloc = context.read<sb.SearchBloc>();
                if (isSearchTab) {
                  final SearchImage selectedImage = (searchBloc.state as sb.Loaded).images[index];
                  final image = SearchImage.copyWith(image: selectedImage, isFavorited: !selectedImage.isFavorited);
                  if (image.isFavorited) {
                    searchBloc.add(sb.GetSearchImageAddFavoriteEvent(image: image));
                  } else {
                    searchBloc.add(sb.GetSearchImageRemoveFavoriteEvent(image: image));
                  }
                }

                final favoriteBloc = context.read<fb.FavoriteBloc>();
                final image = SearchImage.copyWith(image: images[index], isFavorited: !images[index].isFavorited);
                if (image.isFavorited) {
                  favoriteBloc.add(fb.GetCachedImageAddEvent(image));
                  searchBloc.add(sb.GetSearchImageAddFavoriteEvent(image: image));
                } else {
                  favoriteBloc.add(fb.GetCachedImageRemoveEvent(image));
                  searchBloc.add(sb.GetSearchImageRemoveFavoriteEvent(image: image));
                }
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
}
