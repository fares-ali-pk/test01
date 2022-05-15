import 'dart:isolate';
import 'dart:ui';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/material.dart';
import 'package:test01/date_layer/models/photo.dart';
import 'package:test01/utilities/my_colors.dart';

class PhotoGrid extends StatefulWidget {
  final Photo photo;

  const PhotoGrid({Key? key, required this.photo}) : super(key: key);

  @override
  State<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  bool stillDownload = false;
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    //_port.listen(stateDownloaded);

    FlutterDownloader.registerCallback(downloadCallback);
  }

  // void stateDownloaded(dynamic data) {
  //   String id = data[0];
  //   DownloadTaskStatus status = data[1];
  //   int progress = data[2];
  //
  //   if ((status == DownloadTaskStatus.running) ||
  //       (status == DownloadTaskStatus.enqueued)) {
  //     print("DownloadTaskStatus.runninggggggggggggggg");
  //     stillDownload = true;
  //   } else if (status == DownloadTaskStatus.complete) {
  //     print("Downloaded completeddddddddd");
  //     stillDownload = false;
  //
  //   } else if ((status == DownloadTaskStatus.canceled) ||
  //       (status == DownloadTaskStatus.failed)) {
  //     print("DownloadTaskStatus.faileddddddddddd");
  //     stillDownload = false;
  //   } else if ((status == DownloadTaskStatus.undefined)) {
  //     print("DownloadTaskStatus.undefineddddddddd");
  //   }
  //
  //   setState(() {});
  // }

  @override
  void dispose() {
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: GridTile(
        child: Container(
          child: (widget.photo.smallS3 == "assets/images/noImage.png")
              ? Image.asset('assets/images/noImage.png')
              : FadeInImage.assetNetwork(
                  placeholder: 'assets/images/loading.gif',
                  image: widget.photo.smallS3,
                  fit: BoxFit.cover,
                ),
        ),
        footer: Container(
          color: Colors.white54,
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _favButton(),
              _downloadButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _favButton() {
    return IconButton(
      onPressed: () {
        if (widget.photo.isFavourite) {
          favPics.removeWhere((element) => element.id == widget.photo.id);
        } else {
          favPics.add(widget.photo);
        }
        widget.photo.toggleFavoriteStatus();
        setState(() {
        });
      },
      icon: widget.photo.isFavourite
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_border),
      color: MyColor.myPink,
      iconSize: 32.0,
    );
  }

  Widget _downloadButton() {
    return (widget.photo.download == "no url")
        ? const Icon(
            Icons.close,
            color: MyColor.myPink,
            size: 32,
          )
        : (widget.photo.isDownload)
            ? const Icon(
                Icons.download_done,
                color: MyColor.myPink,
                size: 32,
              )
            : IconButton(
                    onPressed: () async {
                      var status = await Permission.storage.request();
                      if (status.isGranted) {
                        final baseStorage = await getExternalStorageDirectory();
                        await FlutterDownloader.enqueue(
                          url: widget.photo.download,
                          savedDir: baseStorage!.path,
                          // show download progress in status bar (for Android)
                          showNotification: true,
                          // click on notification to open downloaded file (for Android)
                          openFileFromNotification: true,
                        );

                        downloadPics.add(widget.photo);
                        widget.photo.toggleDownloadStatus();
                        setState(() {
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.download,
                      color: MyColor.myPink,
                      size: 32,
                    ),
                  );
  }
}
