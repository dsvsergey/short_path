import 'package:dio/dio.dart';
import '../models/task_model.dart';
import '../models/result_model.dart';

abstract class PathFinderRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<List<Map<String, dynamic>>> sendResults(List<ResultModel> results);
}

class PathFinderRemoteDataSourceImpl implements PathFinderRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  PathFinderRemoteDataSourceImpl({required this.baseUrl}) : dio = Dio() {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await dio.get('/flutter/api');
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> sendResults(
      List<ResultModel> results) async {
    try {
      final response = await dio.post(
        '/flutter/api',
        data: results.map((r) => r.toJson()).toList(),
      );
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to send results');
      }
    } catch (e) {
      throw Exception('Failed to send results: $e');
    }
  }
}
