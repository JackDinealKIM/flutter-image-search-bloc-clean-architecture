import 'package:dartz/dartz.dart';
import 'package:search_images/core/error/failures.dart';
import 'package:search_images/data/datasources/search_image_remote_data_source.dart';
import 'package:search_images/data/model/search_image_model.dart';
import 'package:search_images/domain/entities/search_image.dart';

import '../../domain/repositories/search_image_repository.dart';

class SearchImageRepositoryImpl extends SearchImageRepository {
  final SearchImageRemoteDataSource dataSource;

  SearchImageRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<SearchImage>>> getImages(String query) async {
    try {
      final List<SearchImageModel> remoteImages = await dataSource.getImages(query);
      return Right(remoteImages.map((image) => SearchImage.fromJson(image)).toList());
    } catch(e) {
      return Left(ServerFailure());
    }
  }
}
