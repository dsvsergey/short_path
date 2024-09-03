import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../data/models/result_response_model.dart';
import '../entities/path_result.dart';
import '../entities/path_task.dart';

abstract class PathFinderRepository {
  Future<Either<Failure, List<PathTask>>> getTasks();
  Future<Either<Failure, ResultResponseModel>> sendResults(
      List<PathResult> results);
}
