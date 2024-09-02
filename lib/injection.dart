import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:path_finder_app/data/datasources/path_finder_remote_data_source.dart';
import 'package:path_finder_app/data/repositories/path_finder_repository_impl.dart';
import 'package:path_finder_app/domain/repositories/path_finder_repository.dart';
import 'package:path_finder_app/presentation/cubit/path_finder_cubit.dart';

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

  await getIt.allReady();
}
