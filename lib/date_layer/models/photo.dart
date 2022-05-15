class Photo {
  String? id;
  String smallS3;
  String download;

  bool isFavourite;
  bool isDownload;

  Photo({this.id, required this.smallS3, required this.download , this.isFavourite =false ,this.isDownload = false});


  void toggleFavoriteStatus(){
    isFavourite = !isFavourite;
  }

  void toggleDownloadStatus(){
    isDownload = !isDownload;
  }
}

List<Photo> favPics = [];
List<Photo> downloadPics = [];