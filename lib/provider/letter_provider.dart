import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_letter/dto/letter/letter_create_resp.dart';
import 'package:flutter/material.dart';

import '../api/letter_api.dart';
import '../common/constants.dart';
import '../dto/letter/letter_create_req.dart';
import '../dto/letter/letter_list_resp.dart';
import '../interceptor/auth_interceptor.dart';
import '../service/letter_service.dart';

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

final letterApiProvider = Provider<LetterApi>((ref) {
  final dio = ref.read(dioProvider);
  return LetterApi(dio);
});

final letterServiceProvider = Provider<LetterService>((ref) {
  final api = ref.read(letterApiProvider);
  return LetterService(api);
});

final createOrUpdateLetterProvider = FutureProvider.family.autoDispose<LetterCreateResp, LetterCreateReq>((ref, req) async {
  final service = ref.read(letterServiceProvider);
  return service.createOrUpdate(req);
});

final letterListProvider = FutureProvider.autoDispose<List<LetterSummary>>((ref) async {
  final service = ref.read(letterServiceProvider);
  return await service.fetchLetterList();
});

final letterEditChangedProvider = StateProvider<bool>((ref) => false);

final resetLetterWriteProvider = StateProvider<bool>((ref) => false);