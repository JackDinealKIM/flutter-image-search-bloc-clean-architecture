import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_images/data/datasources/search_image_remote_data_source.dart';
import 'package:search_images/data/model/search_image_model.dart';
import 'package:search_images/data/repositories/search_image_repository_impl.dart';
import 'package:search_images/domain/entities/search_image.dart';
import 'package:search_images/domain/usecases/get_search_image_usecase.dart';

class MockSearchImageRemoteDataSource extends Mock implements SearchImageRemoteDataSource {
  @override
  Future<List<SearchImageModel>> getImages(Params params) async {
    return await super.noSuchMethod(
        Invocation.getter(#list), returnValue: <SearchImageModel>[]);
  }
}

void main() {
  late SearchImageRepositoryImpl repository;
  late MockSearchImageRemoteDataSource dataSource;

  setUp(() {
    dataSource = MockSearchImageRemoteDataSource();
    repository = SearchImageRepositoryImpl(dataSource: dataSource);
  });

  const tSearchImageModel = SearchImageModel(
    display_sitename: '네이버블로그',
    thumbnail_url: 'https://search3.kakaocdn.net/argon/130x130_85_c/9cTdlueUGcH',
    image_url: 'http://postfiles10.naver.net/MjAyMDA3MDFfMTQy/MDAxNTkzNjA2NzIxMzg5.UdmxClwQUGITlk-UOzMEG8XiDWwEv9J1ob2qcmfFZVUg.DJ9ZIcMNk9BZq2Y7iVbdo_KdF8OvzDN0-V_zavDwz4Yg.JPEG.fkdin/%ED%86%A0%EB%81%BC...jpg?type=w773',
  );

  group('검색 repository 테스트', () {
    test(
      'Remote Data가 정상적으로 수신 되는지 테스트',
      () async {
        // arrange
        const params = Params('토끼', 1);
        when(dataSource.getImages(params)).thenAnswer((_) async => [tSearchImageModel]);
        // act
        final result = await repository.getImages(params);
        // assert
        verify(repository.getImages(params));

        final SearchImage tSearchImage = SearchImage(
          siteName: tSearchImageModel.display_sitename,
          thumbnailUrl: tSearchImageModel.thumbnail_url,
          imageUrl: tSearchImageModel.image_url,
          isFavorited: false,
        );
        final resultImages = result.getOrElse(() => []);
        expect(resultImages, equals([tSearchImage]));
      },
    );
  });
}
