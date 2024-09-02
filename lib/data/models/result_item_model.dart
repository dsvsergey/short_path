class ResultItemModel {
  final String id;
  final bool correct;

  ResultItemModel({required this.id, required this.correct});

  factory ResultItemModel.fromJson(Map<String, dynamic> json) {
    return ResultItemModel(
      id: json['id'],
      correct: json['correct'],
    );
  }
}
