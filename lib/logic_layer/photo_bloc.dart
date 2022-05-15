import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test01/date_layer/models/photo.dart';
import 'package:test01/date_layer/repository/photos_repository.dart';
import 'package:test01/date_layer/web_services/photos_web_services.dart';

part 'photo_event.dart';

part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotosRepository photosRepository;

  int page = 1;
  int limit;



  PhotoBloc(
      {required this.photosRepository, this.limit = 10,})
      : super(PhotoState()) {
    on<PhotoFetched>(_onPhotoFetched);
  }

  FutureOr<void> _onPhotoFetched(
      PhotoFetched event, Emitter<PhotoState> emit) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == PhotoStatus.initial) {
        final photos = await photosRepository.fetchAllPhotos(
          page: page,
          limit: limit,
          query: event.query,
        );
        return emit(state.copyWith(
          status: PhotoStatus.success,
          photos: photos,
          hasReachedMax: false,
        ));
      }

      page += 1;
      final photos = await photosRepository.fetchAllPhotos(
        page: page,
        limit: limit,
        query: event.query,
      );
      photos.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(state.copyWith(
              status: PhotoStatus.success,
              photos: List.of(state.photos)..addAll(photos),
              hasReachedMax: false,
            ));
    } catch (_) {
      emit(state.copyWith(status: PhotoStatus.failure));
    }
  }
}
