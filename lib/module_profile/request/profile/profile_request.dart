import 'package:yes_order/consts/urls.dart';

class ProfileRequest {
  String name;
  String phone;
  String image;
  String city;
  String branch;
  String car;
  String age;
  String drivingLicence;
  String state;
  String isOnline;

  ProfileRequest.empty();

  ProfileRequest({
    this.name,
    this.phone,
    this.image,
    this.city = 'Jedda',
    this.branch = '-1',
    this.car = 'Unknown',
    this.drivingLicence = 'Unknown',
    this.age,
    this.state = 'active',
    this.isOnline = 'active',
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['userName'] = this.name;
    data['name'] = this.name;
    data['phone'] = this.phone;
    if (this.image != null) {
      data['image'] = this.image.contains('http')
          ? this.image.substring(Urls.IMAGES_ROOT.length)
          : this.image;
    }
    data['city'] = this.city;
    data['branch'] = this.branch;
    data['car'] = this.car ?? 'Unknown';
    data['age'] = this.age;
    data['drivingLicence'] = this.drivingLicence;
    data['state'] = this.state;
    data['location'] = 'Unknown';
    data['isOnline'] = this.isOnline;
    return data;
  }
}
