import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:search_images/core/const.dart';
import 'package:search_images/core/error/exceptions.dart';
import 'package:search_images/data/datasources/search_image_remote_data_source.dart';
import 'package:search_images/data/model/search_image_model.dart';
import 'package:search_images/domain/usecases/get_search_image_usecase.dart';
import '../../fixtures/fixture_reader.dart';

void main() {
  late SearchImageRemoteDataSourceImpl dataSource;
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() {
    dio = Dio();
    dio = Dio(BaseOptions(baseUrl: BASE_URL));
    dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;
    dataSource = SearchImageRemoteDataSourceImpl(
      dio: dio,
    );
  });

  group('카카오 검색 API Mock 테스트', () {
    test("'documents' 모델이 있는지 테스트 200", () async {
      final List<SearchImageModel> tSearchImageModels = (json.decode(fixture('토끼.json'))['documents'] as Iterable).map((e) => SearchImageModel.fromJson(e)).toList();

      dioAdapter.onGet(
        KAKAO_SEARCH_URL,
        (request) => request.reply(200, json.decode(fixture('토끼.json'))),
      );

      final result = await dataSource.getImages(const Params('토끼', 1));

      expect(result.length, equals(tSearchImageModels.length));
      // 검색결과가 1개라도 있는지 체크
      expect(result.length, greaterThan(1));
    });

    test("dio 오류가 발생했을때 ,DioException 400 에러 테스트", () async {
      final dioError = DioError(
        error: {'message': 'error!'},
        requestOptions: RequestOptions(path: KAKAO_SEARCH_URL),
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: KAKAO_SEARCH_URL),
        ),
        type: DioErrorType.response,
      );

      dioAdapter.onGet(
        KAKAO_SEARCH_URL,
        (request) => request.throws(400, dioError),
      );

      expect(() => dataSource.getImages(const Params('토끼', 1)), throwsA(const TypeMatcher<DioException>()));
    });

    test("dio 오류가 발생했을때, ParseException 에러 테스트(응답 데이터가 잘 못된 경우)", () async {
      dioAdapter.onGet(
        KAKAO_SEARCH_URL,
            (request) => request.reply(200, {}),
      );

      expect(() => dataSource.getImages(const Params('토끼', 1)), throwsA(const TypeMatcher<ParseException>()));
    });
  });
}
