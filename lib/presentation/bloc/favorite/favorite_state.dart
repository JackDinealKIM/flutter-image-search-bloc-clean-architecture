part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteState extends Equatable {}

class Initial extends FavoriteState {
  @override
  List<Object> get props => [];
}

class Loading extends FavoriteState {
  @override
  List<Object> get props => [];
}

class Loaded extends FavoriteState {
  final List<SearchImage> images;

  Loaded({required this.images});

  Loaded update(List<SearchImage> list) => Loaded(images: list);

  @override
  List<Object> get props => [images];
}

class Error extends FavoriteState {
  final String message;

  Error(this.message);

  @override
  List<Object> get props => [message];
}
