import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/search_image.dart';
import '../repositories/cached_image_repository.dart';

class GetCachedImageAddUsecase implements UseCase<void, SearchImage> {
  final CachedImageRepository repository;

  GetCachedImageAddUsecase(this.repository);

  @override
  Future<Either<Failure, List<SearchImage>>> call(SearchImage image) async {
    return await repository.addImage(image);
  }
}
