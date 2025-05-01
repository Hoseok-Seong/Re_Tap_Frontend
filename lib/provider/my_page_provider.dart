import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/my_page_api.dart';
import '../common/constants.dart';
import '../dto/mypage/my_page_resp.dart';
import '../interceptor/auth_interceptor.dart';
import '../service/my_page_service.dart';

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

final myPageApiProvider = Provider<MyPageApi>((ref) {
  final dio = ref.read(dioProvider);
  return MyPageApi(dio);
});

final myPageServiceProvider = Provider<MyPageService>((ref) {
  final api = ref.read(myPageApiProvider);
  return MyPageService(api);
});

final myPageProvider = FutureProvider.autoDispose<MyPageResp>((ref) async {
  final service = ref.read(myPageServiceProvider);
  return await service.getMyPage();
});