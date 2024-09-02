import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/entities/result.dart';
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
      List<Result> results) async {
    try {
      final sendResultModels = results
          .map((result) => SendResultModel(
                id: result.id,
                steps: result.steps
                    .map((step) => StepModel(
                          x: step[0].toString(),
                          y: step[1].toString(),
                        ))
                    .toList(),
                path: result.path,
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
}
