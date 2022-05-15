import 'package:test01/date_layer/models/photo.dart';
import 'package:test01/utilities/api_utilities.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchPhotosWebServices {
  Future<List<Photo>> fetchSearchPhotos({
    required int page,
    required int limit,
    required String query,
  }) async {

    List<Photo> searchPhotos = [];

    String allSearchPhotosApi =
        base_api + search_photos_api + "?page=$page&per_page=$limit&query=query&" + client_id;

    http.Response response = await http.get(Uri.parse(allSearchPhotosApi));

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
          download: (download == null) ? "no url" : download.toString(),
        );
        searchPhotos.add(photo);
      }
    }
    return searchPhotos;
  }
}