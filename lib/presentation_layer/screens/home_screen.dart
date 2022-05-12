import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test01/logic_layer/photo_bloc.dart';
import 'package:test01/presentation_layer/widgets/photo_grid.dart';
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
      appBar: AppBar(
        title: const Text("Photos"),
      ),
      body: BlocBuilder<PhotoBloc, PhotoState>(builder: (context, state) {
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1), itemBuilder: (context, index) {
                return index >= state.photos.length ? loading() : PhotoGrid(
                    photo: state.photos[index]);
              });
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<PhotoBloc>().add(PhotoFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 1);
  }
}
