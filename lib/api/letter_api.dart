import 'package:dio/dio.dart';
import 'package:future_letter/dto/letter/letter_create_resp.dart';
import '../dto/letter/letter_create_req.dart';
import '../dto/letter/letter_delete_req.dart';
import '../dto/letter/letter_delete_resp.dart';
import '../dto/letter/letter_detail_resp.dart';
import '../dto/letter/letter_list_resp.dart';

class LetterApi {
  final Dio _dio;

  LetterApi(this._dio);

  Future<LetterCreateResp> createOrUpdateLetter(LetterCreateReq request) async {
    final response = await _dio.post('/api/v1/letters', data: request.toJson());
    return LetterCreateResp.fromJson(response.data);
  }

  Future<LetterListResp> getLetters() async {
    final response = await _dio.get('/api/v1/letters');
    return LetterListResp.fromJson(response.data);
  }

  Future<LetterDetailResp> getLetterDetail(int id) async {
    final response = await _dio.get('/api/v1/letters/$id');
    return LetterDetailResp.fromJson(response.data);
  }

  Future<LetterDeleteResp> deleteLetters(List<int> ids) async {
    final response = await _dio.post('/api/v1/letters/delete', data: LetterDeleteReq(letterIds: ids).toJson());
    return LetterDeleteResp.fromJson(response.data);
  }
}