part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {}

class GetSearchImagesEvent extends SearchEvent {
  final String query;

  GetSearchImagesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class UpdateSearchImageEvent extends SearchEvent {
  final SearchImage image;
  final int index;

  UpdateSearchImageEvent({required this.image, required this.index});

  @override
  List<Object?> get props => [];
}
