import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/search_image.dart';


abstract class SearchImageRepository {
  Future<Either<Failure, List<SearchImage>>> getImages(String query);
}