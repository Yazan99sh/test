import 'package:yes_order/module_about/repository/about_repository.dart';
import 'package:yes_order/module_about/request/create_appointment_request.dart';
import 'package:inject/inject.dart';

@provide
class AboutManager {
  final AboutRepository _aboutRepository;
  AboutManager(this._aboutRepository);
  dynamic createAppointment(CreateAppointmentRequest request) => _aboutRepository.createAboutAppointment(request);
}