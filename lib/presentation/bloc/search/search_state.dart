part of 'search_bloc.dart';

abstract class SearchState extends Equatable {}

class Initial extends SearchState {
  @override
  List<Object> get props => [];
}

class Loading extends SearchState {
  @override
  List<Object> get props => [];
}

class Loaded extends SearchState {
  final List<SearchImage> images;
  final int page;

  Loaded({required this.images, this.page = 1});

  @override
  List<Object> get props => [images, page];
}

class Error extends SearchState {
  final String message;

  Error(this.message);

  @override
  List<Object> get props => [message];
}
