import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:re_tap/dto/user/fcm_token_req.dart';
import 'package:re_tap/dto/user/fcm_token_resp.dart';
import '../api/user_api.dart';
import '../dto/user/with_draw_resp.dart';
import '../service/user_service.dart';
import 'global_dio_provider.dart';

final userApiProvider = Provider<UserApi>((ref) {
  final dio = ref.read(globalDioProvider);
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

final withDrawProvider = FutureProvider.autoDispose<WithDrawResp>((ref) async {
  final service = ref.read(userServiceProvider);
  return await service.withdraw();
});

final updateFcmTokenProvider = FutureProvider.family.autoDispose<FcmTokenResp, FcmTokenReq>((ref, req) async {
  final service = ref.read(userServiceProvider);
  return service.updateFcmToken(req);
});