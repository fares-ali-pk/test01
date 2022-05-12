import 'package:flutter/material.dart';
import 'package:test01/date_layer/models/photo.dart';

class PhotoGrid extends StatelessWidget {
  final Photo photo;

  const PhotoGrid({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Container(
        child: (photo.smallS3 == "assets/images/noImage.png")
            ? Image.asset('assets/images/noImage.png')
            : FadeInImage.assetNetwork(
                placeholder: 'assets/images/loading.gif',
                image: photo.smallS3,
                fit: BoxFit.cover,
              ),
      ),
      footer: Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  photo.toggleFavoriteStatus();
                },
                icon: photo.isFavourite
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border)),
            IconButton(
                onPressed: () {
                  if (!photo.isDownload) {
                    photo.toggleDownloadStatus();
                  }
                },
                icon: photo.isDownload
                    ? const Icon(Icons.download_done)
                    : const Icon(Icons.download)),
          ],
        ),
      ),
    );
  }
}
