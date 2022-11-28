import 'package:dio/dio.dart';
import 'package:search_images/core/error/exceptions.dart';
import 'package:search_images/data/model/search_image_model.dart';
import '../../core/const.dart';
import '../../domain/usecases/get_search_image_usecase.dart';

abstract class SearchImageRemoteDataSource {
  Future<List<SearchImageModel>> getImages(Params params);
}

class SearchImageRemoteDataSourceImpl implements SearchImageRemoteDataSource {
  final Dio dio;

  SearchImageRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SearchImageModel>> getImages(Params params) async {
    try {
      final response = await dio.get(
        KAKAO_SEARCH_URL,
        queryParameters: {'query' : params.query, 'page' : params.page},
        options: Options(
          headers: {
            "Authorization": KAKAO_AUTHORIZATION,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        try {
          var result = response.data['documents'] as Iterable;
          return result.map((e) => SearchImageModel.fromJson(e)).toList();
        } catch (e) {
          throw ParseException();
        }
      } else {
        throw ServerException();
      }
    } on DioError catch (data, e) {
      throw DioException();
    }
  }
}
