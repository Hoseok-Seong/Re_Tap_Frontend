import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/constants.dart';
import '../interceptor/auth_interceptor.dart';

final globalDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstant.baseUrl,
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 50),
      contentType: 'application/json',
    ),
  );

  dio.interceptors.add(AuthInterceptor(ref, dio));

  return dio;
});