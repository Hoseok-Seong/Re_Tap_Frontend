import 'package:dio/dio.dart';
import 'package:future_letter/api/dio_client.dart';
import 'package:future_letter/dto/login_request.dart';

class AuthApi {
  final Dio dio = DioClient.instance;

  Future<Response> oauthLogin(LoginRequest request) {
    return dio.post('/api/auth/oauth-login', data: request.toJson());
  }
}
