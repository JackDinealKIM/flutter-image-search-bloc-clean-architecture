part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {}

class GetSearchImagesEvent extends SearchEvent {
  final String query;

  GetSearchImagesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class GetSearchImageAddFavoriteEvent extends SearchEvent {
  final SearchImage image;

  GetSearchImageAddFavoriteEvent({required this.image});

  @override
  List<Object?> get props => [image];
}

class GetSearchImageRemoveFavoriteEvent extends SearchEvent {
  final SearchImage image;

  GetSearchImageRemoveFavoriteEvent({required this.image});

  @override
  List<Object?> get props => [image];
}
