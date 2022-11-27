import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:search_images/data/model/cached_image_model.dart';
import 'package:search_images/presentation/pages/favorite_page.dart';
import 'package:search_images/presentation/pages/image_page.dart';
import 'core/di/injection.dart';
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

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFADC6FF),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD8E2FF),
  onPrimaryContainer: Color(0xFF001A41),
  secondary: Color(0xFF535E78),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD8E2FF),
  onSecondaryContainer: Color(0xFF0F1B32),
  tertiary: Color(0xFF76517B),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFED6FF),
  onTertiaryContainer: Color(0xFF2D0E34),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFEFBFF),
  onBackground: Color(0xFF1B1B1F),
  surface: Color(0xFFFEFBFF),
  onSurface: Color(0xFF1B1B1F),
  surfaceVariant: Color(0xFFE1E2EC),
  onSurfaceVariant: Color(0xFF44474F),
  outline: Color(0xFF74777F),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF303033),
  onInverseSurface: Color(0xFFF2F0F4),
  inversePrimary: Color(0xFFADC6FF),
  surfaceTint: Color(0xFF005AC1),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFADC6FF),
  onPrimary: Color(0xFF002E69),
  primaryContainer: Color(0xFF004494),
  onPrimaryContainer: Color(0xFFD8E2FF),
  secondary: Color(0xFFBBC6E4),
  onSecondary: Color(0xFF253048),
  secondaryContainer: Color(0xFF3B475F),
  onSecondaryContainer: Color(0xFFD8E2FF),
  tertiary: Color(0xFFE5B8E8),
  onTertiary: Color(0xFF44244A),
  tertiaryContainer: Color(0xFF5D3A62),
  onTertiaryContainer: Color(0xFFFED6FF),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFB4AB),
  background: Color(0xFF1B1B1F),
  onBackground: Color(0xFFE3E2E6),
  surface: Color(0xFF1B1B1F),
  onSurface: Color(0xFFE3E2E6),
  surfaceVariant: Color(0xFF44474F),
  onSurfaceVariant: Color(0xFFC4C6D0),
  outline: Color(0xFF8E9099),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFE3E2E6),
  onInverseSurface: Color(0xFF303033),
  inversePrimary: Color(0xFF005AC1),
  surfaceTint: Color(0xFFADC6FF),
);

// const primaryColor = Color(0xFF005AC1);
// const primaryBackgroundColor = Color(0xFFF1F5Fb);
