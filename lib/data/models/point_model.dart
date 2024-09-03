import 'package:equatable/equatable.dart';

import '../../domain/entities/point.dart';

class PointModel extends Equatable {
  final int x;
  final int y;

  const PointModel({required this.x, required this.y});

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      x: json['x'],
      y: json['y'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }

  @override
  List<Object?> get props => [x, y];
}

extension PointExtension on Point {
  PointModel toModel() {
    return PointModel(x: x, y: y);
  }
}

extension PointModelExtension on PointModel {
  Point toEntity() {
    return Point(x: x, y: y);
  }
}
