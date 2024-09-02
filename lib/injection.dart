import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:path_finder_app/data/datasources/path_finder_remote_data_source.dart';
import 'package:path_finder_app/data/repositories/path_finder_repository_impl.dart';
import 'package:path_finder_app/domain/repositories/path_finder_repository.dart';
import 'package:path_finder_app/presentation/cubit/path_finder_cubit.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  PathFinderRemoteDataSource get remoteDataSource =>
      PathFinderRemoteDataSourceImpl(baseUrl: 'https://flutter.webspark.dev');

  @lazySingleton
  PathFinderRepository get repository =>
      PathFinderRepositoryImpl(getIt<PathFinderRemoteDataSource>());

  @injectable
  PathFinderCubit get pathFinderCubit =>
      PathFinderCubit(getIt<PathFinderRepository>());
}
