import 'package:dio/dio.dart';
import 'package:future_letter/dto/user/update_profile_req.dart';
import 'package:future_letter/dto/user/update_profile_resp.dart';
import 'package:future_letter/dto/user/with_draw_resp.dart';

class UserApi {
  final Dio _dio;

  UserApi(this._dio);

  Future<UpdateProfileResp> updateProfile(UpdateProfileReq request) async {
    final response = await _dio.post('/api/v1/user/profile', data: request.toJson());
    return UpdateProfileResp.fromJson(response.data);
  }

  Future<WithDrawResp> withdraw() async {
    final response = await _dio.post('/api/v1/user/withdraw');
    return WithDrawResp.fromJson(response.data);
  }
}