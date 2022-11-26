import 'package:equatable/equatable.dart';
import 'package:search_images/data/model/search_image_model.dart';

class SearchImage extends Equatable {
  final String siteName;
  final String thumbnailUrl;
  final String imageUrl;
  final bool isFavorited;
  final DateTime dateTime;

  const SearchImage({
    required this.siteName,
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.isFavorited,
    required this.dateTime,
  });

  factory SearchImage.copyWith(SearchImage image) {
    return SearchImage(
      siteName: image.siteName,
      thumbnailUrl: image.thumbnailUrl,
      imageUrl: image.imageUrl,
      isFavorited: !image.isFavorited,
      dateTime: image.dateTime,
    );
  }

  factory SearchImage.fromJson(SearchImageModel searchImageModel) {
    return SearchImage(
      siteName: searchImageModel.display_sitename,
      thumbnailUrl: searchImageModel.thumbnail_url,
      imageUrl: searchImageModel.image_url,
      isFavorited: false,
      dateTime: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [siteName, thumbnailUrl, imageUrl, isFavorited, dateTime];
}
