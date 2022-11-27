import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/search_image.dart';
import '../repositories/cached_image_repository.dart';

class GetCachedImageUsecase implements UseCase<List<SearchImage>, NoParams> {
  final CachedImageRepository repository;

  GetCachedImageUsecase(this.repository);

  @override
  Future<Either<Failure, List<SearchImage>>> call(NoParams params) async {
    return await repository.getImages();
  }
}
