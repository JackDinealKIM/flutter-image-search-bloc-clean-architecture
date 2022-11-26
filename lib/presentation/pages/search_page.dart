import 'package:flutter/material.dart';
import 'package:search_images/presentation/widgets/image_grid_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String keyword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(keyword.isEmpty ? '이미지 검색' : "'$keyword'에 대한 검색 결과입니다."),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(context: context, delegate: ImageSearchDelegate());

              setState(() {
                keyword = result ?? '';
              });
              print(keyword);
            },
          )
        ],
      ),
      body: keyword.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '여기에 검색결과가 표시됩니다.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : const ImageGridWidget(),
    );
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
    '말',
    '닭',
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
