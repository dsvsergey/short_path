import 'package:equatable/equatable.dart';

class Result extends Equatable {
  final String id;
  final List<List<String>> field;
  final List<List<int>> steps;
  final List<int> start;
  final List<int> end;
  final String path;

  const Result({
    required this.id,
    required this.field,
    required this.steps,
    required this.start,
    required this.end,
    required this.path,
  });

  @override
  List<Object?> get props => [id, field, steps, start, end, path];
}
