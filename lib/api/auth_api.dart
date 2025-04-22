import 'package:dio/dio.dart';
import 'package:future_letter/api/dio_client.dart';
import 'package:future_letter/dto/auth/refresh_token_req.dart';

import '../dto/auth/oauth_check_req.dart';
import '../dto/auth/oauth_check_resp.dart';
import '../dto/auth/oauth_login_req.dart';
import '../dto/auth/oauth_login_resp.dart';
import '../dto/auth/oauth_register_req.dart';
import '../dto/auth/refresh_token_resp.dart';

class AuthApi {
  final Dio _dio = DioClient.instance;

  Future<OauthCheckResp> checkUser(OauthCheckReq request) async {
    final response = await _dio.post('/auth/check', data: request.toJson());
    return OauthCheckResp.fromJson(response.data);
  }

  Future<OauthLoginResp> registerUser(OauthRegisterReq request) async {
    final response = await _dio.post('/auth/register', data: request.toJson());
    return OauthLoginResp.fromJson(response.data);
  }

  Future<OauthLoginResp> oauthLogin(OauthLoginReq request) async {
    final response = await _dio.post('/auth/oauth-login', data: request.toJson());
    return OauthLoginResp.fromJson(response.data);
  }

  Future<RefreshTokenResp> refreshToken(RefreshTokenReq request) async {
    final response = await _dio.post('/auth/refresh', data: request.toJson());
    return RefreshTokenResp.fromJson(response.data);
  }
}
