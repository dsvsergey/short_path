class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Виникла помилка сервера']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Виникла помилка мережі']);
}
