import 'package:equatable/equatable.dart';
import 'package:search_images/data/model/search_image_model.dart';

import '../../core/utils.dart';
import '../../data/model/cached_image_model.dart';

class SearchImage extends Equatable {
  final String siteName;
  final String thumbnailUrl;
  final String imageUrl;
  final bool isFavorited;

  const SearchImage({
    required this.siteName,
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.isFavorited,
  });

  String get hashedKey => stringToMd5(thumbnailUrl);

  factory SearchImage.copyWith({required SearchImage image, required bool isFavorited}) {
    return SearchImage(
      siteName: image.siteName,
      thumbnailUrl: image.thumbnailUrl,
      imageUrl: image.imageUrl,
      isFavorited: isFavorited,
    );
  }

  factory SearchImage.fromJson(SearchImageModel searchImageModel) {
    return SearchImage(
      siteName: searchImageModel.display_sitename,
      thumbnailUrl: searchImageModel.thumbnail_url,
      imageUrl: searchImageModel.image_url,
      isFavorited: false,
    );
  }

  factory SearchImage.fromJsonCached(CachedImageModel cachedImageModel) {
    return SearchImage(
      siteName: cachedImageModel.siteName,
      thumbnailUrl: cachedImageModel.thumbnailUrl,
      imageUrl: cachedImageModel.imageUrl,
      isFavorited: true,
    );
  }

  factory SearchImage.fromJsonSearch(SearchImage image) {
    return SearchImage(
      siteName: image.siteName,
      thumbnailUrl: image.thumbnailUrl,
      imageUrl: image.imageUrl,
      isFavorited: image.isFavorited,
    );
  }

  @override
  List<Object?> get props => [siteName, thumbnailUrl, imageUrl, isFavorited];
}
