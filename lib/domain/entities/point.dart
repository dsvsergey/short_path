import 'package:equatable/equatable.dart';

class Point extends Equatable {
  final int x;
  final int y;

  const Point({required this.x, required this.y});

  @override
  List<Object?> get props => [x, y];
}
