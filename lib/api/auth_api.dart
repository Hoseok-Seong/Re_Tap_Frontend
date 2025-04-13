import 'package:dio/dio.dart';
import 'package:future_letter/api/dio_client.dart';
import 'package:future_letter/dto/login_request.dart';
import 'package:future_letter/dto/login_response.dart';

class AuthApi {
  final Dio dio = DioClient.instance;

  Future<LoginResponse> oauthLogin(LoginRequest request) async {
    final response = await dio.post('/auth/oauth-login', data: request.toJson());

    return LoginResponse.fromJson(response.data);
  }
}
