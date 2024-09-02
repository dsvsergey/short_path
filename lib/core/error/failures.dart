import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Виникла помилка сервера'])
      : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Виникла помилка мережі'])
      : super(message);
}
