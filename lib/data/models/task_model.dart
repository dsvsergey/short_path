import 'package:equatable/equatable.dart';

import '../../domain/entities/path_task.dart';
import 'point_model.dart';

class TaskModel extends Equatable {
  final String id;
  final List<List<String>> field;
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
      field: List<List<String>>.from(
        json['field'].map((row) => List<String>.from(row)),
      ),
      start: PointModel.fromJson(json['start']),
      end: PointModel.fromJson(json['end']),
    );
  }

  PathTask toEntity() {
    return PathTask(
      id: id,
      field: field
          .map((row) => row.map((cell) => cell == 'X' ? 1 : 0).toList())
          .toList(),
      start: [start.y, start.x],
      end: [end.y, end.x],
    );
  }

  @override
  List<Object?> get props => [id, field, start, end];
}
