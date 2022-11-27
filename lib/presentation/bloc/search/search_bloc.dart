import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:search_images/domain/entities/search_image.dart';

import '../../../core/const.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_cached_image_usecase.dart';
import '../../../domain/usecases/get_search_image_usecase.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetSearchImageUsecase getSearchImageUsecase;
  final GetCachedImageUsecase getCachedImageUsecase;
  List<SearchImage> images = [];

  SearchBloc({required this.getSearchImageUsecase, required this.getCachedImageUsecase}) : super(Initial()) {
    on<SearchEvent>((event, emit) async {
      if (event is GetSearchImagesEvent) {
        if (event.page == 1) emit(Loading());
        final failureOrImages = await getSearchImageUsecase(Params(event.query, event.page));
        final failureOrCachedImages = await getCachedImageUsecase(NoParams());
        final List<SearchImage> cachedImages = await _eitherCachedOrErrorState(failureOrCachedImages: failureOrCachedImages).single;
        emit(await _eitherLoadedOrErrorState(failureOrImages: failureOrImages, cachedImages: cachedImages, page: event.page).single);
      } else if (event is GetSearchImageAddFavoriteEvent) {
        emit(await _addFavorite(image: event.image).single);
      } else if (event is GetSearchImageRemoveFavoriteEvent) {
        emit(await _removeFavorite(image: event.image).single);
      }
    });
  }

  Stream<List<SearchImage>> _eitherCachedOrErrorState({
    required Either<Failure, List<SearchImage>> failureOrCachedImages,
  }) async* {
    yield failureOrCachedImages.fold((failure) => [], (images) => images);
  }

  Stream<SearchState> _eitherLoadedOrErrorState({
    required Either<Failure, List<SearchImage>> failureOrImages,
    required List<SearchImage> cachedImages,
    required int page,
  }) async* {
    yield failureOrImages.fold(
      (failure) => Error(_mapFailureToMessage(failure)),
      (images) {
        final Set<String> cachedSet = cachedImages.map((e) => e.hashedKey).toSet();
        // 1 페이지인 경우 리셋
        if (page == 1) this.images.clear();
        this.images.addAll(images.map((img) => SearchImage.copyWith(image: img, isFavorited: cachedSet.contains(img.hashedKey))).toList());

        return Loaded(images: List.of(this.images), page: page);
      },
    );
  }

  Stream<SearchState> _addFavorite({required SearchImage image}) async* {
    images = images.map((img) => SearchImage.copyWith(image: img, isFavorited: img.hashedKey == image.hashedKey ? image.isFavorited : img.isFavorited)).toList();
    yield Loaded(images: List.of(images));
  }

  Stream<SearchState> _removeFavorite({required SearchImage image}) async* {
    images = images.map((img) => SearchImage.copyWith(image: img, isFavorited: img.hashedKey == image.hashedKey ? image.isFavorited : img.isFavorited)).toList();
    yield Loaded(images: List.of(images));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
