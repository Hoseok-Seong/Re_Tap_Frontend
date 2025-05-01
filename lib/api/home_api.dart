import 'package:dio/dio.dart';
import '../dto/home/home_resp.dart';

class HomeApi {
  final Dio _dio;

  HomeApi(this._dio);

  Future<HomeResp> getHome() async {
    final response = await _dio.get('/api/v1/home');
    return HomeResp.fromJson(response.data);
  }
}