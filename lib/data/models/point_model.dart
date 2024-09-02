import 'package:equatable/equatable.dart';

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
