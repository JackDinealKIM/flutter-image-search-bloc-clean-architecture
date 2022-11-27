import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:search_images/core/error/exceptions.dart';
import '../../core/const.dart';
import '../../core/utils.dart';
import '../../domain/entities/search_image.dart';
import '../model/cached_image_model.dart';

abstract class SearchImageLocalDataSource {
  Future<List<SearchImage>> getImages();

  Future<List<SearchImage>> addImage(SearchImage image);

  Future<List<SearchImage>> removeImage(SearchImage image);
}

class SearchImageLocalDataSourceImpl implements SearchImageLocalDataSource {
  @override
  Future<List<SearchImage>> addImage(SearchImage image) async {
    try {
      final collection = await boxCollection();
      String datetime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      final cachedImage = CachedImageModel(
        siteName: image.siteName,
        thumbnailUrl: image.thumbnailUrl,
        imageUrl: image.imageUrl,
        datetime: datetime,
      );

      await collection.put(image.hashedKey, cachedImage);
      return getImages();
    } on CacheException catch (data, e) {
      throw CacheException();
    }
  }

  @override
  Future<List<SearchImage>> getImages() async {
    try {
      final collection = await boxCollection();
      final Map<String, CachedImageModel> map = await collection.getAllValues();
      // sorted images
      final sortedImages = map.values.toList();
      sortedImages.sort((a, b) => b.datetime.compareTo(a.datetime));

      return sortedImages
          .map((img) => SearchImage(
                siteName: img.siteName,
                thumbnailUrl: img.thumbnailUrl,
                imageUrl: img.imageUrl,
                isFavorited: true,
              ))
          .toList();
    } on CacheException catch (data, e) {
      throw CacheException();
    }
  }

  @override
  Future<List<SearchImage>> removeImage(SearchImage image) async {
    try {
      final collection = await boxCollection();
      await collection.delete(image.hashedKey);
      return getImages();
    } on CacheException catch (data, e) {
      throw CacheException();
    }
  }

  Future<CollectionBox<CachedImageModel>> boxCollection() async {
    return (await BoxCollection.open(
      HIVE_DATABASE,
      HIVE_BOXES,
      path: (await getApplicationDocumentsDirectory()).path,
    ))
        .openBox<CachedImageModel>(HIVE_BOX_IMAGE);
  }
}
