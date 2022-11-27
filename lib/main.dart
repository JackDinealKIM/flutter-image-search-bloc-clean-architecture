import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:search_images/data/model/cached_image_model.dart';
import 'package:search_images/presentation/pages/favorite_page.dart';
import 'package:search_images/presentation/pages/image_page.dart';
import 'core/di/injection.dart';
import 'core/theme/color_schemes.dart';
import 'presentation/bloc/favorite/favorite_bloc.dart';
import 'presentation/bloc/search/search_bloc.dart';
import 'presentation/pages/search_page.dart';
import '../../core/di/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // di init
  await di.init();

  // init hive
  await Hive.initFlutter();
  Hive.registerAdapter(CachedImageModelAdapter());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => sl<FavoriteBloc>(),
        ),
        BlocProvider(
          create: (BuildContext context) => sl<SearchBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.primary,
          // This will be applied to the "back" icon
          iconTheme: const IconThemeData(color: Colors.black),
          // This will be applied to the action icon buttons that locates on the right side
          actionsIconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 15,
          titleTextStyle: const TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
      // initialRoute: HomePage.routeName,
      routes: routes,
    );
  }
}

class MainPage extends StatefulWidget {
  static const String routeName = "/main";

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final _screens = [
    const SearchPage(),
    const FavoritePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: const Duration(milliseconds: 500),
          height: 60,
          backgroundColor: lightColorScheme.primary,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() => this._selectedIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: '검색',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: '즐겨찾기',
            ),
          ],
        ),
      ),
    );
  }
}

final Map<String, WidgetBuilder> routes = {
  MainPage.routeName: (context) => const MainPage(),
  ImagePage.routeName: (context) => const ImagePage(),
};