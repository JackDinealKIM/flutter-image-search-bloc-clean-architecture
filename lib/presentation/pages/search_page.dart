import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_images/presentation/widgets/message_widget.dart';
import 'package:search_images/presentation/widgets/image_grid_widget.dart';

import '../../core/di/injection.dart';
import '../bloc/search/search_bloc.dart';
import '../widgets/loading_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_query.isEmpty ? '이미지 검색' : "'$_query'에 대한 검색 결과입니다."),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(context: context, delegate: ImageSearchDelegate());

              setState(() {
                _query = result ?? '';
              });
              print(_query);

              if(_query.isNotEmpty) {
                BlocProvider.of<SearchBloc>(context).add(GetSearchImagesEvent(query: _query, page: 1));
              }
            },
          )
        ],
      ),
      body: _bodyContainer(context),
    );
  }

  Widget _bodyContainer(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (_, state) {
      if (state is Initial) {
        return MessageWidget(message: '여기에 검색결과가 표시됩니다.', context: context);
        // return const Text('여기에 검색결과가 표시됩니다.');
      } else if (state is Loading) {
        return const LoadingWidget();
      } else if (state is Loaded) {
        return ImageGridWidget(
          images: state.images,
          currentPage: state.page,
          query: _query,
          isSearchTab: true,
        );
      } else if (state is Error) {
        return MessageWidget(message: '오류가 발생하였습니다.\n(${state.message})', context: context);
        // return Text('오류가 발생하였습니다.\n(${state.message})');
      }
      return Container();
    });
  }
}

class ImageSearchDelegate extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        // primaryColor: Colors.white,
        // primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.green),
        // textTheme: theme.textTheme.copyWith(
        //   title: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
        // ),
        );
  }

  List<String> searchResults = [
    '토끼',
    '강아지',
    '염소',
    '원숭이',
    '돼지',
    '호랑이',
    '말',
    '닭',
    '양',
    '쥐',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
            }
          },
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResult) => searchResult.contains(query)).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => close(context, query));
    return Container();
  }
}
