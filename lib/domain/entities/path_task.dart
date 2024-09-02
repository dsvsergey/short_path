import 'package:equatable/equatable.dart';

class PathTask extends Equatable {
  final String id;
  final List<List<int>> field;
  final List<int> start;
  final List<int> end;

  const PathTask({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  @override
  List<Object?> get props => [id, field, start, end];
}
