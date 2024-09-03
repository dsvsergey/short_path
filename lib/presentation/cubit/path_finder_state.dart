part of 'path_finder_cubit.dart';

class PathFinderState extends Equatable {
  final String apiUrl;
  final List<PathTask> tasks;
  final List<PathResult> results;
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
    List<PathResult>? results,
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
