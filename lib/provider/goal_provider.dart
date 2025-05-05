import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/goal_api.dart';
import '../dto/goal/goal_ceate_resp.dart';
import '../dto/goal/goal_create_req.dart';
import '../dto/goal/goal_delete_resp.dart';
import '../dto/goal/goal_detail_resp.dart';
import '../dto/goal/goal_list_resp.dart';
import '../service/goal_service.dart';
import 'global_dio_provider.dart';

final goalApiProvider = Provider<GoalApi>((ref) {
  final dio = ref.read(globalDioProvider);
  return GoalApi(dio);
});

final goalServiceProvider = Provider<GoalService>((ref) {
  final api = ref.read(goalApiProvider);
  return GoalService(api);
});

final createOrUpdateGoalProvider = FutureProvider.family.autoDispose<GoalCreateResp, GoalCreateReq>((ref, req) async {
  final service = ref.read(goalServiceProvider);
  return service.createOrUpdate(req);
});

final goalListProvider = FutureProvider.autoDispose<List<GoalSummary>>((ref) async {
  final service = ref.read(goalServiceProvider);
  return await service.fetchGoalList();
});

final goalEditChangedProvider = StateProvider<bool>((ref) => false);

final resetGoalWriteProvider = StateProvider<bool>((ref) => false);

final goalDetailProvider = FutureProvider.family.autoDispose<GoalDetailResp, int>((ref, req) async {
  final service = ref.read(goalServiceProvider);
  return await service.getGoalDetail(req);
});

final goalDeleteProvider = FutureProvider.family.autoDispose<GoalDeleteResp, List<int>>((ref, req) async {
  final service = ref.read(goalServiceProvider);
  return await service.deleteGoals(req);
});