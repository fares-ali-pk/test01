import 'package:test01/date_layer/models/photo.dart';
import 'package:test01/date_layer/web_services/photos_web_services.dart';

class PhotosRepository {

  late final PhotosWebServices _photosWebServices;


  PhotosRepository(this._photosWebServices);

  Future<List<Photo>> fetchAllPhotos({required int page , required int limit}) async =>
      await _photosWebServices.fetchAllPhotos(page: page ,limit: limit);
}