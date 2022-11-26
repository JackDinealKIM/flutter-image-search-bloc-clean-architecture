import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/search_image.dart';
import '../bloc/search/search_bloc.dart';
import '../widgets/image_grid_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_widget.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾는 이미지'),
      ),
      body: _bodyContainer(context),
    );
  }

  Widget _bodyContainer(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (_, state) {
      if (state is Empty) {
        return MessageWidget(message: '여기에 즐겨찾기한 이미지가 표시됩니다.', context: context);
        // return const Text('여기에 검색결과가 표시됩니다.');
      } else if (state is Loading) {
        return const LoadingWidget();
      } else if (state is Loaded) {
        final images = state.images.where((e) => e.isFavorited).toList();
        return ImageGridWidget(images: images);
      } else if (state is Error) {
        return MessageWidget(message: '오류가 발생하였습니다.\n(${state.message})', context: context);
        // return Text('오류가 발생하였습니다.\n(${state.message})');
      }
      return Container();
    });
  }
}
