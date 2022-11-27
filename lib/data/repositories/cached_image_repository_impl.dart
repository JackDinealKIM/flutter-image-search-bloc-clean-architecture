import 'package:dartz/dartz.dart';
import 'package:search_images/core/error/failures.dart';
import 'package:search_images/domain/entities/search_image.dart';
import '../../domain/repositories/cached_image_repository.dart';
import '../datasources/search_image_local_data_source.dart';
import '../model/cached_image_model.dart';

class CachedImageRepositoryImpl extends CachedImageRepository {
  final SearchImageLocalDataSource dataSource;

  CachedImageRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<SearchImage>>> addImage(SearchImage image) async {
    try {
      final succesful = await dataSource.addImage(image);
      return Right(succesful);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<SearchImage>>> getImages() async {
    try {
      final List<SearchImage> localImages = await dataSource.getImages();
      return Right(localImages.map((image) => SearchImage.fromJsonSearch(image)).toList());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<SearchImage>>> removeImage(SearchImage image) async {
    try {
      final succesful = await dataSource.removeImage(image);
      return Right(succesful);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
