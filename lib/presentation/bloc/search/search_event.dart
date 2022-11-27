part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {}

class GetSearchImagesEvent extends SearchEvent {
  final String query;
  final int page;

  GetSearchImagesEvent({required this.query, this.page = 1});

  @override
  List<Object?> get props => [query, page];
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
