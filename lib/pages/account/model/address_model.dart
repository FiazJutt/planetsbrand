class AddressResponse {
  int statusCode;
  int status;
  List<UserAddress> addresses;

  AddressResponse({
    required this.statusCode,
    required this.status,
    required this.addresses,
  });

  factory AddressResponse.fromJson(Map<String?, dynamic> json) {
    return AddressResponse(
      statusCode: json['status_code'],
      status: json['status'],
      addresses:
          (json['addresses'] as List<dynamic>)
              .map((e) => UserAddress.fromJson(e))
              .toList(),
    );
  }
}

class UserAddress {
  int? id;
  int? userId;
  String? type;
  String? country;
  String? province;
  String? city;
  String? address;
  String? zip;
  String? lat;
  String? lng;
  String? json;
  bool isDefault;
  DateTime createdAt;
  DateTime updatedAt;

  UserAddress({
    required this.id,
    required this.userId,
    required this.type,
    required this.country,
    required this.province,
    required this.city,
    required this.address,
    required this.zip,
    required this.lat,
    required this.lng,
    this.json,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAddress.fromJson(Map<String?, dynamic> json) {
    return UserAddress(
      id: json['id'],
      userId: int.parse(json['user_id']),
      type: json['type'] ?? '',
      country: json['country'] ?? '',
      province: json['province'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      zip: json['zip']?.toString(), // ✅ Fix here
      lat: json['lat'] ?? '',
      lng: json['lng'] ?? '',
      isDefault: json['default'].toString() == '1',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
