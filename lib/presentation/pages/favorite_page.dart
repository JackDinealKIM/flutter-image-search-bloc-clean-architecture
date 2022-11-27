import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/favorite/favorite_bloc.dart';
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
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(GetCachedImagesEvent());
  }

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
    return BlocBuilder<FavoriteBloc, FavoriteState>(builder: (_, state) {
      if (state is Initial) {
        return MessageWidget(message: '여기에 즐겨찾기한 이미지가 표시됩니다.', context: context);
        // return const Text('여기에 검색결과가 표시됩니다.');
      } else if (state is Loading) {
        return const LoadingWidget();
      } else if (state is Loaded) {
        if (state.images.isEmpty) {
          return MessageWidget(message: '아직 즐겨찾기한 이미지가 없습니다.', context: context);
        }
        return ImageGridWidget(
          images: state.images,
        );
      } else if (state is Error) {
        return MessageWidget(message: '오류가 발생하였습니다.\n(${state.message})', context: context);
        // return Text('오류가 발생하였습니다.\n(${state.message})');
      }
      return Container();
    });
  }
}
