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

  Loaded copyWith({
    List<SearchImage>? images,
    int? page,
  }) {
    return Loaded(
      images: images ?? this.images,
      page: page ?? this.page,
    );
  }

  Loaded copyWithAppend({
    required List<SearchImage> images,
    int? page,
  }) {
    this.images.addAll(images);
    return Loaded(
      images: this.images,
      page: page ?? this.page,
    );
  }
}

class Error extends SearchState {
  final String message;


  Error(this.message);

  @override
  List<Object> get props => [message];
}
