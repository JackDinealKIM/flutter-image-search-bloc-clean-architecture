import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_images/core/error/failures.dart';
import 'package:search_images/domain/entities/search_image.dart';
import 'package:search_images/domain/repositories/search_image_repository.dart';
import 'package:search_images/domain/usecases/get_search_image_usecase.dart';

class MockSearchImageRepository extends Mock implements SearchImageRepository {
  @override
  Future<Either<Failure, List<SearchImage>>> getImages(Params params) async {
    Either<Failure, List<SearchImage>> images = right([]);
    return await super.noSuchMethod(
        Invocation.getter(#list), returnValue: images);
  }
}

void main() {
  late GetSearchImageUsecase usecase;
  late MockSearchImageRepository mockRepository;

  setUp(() {
    mockRepository = MockSearchImageRepository();
    usecase = GetSearchImageUsecase(mockRepository);
  });

  final tSearchImage = SearchImage(
    siteName: '네이버블로그',
    thumbnailUrl: 'https://search3.kakaocdn.net/argon/130x130_85_c/9cTdlueUGcH',
    imageUrl: 'http://postfiles10.naver.net/MjAyMDA3MDFfMTQy/MDAxNTkzNjA2NzIxMzg5.UdmxClwQUGITlk-UOzMEG8XiDWwEv9J1ob2qcmfFZVUg.DJ9ZIcMNk9BZq2Y7iVbdo_KdF8OvzDN0-V_zavDwz4Yg.JPEG.fkdin/%ED%86%A0%EB%81%BC...jpg?type=w773',
    isFavorited: false,
  );

  test(
    'Repository에서 결과 list 받아 오는 테스트',
    () async {
      final params = Params('토끼', 1);
      final tSearchImages = [tSearchImage];
      // arrange
      when(mockRepository.getImages(params)).thenAnswer((_) async => Right(tSearchImages));
      // act
      final result = await usecase(params);
      // assert
      expect(result, Right(tSearchImages));
      verify(mockRepository.getImages(params));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
