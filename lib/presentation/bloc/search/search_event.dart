part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {}

class GetSearchImages extends SearchEvent {
  final String query;

  GetSearchImages(this.query);

  @override
  List<Object?> get props => [query];
}
