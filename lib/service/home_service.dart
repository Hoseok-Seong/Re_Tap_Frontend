import '../api/home_api.dart';
import '../dto/home/home_resp.dart';

class HomeService {
  final HomeApi _api;

  HomeService(this._api);

  Future<HomeResp> getHome() async {
    final response = await _api.getHome();
    return response;
  }
}