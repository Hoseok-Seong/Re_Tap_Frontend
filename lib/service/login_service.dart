import 'package:future_letter/api/auth_api.dart';
import 'package:future_letter/dto/login_request.dart';

class LoginService {
  final AuthApi authApi = AuthApi();

  Future<void> oauthLogin({
    required String provider,
    required String accessToken,
    String? profileImageUrl,
  }) async {
    final request = LoginRequest(
      provider: provider,
      accessToken: accessToken,
      profileImageUrl: profileImageUrl,
    );

    final response = await authApi.oauthLogin(request);

    final token = response.data['accessToken'];
    final isNewUser = response.data['isNewUser'];

    print('JWT Token: $token');
    print('isNewUser: $isNewUser');

    // TODO: 토큰 저장
    // await prefs.setString('access_token', token);
  }
}