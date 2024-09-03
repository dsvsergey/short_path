import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/entities/result.dart';
import '../../domain/repositories/path_finder_repository.dart';

class PathFinderCubit extends Cubit<PathFinderState> {
  final PathFinderRepository _repository;

  PathFinderCubit(this._repository) : super(PathFinderState.initial());

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
      final path = findPath(task);
      final steps = pathToSteps(path);

      results.add(Result(
        id: task.id,
        field: task.field
            .map((row) => row.split(''))
            .toList(), // Перетворюємо рядок на список символів
        steps: steps,
        start: [task.start.x, task.start.y],
        end: [task.end.x, task.end.y],
        path: path,
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

  String findPath(PathTask task) {
    // Тут має бути ваш алгоритм пошуку шляху
    // Повертаємо рядок, що представляє шлях, наприклад: "RDLUR"
    // R - вправо, L - вліво, U - вгору, D - вниз
    return "";
  }

  List<List<int>> pathToSteps(String path) {
    List<List<int>> steps = [];
    int x = 0, y = 0;
    steps.add([x, y]);

    for (var move in path.split('')) {
      switch (move) {
        case 'R':
          x++;
          break;
        case 'L':
          x--;
          break;
        case 'U':
          y--;
          break;
        case 'D':
          y++;
          break;
      }
      steps.add([x, y]);
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
