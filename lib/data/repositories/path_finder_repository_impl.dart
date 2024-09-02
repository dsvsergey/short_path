import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/entities/result.dart';
import '../../domain/repositories/path_finder_repository.dart';
import '../datasources/path_finder_remote_data_source.dart';
import '../models/result_model.dart';

class PathFinderRepositoryImpl implements PathFinderRepository {
  final PathFinderRemoteDataSource remoteDataSource;

  PathFinderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PathTask>>> getTasks() async {
    try {
      final remoteTasks = await remoteDataSource.getTasks();
      final tasks = remoteTasks.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> sendResults(
      List<Result> results) async {
    try {
      final resultModels =
          results.map((r) => ResultModel.fromEntity(r)).toList();
      final response = await remoteDataSource.sendResults(resultModels);
      return Right(response);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }
}
