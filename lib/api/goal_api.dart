import 'package:dio/dio.dart';
import 'package:re_tap/dto/goal/goal_feedback_req.dart';
import 'package:re_tap/dto/goal/goal_feedback_resp.dart';

import '../dto/goal/goal_ceate_resp.dart';
import '../dto/goal/goal_create_req.dart';
import '../dto/goal/goal_delete_req.dart';
import '../dto/goal/goal_delete_resp.dart';
import '../dto/goal/goal_detail_resp.dart';
import '../dto/goal/goal_list_resp.dart';

class GoalApi {
  final Dio _dio;

  GoalApi(this._dio);

  Future<GoalCreateResp> createOrUpdateGoal(GoalCreateReq request) async {
    final response = await _dio.post('/api/v1/goals', data: request.toJson());
    return GoalCreateResp.fromJson(response.data);
  }

  Future<GoalListResp> getGoals() async {
    final response = await _dio.get('/api/v1/goals');
    return GoalListResp.fromJson(response.data);
  }

  Future<GoalDetailResp> getGoalDetail(int id) async {
    final response = await _dio.get('/api/v1/goals/$id');
    return GoalDetailResp.fromJson(response.data);
  }

  Future<GoalDeleteResp> deleteGoals(List<int> ids) async {
    final response = await _dio.post('/api/v1/goals/delete', data: GoalDeleteReq(goalIds: ids).toJson());
    return GoalDeleteResp.fromJson(response.data);
  }

  Future<GoalFeedbackResp> feedbackGoal(GoalFeedbackReq request) async {
    final response = await _dio.post('/api/v1/goals/feedback', data: request.toJson());
    return GoalFeedbackResp.fromJson(response.data);
  }
}