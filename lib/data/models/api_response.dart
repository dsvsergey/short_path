import 'task_model.dart';

class ApiResponse {
  final bool error;
  final String message;
  final List<TaskModel> data;

  ApiResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      error: json['error'],
      message: json['message'],
      data: (json['data'] as List)
          .map((taskJson) => TaskModel.fromJson(taskJson))
          .toList(),
    );
  }
}
