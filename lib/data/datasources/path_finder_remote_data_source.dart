import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/error/exceptions.dart';
import '../models/api_response.dart';
import '../models/send_result_model.dart';

abstract class PathFinderRemoteDataSource {
  Future<ApiResponse> getTasks();
  Future<Map<String, dynamic>> sendResults(List<SendResultModel> results);
}

class PathFinderRemoteDataSourceImpl implements PathFinderRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  PathFinderRemoteDataSourceImpl({required this.baseUrl}) : dio = Dio() {
    Dio dio = Dio(BaseOptions(
      baseUrl: 'https://flutter.webspark.dev',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      validateStatus: (status) {
        return status! < 500;
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('Request: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint(
            'Response: ${response.statusCode} ${response.statusMessage}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        debugPrint('Error: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  @override
  Future<ApiResponse> getTasks() async {
    try {
      final response =
          await dio.get('https://flutter.webspark.dev/flutter/api');
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Dio error: ${e.message}');
        print('Dio error type: ${e.type}');
        print('Dio error response: ${e.response}');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
            'Connection error. Please check your internet connection.');
      } else {
        throw Exception('Failed to load tasks: ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> sendResults(
      List<SendResultModel> results) async {
    try {
      final response = await dio.post(
        'https://flutter.webspark.dev/flutter/api',
        data: results.map((r) => r.toJson()).toList(),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerException(
            message: 'Failed to send results: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to send results: ${e.message}');
    }
  }
}
