import 'package:test01/date_layer/models/photo.dart';
import 'package:test01/date_layer/web_services/photos_web_services.dart';
import 'package:test01/date_layer/web_services/search_photos_web_services.dart';

class PhotosRepository {

  final PhotosWebServices? photosWebServices;
  final SearchPhotosWebServices? searchPhotosWebServices;


  PhotosRepository({this.photosWebServices , this.searchPhotosWebServices});

  Future<List<Photo>> fetchAllPhotos({required int page , required int limit , String? query}) async {
    if(query == null){
      return await photosWebServices!.fetchAllPhotos(page: page ,limit: limit);
    }
    else {
      return await searchPhotosWebServices!.fetchSearchPhotos(page: page, limit: limit, query: query);
    }
  }

}