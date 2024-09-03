import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../data/models/result_response_model.dart';
import '../entities/result.dart';
import '../repositories/path_finder_repository.dart';

class SolvePathUseCase {
  final PathFinderRepository repository;

  SolvePathUseCase(this.repository);

  Future<Either<Failure, ResultResponseModel>> call(
      List<Result> results) async {
    return await repository.sendResults(results);
  }
}
