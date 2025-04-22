import 'package:dio/dio.dart';
import '../dto/letter/letter_create_req.dart';

class LetterApi {
  final Dio _dio;

  LetterApi(this._dio);

  Future<int> createLetter(LetterCreateReq req) async {
    final res = await _dio.post('/api/v1/letters', data: req.toJson());
    return res.data['letterId'];
  }
}