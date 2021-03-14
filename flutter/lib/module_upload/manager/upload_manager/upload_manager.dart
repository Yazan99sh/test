import 'package:inject/inject.dart';
import 'package:yes_order/module_upload/repository/upload_repository/upload_repository.dart';
import 'package:yes_order/module_upload/response/imgbb/imgbb_response.dart';

@provide
class UploadManager {
  final UploadRepository _repository;
  UploadManager(this._repository);

  Future<ImgBBResponse> upload(String filePath) {
    return _repository.upload(filePath);
  }
}
