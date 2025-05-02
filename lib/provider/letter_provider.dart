import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_letter/dto/letter/letter_create_resp.dart';
import 'package:future_letter/dto/letter/letter_delete_resp.dart';

import '../api/letter_api.dart';
import '../dto/letter/letter_create_req.dart';
import '../dto/letter/letter_detail_resp.dart';
import '../dto/letter/letter_list_resp.dart';
import '../service/letter_service.dart';
import 'global_dio_provider.dart';

final letterApiProvider = Provider<LetterApi>((ref) {
  final dio = ref.read(globalDioProvider);
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

final letterDetailProvider = FutureProvider.family.autoDispose<LetterDetailResp, int>((ref, req) async {
  final service = ref.read(letterServiceProvider);
  return await service.getLetterDetail(req);
});

final letterDeleteProvider = FutureProvider.family.autoDispose<LetterDeleteResp, List<int>>((ref, req) async {
  final service = ref.read(letterServiceProvider);
  return await service.deleteLetters(req);
});