class ProfileModel {
  int? statusCode;
  int? status;
  CustomerProfile? customerProfile;

  ProfileModel({this.statusCode, this.status, this.customerProfile});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    customerProfile =
        json['customer_profile'] != null
            ? CustomerProfile.fromJson(json['customer_profile'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (customerProfile != null) {
      data['customer_profile'] = customerProfile!.toJson();
    }
    return data;
  }
}

class CustomerProfile {
  int? id;
  String? name;
  int? coins;
  String? photo;
  String? gender;
  String? dob;
  String? zip;
  String? residency;
  String? city;
  String? address;
  String? phone;
  String? fax;
  String? email;
  String? emailVerifiedAt;
  String? isProvider;
  String? fUrl;
  String? gUrl;
  String? tUrl;
  String? lUrl;
  String? fCheck;
  String? tCheck;
  String? lCheck;
  String? googleId;
  String? forgetpasswordcode;
  String? codeexpireat;
  String? isRemoveRequest;
  String? status;
  String? createdAt;
  String? updatedAt;

  CustomerProfile({
    this.id,
    this.name,
    this.coins,
    this.photo,
    this.gender,
    this.dob,
    this.zip,
    this.residency,
    this.city,
    this.address,
    this.phone,
    this.fax,
    this.email,
    this.emailVerifiedAt,
    this.isProvider,
    this.fUrl,
    this.gUrl,
    this.tUrl,
    this.lUrl,
    this.fCheck,
    this.tCheck,
    this.lCheck,
    this.googleId,
    this.forgetpasswordcode,
    this.codeexpireat,
    this.isRemoveRequest,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  CustomerProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coins = json['coins'];
    photo = json['photo'];
    gender = json['gender'];
    dob = json['dob'];
    zip = json['zip'];
    residency = json['residency'];
    city = json['city'];
    address = json['address'];
    phone = json['phone'];
    fax = json['fax'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    isProvider = json['is_provider'];
    fUrl = json['f_url'];
    gUrl = json['g_url'];
    tUrl = json['t_url'];
    lUrl = json['l_url'];
    fCheck = json['f_check'];
    tCheck = json['t_check'];
    lCheck = json['l_check'];
    googleId = json['google_id'];
    forgetpasswordcode = json['forgetpasswordcode'];
    codeexpireat = json['codeexpireat'];
    isRemoveRequest = json['is_remove_request'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['coins'] = coins;
    data['photo'] = photo;
    data['gender'] = gender;
    data['dob'] = dob;
    data['zip'] = zip;
    data['residency'] = residency;
    data['city'] = city;
    data['address'] = address;
    data['phone'] = phone;
    data['fax'] = fax;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['is_provider'] = isProvider;
    data['f_url'] = fUrl;
    data['g_url'] = gUrl;
    data['t_url'] = tUrl;
    data['l_url'] = lUrl;
    data['f_check'] = fCheck;
    data['t_check'] = tCheck;
    data['l_check'] = lCheck;
    data['google_id'] = googleId;
    data['forgetpasswordcode'] = forgetpasswordcode;
    data['codeexpireat'] = codeexpireat;
    data['is_remove_request'] = isRemoveRequest;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
