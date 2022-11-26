import 'package:dio/dio.dart';
import 'package:search_images/core/error/exceptions.dart';
import 'package:search_images/data/model/search_image_model.dart';

import '../../core/const.dart';

abstract class SearchImageRemoteDataSource {
  Future<List<SearchImageModel>> getImages(String query);
}

class SearchImageRemoteDataSourceImpl implements SearchImageRemoteDataSource {
  final Dio dio;

  SearchImageRemoteDataSourceImpl(this.dio);

  @override
  Future<List<SearchImageModel>> getImages(String query) async {
    try {
      final response = await dio.get(
        '$KAKAO_SEARCH_URL$query',
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
