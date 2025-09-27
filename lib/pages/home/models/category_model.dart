class CategoryModel {
  int? statusCode;
  int? status;
  List<Categories>? categories;

  CategoryModel({this.statusCode, this.status, this.categories});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? catName;
  String? catSlug;
  String? status;
  String? type;
  String? photo;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Subs>? subs;

  Categories({
    this.id,
    this.catName,
    this.catSlug,
    this.status,
    this.type,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subs,
  });

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catName = json['cat_name'];
    catSlug = json['cat_slug'];
    status = json['status'];
    type = json['type'];
    photo = json['photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['subs'] != null) {
      subs = <Subs>[];
      json['subs'].forEach((v) {
        subs!.add(Subs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cat_name'] = catName;
    data['cat_slug'] = catSlug;
    data['status'] = status;
    data['type'] = type;
    data['photo'] = photo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (subs != null) {
      data['subs'] = subs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subs {
  int? id;
  String? categoryId;
  String? subName;
  String? subSlug;
  String? photo;
  String? percentage;
  String? salesTax;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Subs({
    this.id,
    this.categoryId,
    this.subName,
    this.subSlug,
    this.photo,
    this.percentage,
    this.salesTax,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Subs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subName = json['sub_name'];
    subSlug = json['sub_slug'];
    photo = json['photo'];
    percentage = json['percentage'];
    salesTax = json['sales_tax'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['sub_name'] = subName;
    data['sub_slug'] = subSlug;
    data['photo'] = photo;
    data['percentage'] = percentage;
    data['sales_tax'] = salesTax;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
