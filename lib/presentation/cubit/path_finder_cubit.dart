import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/path_result.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/repositories/path_finder_repository.dart';
import '../../domain/usecases/find_shortest_path_usecase.dart';

part 'path_finder_state.dart';

class PathFinderCubit extends Cubit<PathFinderState> {
  final PathFinderRepository _repository;
  final FindShortestPathUseCase _findShortestPathUseCase;

  PathFinderCubit(this._repository)
      : _findShortestPathUseCase = GetIt.I<FindShortestPathUseCase>(),
        super(PathFinderState.initial());

  void setApiUrl(String url) {
    emit(state.copyWith(apiUrl: url));
    _fetchTasks();
  }

  void _fetchTasks() async {
    final tasksOrFailure = await _repository.getTasks();

    tasksOrFailure.fold(
        (failure) => emit(state.copyWith(error: _mapFailureToMessage(failure))),
        (tasks) {
      emit(state.copyWith(tasks: tasks));
      _startCalculations();
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Помилка сервера';
      case NetworkFailure:
        return 'Помилка мережі';
      default:
        return 'Виникла неочікувана помилка';
    }
  }

  void _startCalculations() {
    final tasks = state.tasks;
    if (tasks.isEmpty) return;

    int completedTasks = 0;
    List<PathResult> results = [];

    for (var task in tasks) {
      final pathResult = _findShortestPathUseCase.execute(task);
      results.add(pathResult);

      completedTasks++;

      final progress = completedTasks / tasks.length;
      emit(state.copyWith(
        results: results,
        progress: progress,
        isCalculationFinished: completedTasks == tasks.length,
      ));
    }
  }

  void sendResultsToServer() async {
    final resultOrFailure = await _repository.sendResults(state.results);
    resultOrFailure.fold(
      (failure) => emit(state.copyWith(error: _mapFailureToMessage(failure))),
      (_) => emit(state.copyWith(isResultsSent: true)),
    );
  }
}
