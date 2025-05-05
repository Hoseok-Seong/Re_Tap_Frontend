import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/home_api.dart';
import '../dto/home/home_resp.dart';
import '../service/home_service.dart';
import 'global_dio_provider.dart';

final homeApiProvider = Provider<HomeApi>((ref) {
  final dio = ref.read(globalDioProvider);
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