import 'package:equatable/equatable.dart';

import '../../domain/entities/path.dart';
import 'point_model.dart';

class ResultModel extends Equatable {
  final List<PointModel> steps;
  final String path;

  const ResultModel({required this.steps, required this.path});

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      steps: (json['steps'] as List)
          .map((step) => PointModel.fromJson(step))
          .toList(),
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps.map((step) => step.toJson()).toList(),
      'path': path,
    };
  }

  @override
  List<Object?> get props => [steps, path];
}

extension PathExtension on Path {
  ResultModel toModel() {
    return ResultModel(
      steps: steps.map((step) => step.toModel()).toList(),
      path: path,
    );
  }
}

extension ResultModelExtension on ResultModel {
  Path toEntity() {
    return Path(
      steps: steps.map((step) => step.toEntity()).toList(),
      path: path,
    );
  }
}
