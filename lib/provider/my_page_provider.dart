import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/my_page_api.dart';
import '../dto/mypage/my_page_resp.dart';
import '../service/my_page_service.dart';
import 'global_dio_provider.dart';

final myPageApiProvider = Provider<MyPageApi>((ref) {
  final dio = ref.read(globalDioProvider);
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