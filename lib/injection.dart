import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'data/datasources/path_finder_remote_data_source.dart';
import 'data/repositories/path_finder_repository_impl.dart';
import 'domain/repositories/path_finder_repository.dart';
import 'domain/usecases/find_shortest_path_usecase.dart';
import 'presentation/cubit/path_finder_cubit.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<PathFinderRemoteDataSource>(() =>
      PathFinderRemoteDataSourceImpl(baseUrl: 'https://flutter.webspark.dev'));
  getIt.registerLazySingleton<PathFinderRepository>(
      () => PathFinderRepositoryImpl(getIt<PathFinderRemoteDataSource>()));
  getIt.registerFactory<PathFinderCubit>(
      () => PathFinderCubit(getIt<PathFinderRepository>()));
  getIt.registerSingleton<FindShortestPathUseCase>(
      FindShortestPathUseCaseImpl());
  await getIt.allReady();
}
