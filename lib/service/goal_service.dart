import '../api/goal_api.dart';
import '../dto/goal/goal_ceate_resp.dart';
import '../dto/goal/goal_create_req.dart';
import '../dto/goal/goal_delete_resp.dart';
import '../dto/goal/goal_detail_resp.dart';
import '../dto/goal/goal_list_resp.dart';

class GoalService {
  final GoalApi _api;

  GoalService(this._api);

  Future<GoalCreateResp> createOrUpdate(GoalCreateReq request) async {
    final response = _api.createOrUpdateGoal(request);
    return response;
  }

  Future<List<GoalSummary>> fetchGoalList() async {
    final response = await _api.getGoals();
    return response.goals;
  }

  Future<GoalDetailResp> getGoalDetail(int id) async {
    final response = _api.getGoalDetail(id);
    return response;
  }

  Future<GoalDeleteResp> deleteGoals(List<int> ids) async {
    final response = _api.deleteGoals(ids);
    return response;
  }
}