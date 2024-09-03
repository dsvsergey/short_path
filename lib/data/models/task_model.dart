import 'package:equatable/equatable.dart';

import '../../domain/entities/path_task.dart';
import '../../domain/entities/point.dart';
import 'point_model.dart';

class TaskModel extends Equatable {
  final String id;
  final List<String> field;
  final PointModel start;
  final PointModel end;

  const TaskModel({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      field: List<String>.from(json['field']),
      start: PointModel.fromJson(json['start']),
      end: PointModel.fromJson(json['end']),
    );
  }

  PathTask toEntity() {
    return PathTask(
      id: id,
      field: field,
      start: Point(x: start.x, y: start.y),
      end: Point(x: end.x, y: end.y),
    );
  }

  @override
  List<Object?> get props => [id, field, start, end];
}
