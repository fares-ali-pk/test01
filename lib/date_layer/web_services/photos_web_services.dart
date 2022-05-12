import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test01/date_layer/models/photo.dart';
import 'package:test01/utilities/api_utilities.dart';

class PhotosWebServices {
  Future<List<Photo>> fetchAllPhotos({
    required int page,
    required int limit,
  }) async {
    List<Photo> photos = [];

    String allPhotosApi =
        base_api + get_photos_api + "?page=$page&per_page=$limit&" + client_id;

    http.Response response = await http.get(Uri.parse(allPhotosApi));

    //print("statusCode is: ${response.statusCode}");

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      for (var item in jsonData) {
        var id = item["id"];
        var url = item["urls"]["small_s3"];
        var download = item["links"]["download"];

        Photo photo = Photo(
          id: (id == null) ? null : id.toString(),
          smallS3: (url == null) ? "assets/images/noImage.png" : url.toString(),
          download: (download == null) ? null : download.toString(),
        );
        photos.add(photo);
      }
    }
    return [];
  }
}
