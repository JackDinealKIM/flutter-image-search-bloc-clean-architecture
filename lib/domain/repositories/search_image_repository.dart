import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/search_image.dart';
import '../usecases/get_search_image_usecase.dart';


abstract class SearchImageRepository {
  Future<Either<Failure, List<SearchImage>>> getImages(Params params);
}