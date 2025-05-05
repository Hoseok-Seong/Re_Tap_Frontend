import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/auth_api.dart';
import '../dto/auth/oauth_check_req.dart';
import '../dto/auth/oauth_check_resp.dart';
import '../dto/auth/oauth_login_req.dart';
import '../dto/auth/oauth_login_resp.dart';
import '../dto/auth/oauth_register_req.dart';
import '../dto/auth/refresh_token_req.dart';
import '../provider/auth_provider.dart';
import '../token/token_storage.dart';

class AuthService {
  final AuthApi _authApi = AuthApi();

  Future<OauthCheckResp> checkUser({
    required String provider,
    required String accessToken,
  }) async {
    final request = OauthCheckReq(
        provider: provider,
        accessToken: accessToken
    );

    final response = await _authApi.checkUser(request);

    return response;
  }

  Future<OauthLoginResp> registerUser({
    required String provider,
    required String accessToken,
  }) async {
    final request = OauthRegisterReq(
      provider: provider,
      accessToken: accessToken,
    );

    final response = await _authApi.registerUser(request);
    await TokenStorage.saveTokens(response.accessToken, response.refreshToken);

    return response;
  }

  Future<OauthLoginResp> oauthLogin({
    required String provider,
    required String accessToken,
  }) async {
    final request = OauthLoginReq(
      provider: provider,
      accessToken: accessToken,
    );

    final response = await _authApi.oauthLogin(request);
    await TokenStorage.saveTokens(response.accessToken, response.refreshToken);

    return response;
  }

  Future<String> refreshTokenAndGetAccessToken(Ref ref) async {
    final storedRefreshToken = await TokenStorage.getRefreshToken();

    if (storedRefreshToken == null) {
      TokenStorage.clear();
      ref.read(authStateProvider.notifier).state = AuthState.loggedOut;
      return Future.error('Refresh token not found');
    }

    final request = RefreshTokenReq(refreshToken: storedRefreshToken);
    final response = await _authApi.refreshToken(request);

    await TokenStorage.saveTokens(response.accessToken, response.refreshToken);

    return response.accessToken;
  }
}