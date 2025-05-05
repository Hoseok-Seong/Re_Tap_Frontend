import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/auth_provider.dart';
import '../service/auth_service.dart';
import '../token/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;
  final Dio _dio;

  final AuthService _authService = AuthService();
  Future<String>? _refreshingToken;

  AuthInterceptor(this.ref, this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path.contains('/api/')) {
      final token = await TokenStorage.getAccessToken();
      if (token != null) {
        options.headers['Authorization_Access'] = token;
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final code = err.response?.data['code'];

    if (code == 'J003') {
      try {
        _refreshingToken ??= _authService.refreshTokenAndGetAccessToken(ref);
        final newAccessToken = await _refreshingToken!;
        _refreshingToken = null;

        final retryReq = await _retry(err.requestOptions, newAccessToken);
        return handler.resolve(retryReq);
      } catch (e) {
        _refreshingToken = null;
        return _forceLogout(handler, err);
      }
    }

    if (code == 'J001' || code == 'J002' || code == 'J004' || code == 'J005') {
      return _forceLogout(handler, err);
    }

    handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions req, String newAccessToken) {
    final options = Options(
      method: req.method,
      headers: Map.of(req.headers)..['Authorization_Access'] = newAccessToken,
    );
    return _dio.requestUri(
      req.uri,
      data: req.data,
      options: options,
    );
  }

  void _forceLogout(ErrorInterceptorHandler handler, DioException err) {
    TokenStorage.clear();
    ref.read(authStateProvider.notifier).state = AuthState.loggedOut;
    handler.next(err);
  }
}
