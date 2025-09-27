class ShopModel {
  List<Data>? data;
  int? currentPage;
  int? lastPage;
  int? total;
  int? perPage;

  ShopModel({
    this.data,
    this.currentPage,
    this.lastPage,
    this.total,
    this.perPage,
  });

  ShopModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    total = json['total'];
    perPage = json['per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['total'] = total;
    data['per_page'] = perPage;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? shopName;
  String? photo;
  String? address;
  String? furl;
  String? gurl;
  String? turl;
  String? lurl;
  String? iurl;
  String? wurl;

  Data({
    this.id,
    this.name,
    this.shopName,
    this.photo,
    this.address,
    this.furl,
    this.gurl,
    this.turl,
    this.lurl,
    this.iurl,
    this.wurl,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shopName = json['shop_name'];
    photo = json['photo'];
    address = json['address'];
    furl = json['furl'];
    gurl = json['gurl'];
    turl = json['turl'];
    lurl = json['lurl'];
    iurl = json['iurl'];
    wurl = json['wurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['shop_name'] = shopName;
    data['photo'] = photo;
    data['address'] = address;
    data['furl'] = furl;
    data['gurl'] = gurl;
    data['turl'] = turl;
    data['lurl'] = lurl;
    data['iurl'] = iurl;
    data['wurl'] = wurl;
    return data;
  }
}
