import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/search_image.dart';


abstract class CachedImageRepository {
  Future<Either<Failure, List<SearchImage>>> getImages();
  Future<Either<Failure, List<SearchImage>>> addImage(SearchImage image);
  Future<Either<Failure, List<SearchImage>>> removeImage(SearchImage image);
}