import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:search_images/domain/repositories/search_image_repository.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/search_image.dart';

class GetSearchImageUsecase implements UseCase<List<SearchImage>, Params> {
  final SearchImageRepository repository;

  GetSearchImageUsecase(this.repository);

  @override
  Future<Either<Failure, List<SearchImage>>> call(Params params) async {
    return await repository.getImages(params.query);
  }
}

class Params extends Equatable {
  final String query;

  const Params({required this.query});

  @override
  List<Object?> get props => [query];
}
