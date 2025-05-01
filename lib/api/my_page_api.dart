import 'package:dio/dio.dart';
import '../dto/mypage/my_page_resp.dart';

class MyPageApi {
  final Dio _dio;

  MyPageApi(this._dio);

  Future<MyPageResp> getMyPage() async {
    final response = await _dio.get('/api/v1/my-page');
    return MyPageResp.fromJson(response.data);
  }
}