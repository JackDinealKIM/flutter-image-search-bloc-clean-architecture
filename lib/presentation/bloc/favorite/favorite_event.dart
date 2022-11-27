part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteEvent extends Equatable {}

class GetCachedImagesEvent extends FavoriteEvent {

  GetCachedImagesEvent();

  @override
  List<Object?> get props => [];
}

class GetCachedImageAddEvent extends FavoriteEvent {
  final SearchImage image;

  GetCachedImageAddEvent(this.image);

  @override
  List<Object?> get props => [];
}

class GetCachedImageRemoveEvent extends FavoriteEvent {
  final SearchImage image;

  GetCachedImageRemoveEvent(this.image);

  @override
  List<Object?> get props => [];
}