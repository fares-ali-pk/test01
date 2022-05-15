import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:test01/date_layer/repository/photos_repository.dart';
import 'package:test01/date_layer/web_services/photos_web_services.dart';
import 'package:test01/date_layer/web_services/search_photos_web_services.dart';
import 'package:test01/presentation_layer/screens/downloaded_pictures_screen.dart';
import 'package:test01/presentation_layer/screens/favorite_pictures_screen.dart';
import 'package:test01/presentation_layer/screens/list_of_patients_screen.dart';
import 'package:test01/presentation_layer/widgets/no_connection_widget.dart';
import 'package:test01/utilities/widget_utilities.dart';
import 'presentation_layer/screens/home_screen.dart';
import 'logic_layer/photo_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (BuildContext context) => PhotoBloc(
          photosRepository: PhotosRepository(
            photosWebServices: PhotosWebServices(),
          ),
        )..add(PhotoFetched()),
        child: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (connected) {
              return HomeScreen();
            } else {
              return const NoConnectionWidget();
            }
          },
          child: loading(),
        ),
      ),
    );
  }
}

/*
BlocProvider(
        create: (BuildContext context) =>
            PhotoBloc(photosRepository: PhotosRepository(PhotosWebServices()))..add(PhotoFetched()),
        child: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (connected) {
              return  Container();
            } else {
              return const NoConnectionWidget();
            }
          },
          child: loading(),
        ),
      ),
 */
