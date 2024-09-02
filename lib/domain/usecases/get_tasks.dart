import 'package:dartz/dartz.dart' as dartz;
import 'package:path_finder_app/core/error/failures.dart';
import 'package:path_finder_app/domain/entities/path_task.dart';
import 'package:path_finder_app/domain/repositories/path_finder_repository.dart';

class GetTasksUseCase {
  final PathFinderRepository repository;

  GetTasksUseCase(this.repository);

  Future<dartz.Either<Failure, List<PathTask>>> call() {
    return repository.getTasks();
  }
}
