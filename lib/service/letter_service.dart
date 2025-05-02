import 'package:future_letter/dto/letter/letter_delete_resp.dart';

import '../api/letter_api.dart';
import '../dto/letter/letter_create_req.dart';
import '../dto/letter/letter_create_resp.dart';
import '../dto/letter/letter_detail_resp.dart';
import '../dto/letter/letter_list_resp.dart';

class LetterService {
  final LetterApi _api;

  LetterService(this._api);

  Future<LetterCreateResp> createOrUpdate(LetterCreateReq request) async {
    final response = _api.createOrUpdateLetter(request);
    return response;
  }

  Future<List<LetterSummary>> fetchLetterList() async {
    final response = await _api.getLetters();
    return response.letters;
  }

  Future<LetterDetailResp> getLetterDetail(int id) async {
    final response = _api.getLetterDetail(id);
    return response;
  }

  Future<LetterDeleteResp> deleteLetters(List<int> ids) async {
    final response = _api.deleteLetters(ids);
    return response;
  }
}