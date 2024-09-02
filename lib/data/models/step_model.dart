class StepModel {
  final String x;
  final String y;

  StepModel({required this.x, required this.y});

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}
