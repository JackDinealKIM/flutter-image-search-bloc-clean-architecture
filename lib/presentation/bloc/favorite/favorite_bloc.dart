import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/const.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/search_image.dart';
import '../../../domain/usecases/get_cached_image_add_usecase.dart';
import '../../../domain/usecases/get_cached_image_remove_usecase.dart';
import '../../../domain/usecases/get_cached_image_usecase.dart';

part 'favorite_event.dart';

part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetCachedImageUsecase getCachedImageUsecase;
  final GetCachedImageAddUsecase getCachedImageAddUsecase;
  final GetCachedImageRemoveUsecase getCachedImageRemoveUsecase;

  FavoriteBloc({
    required this.getCachedImageUsecase,
    required this.getCachedImageAddUsecase,
    required this.getCachedImageRemoveUsecase,
  }) : super(Initial()) {
    on<FavoriteEvent>((event, emit) async {
      if (event is GetCachedImagesEvent) {
        emit(Loading());
        final failureOrImages = await getCachedImageUsecase(NoParams());
        emit(await _eitherLoadedOrErrorState(failureOrImages).single);
      } else if (event is GetCachedImageAddEvent) {
        final failureOrImages = await getCachedImageAddUsecase(event.image);
        emit(await _eitherAddOrErrorState(failureOrImages).single);
      } else if (event is GetCachedImageRemoveEvent) {
        final failureOrImages = await getCachedImageRemoveUsecase(event.image);
        emit(await _eitherRemoveOrErrorState(failureOrImages).single);
      }
    });
  }

  Stream<FavoriteState> _eitherLoadedOrErrorState(Either<Failure, List<SearchImage>> either) async* {
    yield either.fold(
      (failure) => Error(_mapFailureToMessage(failure)),
      (images) => Loaded(images: images),
    );
  }

  Stream<FavoriteState> _eitherAddOrErrorState(Either<Failure, List<SearchImage>> either) async* {
    yield either.fold(
      (failure) => Error(_mapFailureToMessage(failure)),
      (images) {
        // TODO : add logic
        // get from hive
        return Loaded(images: images);
      },
    );
  }

  Stream<FavoriteState> _eitherRemoveOrErrorState(Either<Failure, List<SearchImage>> either) async* {
    yield either.fold(
      (failure) => Error(_mapFailureToMessage(failure)),
      (images) {
        // TODO : remove logic
        // get from hive
        return Loaded(images: images);
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return LOCAL_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
