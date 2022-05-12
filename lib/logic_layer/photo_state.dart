part of 'photo_bloc.dart';

enum PhotoStatus { initial, success, failure }

class PhotoState {
  final PhotoStatus status;
  final List<Photo> photos;
  final bool hasReachedMax;

  PhotoState(
      {this.status = PhotoStatus.initial,
      this.photos = const <Photo>[],
      this.hasReachedMax = false});

  PhotoState copyWith({
    PhotoStatus? status,
    List<Photo>? photos,
    bool? hasReachedMax,
  }) {
    return PhotoState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  // @override
  // String toString() {
  //   return '''PhotoState { status: $status, hasReachedMax: $hasReachedMax, photos: ${photos.length} }''';
  // }
  //
  // List<Object> get props => [status, photos, hasReachedMax];
}
