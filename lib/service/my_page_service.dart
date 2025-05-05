import '../api/my_page_api.dart';
import '../dto/mypage/my_page_resp.dart';

class MyPageService {
  final MyPageApi _api;

  MyPageService(this._api);

  Future<MyPageResp> getMyPage() async {
    final response = await _api.getMyPage();
    return response;
  }
}