import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:test01/date_layer/repository/photos_repository.dart';
import 'package:test01/date_layer/web_services/search_photos_web_services.dart';
import 'package:test01/logic_layer/photo_bloc.dart';
import 'package:test01/presentation_layer/screens/home_screen.dart';
import 'package:test01/utilities/my_colors.dart';

class CustomSearchDelegate extends SearchDelegate {
  late String word;

  List<String> searchTerms = [
    "Digital Nomad",
    "Current Events",
    "Wallpapers",
    "3D Renders",
    "Textures",
    "Experimental",
    "Architecture",
    "Nature",
    "Business",
    "Fashion",
    "Film",
    "Food",
    "Health",
    "People",
    "Interiors",
    "Street Photography",
    "Travel",
    "Animals",
    "Spirituality",
    "Arts",
    "History",
    "Athletics",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.clear,
          //color: MyColor.myGrey,
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back,
        //color: MyColor.myGrey,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    word = query.trim();
    word = word.toLowerCase().replaceAll(' ', '-');

    return BlocProvider(
      create: (BuildContext context) => PhotoBloc(
        photosRepository: PhotosRepository(
          searchPhotosWebServices: SearchPhotosWebServices(),
        ),
      )..add(PhotoFetched(query: word)),
      child: HomeScreen(
        isSearching: true,
        query: word,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return Container(
      color: MyColor.myGrey,
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return InkWell(
            onTap: () {
              query = result;
            },
            child: ListTile(
              textColor: MyColor.myWhite,
              title: Text(
                result,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
