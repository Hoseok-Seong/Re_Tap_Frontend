import 'package:future_letter/dto/user/update_profile_resp.dart';
import 'package:future_letter/dto/user/with_draw_resp.dart';

import '../api/user_api.dart';
import '../dto/user/update_profile_req.dart';

class UserService {
  final UserApi _api;

  UserService(this._api);

  Future<UpdateProfileResp> updateProfile({
    required String nickname,
  }) async {
    final request = UpdateProfileReq(
        nickname: nickname
    );

    final response = await _api.updateProfile(request);

    return response;
  }

  Future<WithDrawResp> withdraw() async {
    final response = await _api.withdraw();
    return response;
  }
}