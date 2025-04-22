import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/dio_client.dart';
import '../api/letter_api.dart';
import '../dto/letter/letter_create_req.dart';
import '../service/letter_service.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient.instance;
});

final letterApiProvider = Provider<LetterApi>((ref) {
  final dio = ref.read(dioProvider);
  return LetterApi(dio);
});

final letterServiceProvider = Provider<LetterService>((ref) {
  final api = ref.read(letterApiProvider);
  return LetterService(api);
});

final createLetterProvider = FutureProvider.family.autoDispose<int, LetterCreateReq>((ref, req) async {
  final service = ref.read(letterServiceProvider);
  return service.create(req);
});
