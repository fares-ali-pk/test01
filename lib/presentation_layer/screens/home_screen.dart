import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test01/logic_layer/photo_bloc.dart';
import 'package:test01/presentation_layer/shared_ui/navigation_drawer.dart';
import 'package:test01/presentation_layer/widgets/photo_grid.dart';
import 'package:test01/utilities/my_colors.dart';
import 'package:test01/utilities/widget_utilities.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.myGrey,
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: MyColor.myPink,
        actions: [
          IconButton(
            onPressed: () {
              //todo: search on pics
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
        title: const Text("Photos"),
        centerTitle: true,
      ),
      drawer: const NavigationDrawer(),
      body: _buildBloc(),
    );
  }

  Widget _buildBloc() {
    return BlocBuilder<PhotoBloc, PhotoState>(builder: (context, state) {
      switch (state.status) {
        case PhotoStatus.failure:
          return const Center(
            child: Text("failed to fetch photos"),
          );
        case PhotoStatus.success:
          if (state.photos.isEmpty) {
            return const Center(
              child: Text("There are no photos"),
            );
          } else {
            return GridView.builder(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                itemCount: (state.hasReachedMax)
                    ? state.photos.length
                    : state.photos.length + 1,
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0),
                itemBuilder: (context, index) {
                  return index >= state.photos.length
                      ? loading()
                      : PhotoGrid(photo: state.photos[index]);
                });
          }
        default:
          return loading();
      }
    });
  }

  void _onScroll() {
    if (_isBottom) context.read<PhotoBloc>().add(PhotoFetched());
    //if (_isBottom) BlocProvider.of<PhotoBloc>(context).add(PhotoFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 1);
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    "Digital Nomad",
    "Current Events",
    "Wallpapers",
    "3D Renders",
    "Textures & Patterns",
    "Experimental",
    "Architecture",
    "Nature",
    "Business & Work",
    "Fashion",
    "Film",
    "Food & Drink",
    "Health & Wellness",
    "People",
    "Interiors",
    "Street Photography",
    "Travel",
    "Animals",
    "Spirituality",
    "Arts & Culture",
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
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
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
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
