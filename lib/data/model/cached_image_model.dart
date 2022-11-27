import 'package:hive/hive.dart';

part 'cached_image_model.g.dart';


@HiveType(typeId: 0)
class CachedImageModel {
  @HiveField(0)
  final String siteName;
  @HiveField(1)
  final String thumbnailUrl;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final String datetime;

  CachedImageModel({
    required this.siteName,
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.datetime,
  });
}
