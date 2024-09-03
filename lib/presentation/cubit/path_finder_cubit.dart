import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/entities/result.dart';
import '../../domain/repositories/path_finder_repository.dart';
import '../../domain/usecases/find_shortest_path_usecase.dart';

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
    List<Result> results = [];

    for (var task in tasks) {
      final pathResult = _findShortestPathUseCase.execute(task);
      final steps = _pathToSteps(pathResult.result.path);

      results.add(Result(
        id: task.id,
        field: task.field.map((row) => row.split('')).toList(),
        steps: steps,
        start: [task.start.x, task.start.y],
        end: [task.end.x, task.end.y],
        path: pathResult.result.path,
      ));

      completedTasks++;

      final progress = completedTasks / tasks.length;
      emit(state.copyWith(
        results: results,
        progress: progress,
        isCalculationFinished: completedTasks == tasks.length,
      ));
    }
  }

  List<List<int>> _pathToSteps(String path) {
    List<List<int>> steps = [];
    final pointPairs = path.split('->');

    for (var pair in pointPairs) {
      final coordinates = pair.replaceAll(RegExp(r'[()]'), '').split(',');
      steps.add([int.parse(coordinates[0]), int.parse(coordinates[1])]);
    }

    return steps;
  }

  void sendResultsToServer() async {
    final resultOrFailure = await _repository.sendResults(state.results);
    resultOrFailure.fold(
      (failure) => emit(state.copyWith(error: _mapFailureToMessage(failure))),
      (_) => emit(state.copyWith(isResultsSent: true)),
    );
  }
}

class PathFinderState extends Equatable {
  final String apiUrl;
  final List<PathTask> tasks;
  final List<Result> results;
  final double progress;
  final bool isCalculationFinished;
  final bool isResultsSent;
  final String? error;

  const PathFinderState({
    required this.apiUrl,
    required this.tasks,
    required this.results,
    required this.progress,
    required this.isCalculationFinished,
    required this.isResultsSent,
    this.error,
  });

  factory PathFinderState.initial() => const PathFinderState(
        apiUrl: '',
        tasks: [],
        results: [],
        progress: 0,
        isCalculationFinished: false,
        isResultsSent: false,
      );

  PathFinderState copyWith({
    String? apiUrl,
    List<PathTask>? tasks,
    List<Result>? results,
    double? progress,
    bool? isCalculationFinished,
    bool? isResultsSent,
    String? error,
  }) {
    return PathFinderState(
      apiUrl: apiUrl ?? this.apiUrl,
      tasks: tasks ?? this.tasks,
      results: results ?? this.results,
      progress: progress ?? this.progress,
      isCalculationFinished:
          isCalculationFinished ?? this.isCalculationFinished,
      isResultsSent: isResultsSent ?? this.isResultsSent,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        apiUrl,
        tasks,
        results,
        progress,
        isCalculationFinished,
        isResultsSent,
        error
      ];
}
