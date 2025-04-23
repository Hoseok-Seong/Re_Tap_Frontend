import '../api/letter_api.dart';
import '../dto/letter/letter_create_req.dart';
import '../dto/letter/letter_create_resp.dart';

class LetterService {
  final LetterApi _api;

  LetterService(this._api);

  Future<LetterCreateResp> create(LetterCreateReq request) async {
    final response = _api.createLetter(request);

    return response;
  }
}