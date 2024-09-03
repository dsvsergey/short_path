import 'package:dartz/dartz.dart' as dartz;

import '../../core/error/failures.dart';
import '../entities/path_task.dart';
import '../repositories/path_finder_repository.dart';

class GetTasksUseCase {
  final PathFinderRepository repository;

  GetTasksUseCase(this.repository);

  Future<dartz.Either<Failure, List<PathTask>>> call() {
    return repository.getTasks();
  }
}
