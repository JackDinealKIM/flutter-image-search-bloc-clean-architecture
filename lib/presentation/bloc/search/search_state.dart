part of 'search_bloc.dart';

abstract class SearchState extends Equatable {}

class Empty extends SearchState {
  @override
  List<Object> get props => [];
}

class Loading extends SearchState {
  @override
  List<Object> get props => [];
}

class Loaded extends SearchState {
  final List<SearchImage> images;
  final String query;

  Loaded({required this.images, required this.query});

  @override
  List<Object> get props => [images, query];
}

class Error extends SearchState {
  final String message;

  Error(this.message);

  @override
  List<Object> get props => [message];
}
