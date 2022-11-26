import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:search_images/domain/repositories/search_image_repository.dart';
import 'package:search_images/domain/usecases/get_search_image_usecase.dart';

import '../../data/datasources/search_image_remote_data_source.dart';
import '../../data/repositories/search_image_repository_impl.dart';
import '../../presentation/bloc/search/search_bloc.dart';
import '../interceptor/dio_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features
  sl.registerFactory(
    () => SearchBloc(
      getSearchImageUsecase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSearchImageUsecase(sl()));

  // Repository
  sl.registerLazySingleton<SearchImageRepository>(
    () => SearchImageRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<SearchImageRemoteDataSource>(
    () => SearchImageRemoteDataSourceImpl(dio: sl()),
  );

  //! External
  sl.registerLazySingleton(() => getDio());
}

Dio getDio() {
  final dio = Dio();
  dio.interceptors.add(DioInterceptor());
  return dio;
}
