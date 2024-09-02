import 'result_item_model.dart';

class ResultResponseModel {
  final bool error;
  final String message;
  final List<ResultItemModel> data;

  ResultResponseModel(
      {required this.error, required this.message, required this.data});

  factory ResultResponseModel.fromJson(Map<String, dynamic> json) {
    return ResultResponseModel(
      error: json['error'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => ResultItemModel.fromJson(item))
          .toList(),
    );
  }
}
