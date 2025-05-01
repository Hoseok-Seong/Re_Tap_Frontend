import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/home_api.dart';
import '../common/constants.dart';
import '../dto/home/home_resp.dart';
import '../interceptor/auth_interceptor.dart';
import '../service/home_service.dart';

final dioProvider = Provider<Dio>((ref) {
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

final homeApiProvider = Provider<HomeApi>((ref) {
  final dio = ref.read(dioProvider);
  return HomeApi(dio);
});

final homeServiceProvider = Provider<HomeService>((ref) {
  final api = ref.read(homeApiProvider);
  return HomeService(api);
});

final homeProvider = FutureProvider.autoDispose<HomeResp>((ref) async {
  final service = ref.read(homeServiceProvider);
  return await service.getHome();
});