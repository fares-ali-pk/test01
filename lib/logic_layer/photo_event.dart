part of 'photo_bloc.dart';

@immutable
abstract class PhotoEvent {}

class PhotoFetched extends PhotoEvent{
  String? query;

  PhotoFetched({this.query});
}

//class SearchPhotoFetched extends PhotoEvent{}
