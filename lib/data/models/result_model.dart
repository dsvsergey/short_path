import 'package:equatable/equatable.dart';
import '../../domain/entities/result.dart';

class ResultModel extends Equatable {
  final String id;
  final List<Map<String, String>> steps;
  final String path;

  const ResultModel({
    required this.id,
    required this.steps,
    required this.path,
  });

  factory ResultModel.fromEntity(Result result) {
    return ResultModel(
      id: result.taskId,
      steps: result.steps
          .map((step) => {'x': step[1].toString(), 'y': step[0].toString()})
          .toList(),
      path: result.path,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'result': {
        'steps': steps,
        'path': path,
      },
    };
  }

  @override
  List<Object?> get props => [id, steps, path];
}
