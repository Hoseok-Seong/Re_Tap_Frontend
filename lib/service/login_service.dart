import 'package:future_letter/api/auth_api.dart';
import 'package:future_letter/dto/login_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dto/login_response.dart';

class LoginService {
  final AuthApi authApi = AuthApi();

  Future<LoginResponse> oauthLogin({
    required String provider,
    required String accessToken,
  }) async {
    final request = LoginRequest(
      provider: provider,
      accessToken: accessToken,
    );

    final response = await authApi.oauthLogin(request);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', response.accessToken);
    await prefs.setString('refresh_token', response.refreshToken);

    return response;
  }
}