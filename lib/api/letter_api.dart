import 'package:dio/dio.dart';
import 'package:future_letter/dto/letter/letter_create_resp.dart';
import '../dto/letter/letter_create_req.dart';

class LetterApi {
  final Dio _dio;

  LetterApi(this._dio);

  Future<LetterCreateResp> createOrUpdateLetter(LetterCreateReq request) async {
    final response = await _dio.post('/api/v1/letters', data: request.toJson());

    return LetterCreateResp.fromJson(response.data);
  }
}