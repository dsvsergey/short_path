import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/path_result.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/repositories/path_finder_repository.dart';
import '../datasources/path_finder_remote_data_source.dart';
import '../models/api_response.dart';
import '../models/result_response_model.dart';
import '../models/send_result_model.dart';
import '../models/step_model.dart';

class PathFinderRepositoryImpl implements PathFinderRepository {
  final PathFinderRemoteDataSource remoteDataSource;

  PathFinderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PathTask>>> getTasks() async {
    try {
      final ApiResponse apiResponse = await remoteDataSource.getTasks();

      if (!apiResponse.error) {
        final tasks =
            apiResponse.data.map((model) => model.toEntity()).toList();
        return Right(tasks);
      } else {
        return Left(ServerFailure(message: apiResponse.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ResultResponseModel>> sendResults(
      List<PathResult> results) async {
    try {
      final sendResultModels = results
          .map((pathResult) => SendResultModel(
                id: pathResult.id,
                steps: _convertPathToSteps(pathResult.result.path),
                path: pathResult.result.path,
              ))
          .toList();

      final response = await remoteDataSource.sendResults(sendResultModels);
      return Right(ResultResponseModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  List<StepModel> _convertPathToSteps(String path) {
    final pointPairs = path.split('->');
    return pointPairs.map((pair) {
      final coordinates = pair.replaceAll(RegExp(r'[()]'), '').split(',');
      return StepModel(
        x: coordinates[0],
        y: coordinates[1],
      );
    }).toList();
  }
}
