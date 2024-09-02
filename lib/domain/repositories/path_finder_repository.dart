import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/path_task.dart';
import '../entities/result.dart';

abstract class PathFinderRepository {
  Future<Either<Failure, List<PathTask>>> getTasks();
  Future<Either<Failure, List<Map<String, dynamic>>>> sendResults(
      List<Result> results);
}
