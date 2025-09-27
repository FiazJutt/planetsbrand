class CountriesModel {
  int? statusCode;
  int? status;
  List<Countries>? countries;

  CountriesModel({this.statusCode, this.status, this.countries});

  CountriesModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    if (json['countries'] != null) {
      countries = <Countries>[];
      json['countries'].forEach((v) {
        countries!.add(Countries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (countries != null) {
      data['countries'] = countries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Countries {
  String? country;
  String? image;
  List<Provinces>? provinces;

  Countries({this.country, this.image, this.provinces});

  Countries.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    image = json['image'];
    if (json['provinces'] != null) {
      provinces = <Provinces>[];
      json['provinces'].forEach((v) {
        provinces!.add(Provinces.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['image'] = image;
    if (provinces != null) {
      data['provinces'] = provinces!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Provinces {
  String? province;
  List<Cities>? cities;

  Provinces({this.province, this.cities});

  Provinces.fromJson(Map<String, dynamic> json) {
    province = json['province'];
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['province'] = province;
    if (cities != null) {
      data['cities'] = cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  String? city;

  Cities({this.city});

  Cities.fromJson(Map<String, dynamic> json) {
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    return data;
  }
}
