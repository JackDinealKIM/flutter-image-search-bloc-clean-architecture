import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:search_images/domain/repositories/search_image_repository.dart';
import 'package:search_images/domain/usecases/get_search_image_usecase.dart';

import '../../data/datasources/search_image_local_data_source.dart';
import '../../data/datasources/search_image_remote_data_source.dart';
import '../../data/repositories/cached_image_repository_impl.dart';
import '../../data/repositories/search_image_repository_impl.dart';
import '../../domain/repositories/cached_image_repository.dart';
import '../../domain/usecases/get_cached_image_add_usecase.dart';
import '../../domain/usecases/get_cached_image_remove_usecase.dart';
import '../../domain/usecases/get_cached_image_usecase.dart';
import '../../presentation/bloc/favorite/favorite_bloc.dart';
import '../../presentation/bloc/search/search_bloc.dart';
import '../const.dart';
import '../interceptor/dio_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features
  sl.registerFactory(
    () => SearchBloc(
      getSearchImageUsecase: sl(),
      getCachedImageUsecase: sl(),
    ),
  );
  sl.registerFactory(
    () => FavoriteBloc(
      getCachedImageUsecase: sl(),
      getCachedImageAddUsecase: sl(),
      getCachedImageRemoveUsecase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSearchImageUsecase(sl()));
  sl.registerLazySingleton(() => GetCachedImageUsecase(sl()));
  sl.registerLazySingleton(() => GetCachedImageAddUsecase(sl()));
  sl.registerLazySingleton(() => GetCachedImageRemoveUsecase(sl()));

  // Repository
  sl.registerLazySingleton<SearchImageRepository>(
    () => SearchImageRepositoryImpl(
      dataSource: sl(),
    ),
  );
  sl.registerLazySingleton<CachedImageRepository>(
        () => CachedImageRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<SearchImageRemoteDataSource>(
    () => SearchImageRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<SearchImageLocalDataSource>(
        () => SearchImageLocalDataSourceImpl(),
  );

  //! External
  sl.registerLazySingleton(() => getDio());
}

Dio getDio() {
  final dio = Dio(BaseOptions(baseUrl: BASE_URL));
  dio.interceptors.add(DioInterceptor());
  return dio;
}
