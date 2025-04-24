import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_letter/interceptor/auth_interceptor.dart';

import '../api/user_api.dart';
import '../common/constants.dart';
import '../service/user_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstant.baseUrl,
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      contentType: 'application/json',
    ),
  );

  dio.interceptors.add(AuthInterceptor(ref, dio));
  
  return dio;
});

final userApiProvider = Provider<UserApi>((ref) {
  final dio = ref.read(dioProvider);
  return UserApi(dio);
});

final userServiceProvider = Provider<UserService>((ref) {
  final api = ref.read(userApiProvider);
  return UserService(api);
});

final updateNicknameProvider = FutureProvider.family.autoDispose<void, String>((ref, nickname) async {
  final service = ref.read(userServiceProvider);
  await service.updateProfile(nickname: nickname);
});