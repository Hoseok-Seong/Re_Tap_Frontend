import '../api/letter_api.dart';
import '../dto/letter/letter_create_req.dart';

class LetterService {
  final LetterApi _api;

  LetterService(this._api);

  Future<int> create(LetterCreateReq req) async {
    return _api.createLetter(req);
  }
}