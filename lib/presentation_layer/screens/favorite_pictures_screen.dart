import 'package:flutter/material.dart';
import 'package:test01/presentation_layer/widgets/photo_grid.dart';
import 'package:test01/utilities/my_colors.dart';
import 'package:test01/date_layer/models/photo.dart';

class FavPicsScreen extends StatelessWidget {
  const FavPicsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.myGrey,
      appBar: AppBar(
        backgroundColor: MyColor.myPink,
        title: const Text("Favorite Pictures"),
        centerTitle: true,
      ),
      body: GridView.builder(
          itemCount: favPics.length,
          //controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0),
          itemBuilder: (context, index) {
            return PhotoGrid(photo: favPics[index]);
          }),
    );
  }
}
