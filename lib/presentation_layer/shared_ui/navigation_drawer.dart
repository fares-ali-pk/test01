import 'package:flutter/material.dart';
import 'package:test01/presentation_layer/screens/downloaded_pictures_screen.dart';
import 'package:test01/presentation_layer/screens/favorite_pictures_screen.dart';
import 'package:test01/presentation_layer/screens/list_of_patients_screen.dart';
import 'package:test01/utilities/my_colors.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late final List<NavMenuItems> _navigationMenu = [
    NavMenuItems("Favorite Pictures", () => const FavPicsScreen()),
    NavMenuItems("Downloaded Pictures", () => const DownloadedPicturesScreen()),
    NavMenuItems(
        "List of waiting patients", () => const ListOfPatientsScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: MyColor.myGrey,
      child: Padding(
        padding: const EdgeInsets.only(top: 72, left: 24),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  _navigationMenu[index].title,
                  style: const TextStyle(
                    color: MyColor.myWhite,
                    fontSize: 22,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: MyColor.myWhite,
                  size: 32.0,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            _navigationMenu[index].destination(),
                      ));
                },
              ),
            );
          },
          itemCount: _navigationMenu.length,
        ),
      ),
    );
  }
}

class NavMenuItems {
  String title;
  Function destination;

  NavMenuItems(this.title, this.destination);
}
