import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test01/logic_layer/photo_bloc.dart';
import 'package:test01/presentation_layer/shared_ui/navigation_drawer.dart';
import 'package:test01/presentation_layer/widgets/custom_search_delegate.dart';
import 'package:test01/presentation_layer/widgets/photo_grid.dart';
import 'package:test01/utilities/my_colors.dart';
import 'package:test01/utilities/widget_utilities.dart';

class HomeScreen extends StatefulWidget {
  bool isSearching;

  String? query;

  HomeScreen({Key? key, this.isSearching = false, this.query})
      : super(key: key);

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
      appBar: (!widget.isSearching)
          ? AppBar(
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
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
              ],
              title: const Text("Photos"),
              centerTitle: true,
            )
          : null,
      drawer: const NavigationDrawer(),
      body: _buildBloc(),
    );
  }

  Widget _buildBloc() {
    return BlocBuilder<PhotoBloc, PhotoState>(builder: (context, state) {
      switch (state.status) {
        case PhotoStatus.failure:
          return const Center(
            child: Text(
              "Failed To Fetch Photos",
              style: TextStyle(
                color: MyColor.myPink,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        case PhotoStatus.success:
          if (state.photos.isEmpty) {
            return const Center(
              child: Text(
                "There Are No Photos",
                style: TextStyle(
                  color: MyColor.myPink,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
    if (_isBottom) {
      (widget.isSearching)
          ? context.read<PhotoBloc>().add(PhotoFetched(query: widget.query))
          : context.read<PhotoBloc>().add(PhotoFetched());
    }
    //if (_isBottom) BlocProvider.of<PhotoBloc>(context).add(PhotoFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 1);
  }
}
