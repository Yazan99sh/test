import 'package:yes_order/consts/urls.dart';
import 'package:yes_order/module_about/request/create_appointment_request.dart';
import 'package:yes_order/module_network/http_client/http_client.dart';
import 'package:inject/inject.dart';

@provide
class AboutRepository {
  final ApiClient _apiClient;
  AboutRepository(this._apiClient);

  dynamic createAboutAppointment(CreateAppointmentRequest request) {
    return _apiClient.post(Urls.APPOINTMENT_API, request.toJson());
  }
}