import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:search_images/domain/entities/search_image.dart';

import '../../../core/const.dart';
import '../../../core/error/failures.dart';
import '../../../domain/usecases/get_search_image_usecase.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetSearchImageUsecase getSearchImageUsecase;

  SearchBloc({required this.getSearchImageUsecase}) : super(Empty()) {
    on<SearchEvent>((event, emit) async {
      if (event is GetSearchImages) {
        emit(Loading());
        final failureOrImages = await getSearchImageUsecase(Params(event.query));
        emit(await _eitherLoadedOrErrorState(failureOrImages, event.query).single);
      }
    });
  }

  Stream<SearchState> _eitherLoadedOrErrorState(Either<Failure, List<SearchImage>> either, String query) async* {
    yield either.fold(
      (failure) => Error(_mapFailureToMessage(failure)),
      (images) => Loaded(images: images, query: query),
    );
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
