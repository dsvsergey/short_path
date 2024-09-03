import 'package:equatable/equatable.dart';

import '../../domain/entities/path_result.dart';
import 'result_model.dart';

class ApiRequestModel extends Equatable {
  final String id;
  final ResultModel result;

  const ApiRequestModel({required this.id, required this.result});

  factory ApiRequestModel.fromJson(Map<String, dynamic> json) {
    return ApiRequestModel(
      id: json['id'],
      result: ResultModel.fromJson(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'result': result.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, result];
}

extension PathResultExtension on PathResult {
  ApiRequestModel toModel() {
    return ApiRequestModel(
      id: id,
      result: result.toModel(),
    );
  }
}

extension ApiRequestModelExtension on ApiRequestModel {
  PathResult toEntity() {
    return PathResult(
      id: id,
      result: result.toEntity(),
    );
  }
}
