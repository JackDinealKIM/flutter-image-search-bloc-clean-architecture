import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:search_images/domain/entities/search_image.dart';

import '../../../core/const.dart';
import '../../../core/error/failures.dart';
import '../../../core/log.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils.dart';
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
        emit(Loading());
        final failureOrImages = await getSearchImageUsecase(Params(event.query));
        final failureOrCachedImages = await getCachedImageUsecase(NoParams());
        final List<SearchImage> cachedImages = await _eitherCachedOrErrorState(failureOrCachedImages: failureOrCachedImages).single;
        emit(await _eitherLoadedOrErrorState(failureOrImages: failureOrImages, cachedImages: cachedImages).single);
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
  }) async* {
    yield failureOrImages.fold(
      (failure) => Error(_mapFailureToMessage(failure)),
      (images) {
        final Set<String> cachedSet = cachedImages.map((e) => e.hashedKey).toSet();
        this.images = images
            .map((img) => SearchImage.copyWith(
                image: img,
                isFavorited: cachedSet.contains(img.hashedKey)))
            .toList();
        return Loaded(images: List.of(this.images));
      },
    );
  }

  Stream<SearchState> _addFavorite({required SearchImage image}) async* {
    List<SearchImage> list = images.map((img) => SearchImage.copyWith(image: img, isFavorited: img.hashedKey == image.hashedKey ? true : img.isFavorited)).toList();
    yield Loaded(images: list);
  }

  Stream<SearchState> _removeFavorite({required SearchImage image}) async* {
    List<SearchImage> list = images.map((img) => SearchImage.copyWith(image: img, isFavorited: img.hashedKey == image.hashedKey ? false : img.isFavorited)).toList();
    yield Loaded(images: list);
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
