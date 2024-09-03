import 'package:equatable/equatable.dart';

import 'point.dart';

class PathTask extends Equatable {
  final String id;
  final List<String> field;
  final Point start;
  final Point end;

  const PathTask({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  @override
  List<Object?> get props => [id, field, start, end];
}
