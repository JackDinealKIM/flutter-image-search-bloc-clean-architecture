import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_images/core/const.dart';
import 'package:search_images/core/error/failures.dart';
import 'package:search_images/core/usecases/usecase.dart';
import 'package:search_images/domain/entities/search_image.dart';
import 'package:search_images/domain/repositories/cached_image_repository.dart';
import 'package:search_images/domain/repositories/search_image_repository.dart';
import 'package:search_images/domain/usecases/get_cached_image_usecase.dart';
import 'package:search_images/domain/usecases/get_search_image_usecase.dart';
import 'package:search_images/presentation/bloc/search/search_bloc.dart';

// https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md
class MockSearchImageRepository extends Mock implements SearchImageRepository {
  Either<Failure, List<SearchImage>> images = right([]);
  @override
  Future<Either<Failure, List<SearchImage>>> call(NoParams params) async {
    return images;
  }
}
class MockCachedImageRepository extends Mock implements CachedImageRepository {
  Either<Failure, List<SearchImage>> images = right([]);

  @override
  Future<Either<Failure, List<SearchImage>>> call(Params params) async {
    return images;
  }
}

void main() {
  late SearchBloc bloc;
  late GetSearchImageUsecase getSearchImageUsecase;
  late GetCachedImageUsecase getCachedImageUsecase;
  late MockCachedImageRepository mockCachedImageRepository;
  late MockSearchImageRepository mockSearchImageRepository;

  const params = Params('토끼', 1);

  setUp(() {
    mockCachedImageRepository = MockCachedImageRepository();
    mockSearchImageRepository = MockSearchImageRepository();
    getSearchImageUsecase = GetSearchImageUsecase(mockSearchImageRepository);
    getCachedImageUsecase = GetCachedImageUsecase(mockCachedImageRepository);

    bloc = SearchBloc(
      getSearchImageUsecase: getSearchImageUsecase,
      getCachedImageUsecase: getCachedImageUsecase,
    );
  });

  group('Search Bloc 테스트', () {
    const tSearchImages = [
      SearchImage(
        siteName: '네이버블로그',
        thumbnailUrl: 'https://search3.kakaocdn.net/argon/130x130_85_c/9cTdlueUGcH',
        imageUrl: 'http://postfiles10.naver.net/MjAyMDA3MDFfMTQy/MDAxNTkzNjA2NzIxMzg5.UdmxClwQUGITlk-UOzMEG8XiDWwEv9J1ob2qcmfFZVUg.DJ9ZIcMNk9BZq2Y7iVbdo_KdF8OvzDN0-V_zavDwz4Yg.JPEG.fkdin/%ED%86%A0%EB%81%BC...jpg?type=w773',
        isFavorited: false,
      )
    ];

    test(
      '데이터 가져오기 from SearchImageUsecase',
      () async {
        // arrange
        when(mockSearchImageRepository.getImages(params)).thenAnswer((_) async => Right(tSearchImages));
        // act
        bloc.add(GetSearchImagesEvent(query: params.query, page: params.page));
        await untilCalled(getSearchImageUsecase(params));
        // assert
        verify(getSearchImageUsecase(params));
      },
    );

    test(
      'emit [Loading, Loaded] 성공 테스트',
      () async {
        // arrange
        when(mockSearchImageRepository.getImages(params)).thenAnswer((_) async => Right(tSearchImages));
        // assert later
        final expected = [
          Initial(),
          Loading(),
          Loaded(images: tSearchImages),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetSearchImagesEvent(query: params.query, page: params.page));
      },
    );

    test(
      'emit [Loading, Error] 실패 테스트',
      () async {
        // arrange
        when(mockSearchImageRepository.getImages(params)).thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Initial(),
          Loading(),
          Error(SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetSearchImagesEvent(query: params.query, page: params.page));
      },
    );
  });
}
