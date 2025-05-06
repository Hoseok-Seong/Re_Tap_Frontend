import 'package:dio/dio.dart';
import 'package:re_tap/dto/user/fcm_token_req.dart';
import 'package:re_tap/dto/user/fcm_token_resp.dart';
import '../dto/user/update_profile_req.dart';
import '../dto/user/update_profile_resp.dart';
import '../dto/user/with_draw_resp.dart';

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

  Future<FcmTokenResp> updateFcmToken(FcmTokenReq request) async {
    final response = await _dio.post('/api/v1/user/fcm-token', data: request.toJson());
    return FcmTokenResp.fromJson(response.data);
  }
}