class BrandProductModel {
  int? statusCode;
  int? status;
  String? message;
  String? brandId;
  List<Products>? products;
  int? currentPage;
  int? lastPage;
  int? total;
  int? perPage;

  BrandProductModel({
    this.statusCode,
    this.status,
    this.message,
    this.brandId,
    this.products,
    this.currentPage,
    this.lastPage,
    this.total,
    this.perPage,
  });

  BrandProductModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    brandId = json['brand_id'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    total = json['total'];
    perPage = json['per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    data['brand_id'] = brandId;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['total'] = total;
    data['per_page'] = perPage;
    return data;
  }
}

class Products {
  int? id;
  String? name;
  String? photo;
  dynamic cprice;
  dynamic pprice;
  bool? inCart;
  int? quantity;
  bool? isFavorite;
  int? reviews;
  int? categoryId;
  int? subcategoryId;
  int? childcategoryId;
  String? description;
  int? rating;

  Products({
    this.id,
    this.name,
    this.photo,
    this.cprice,
    this.pprice,
    this.inCart,
    this.quantity,
    this.isFavorite,
    this.reviews,
    this.categoryId,
    this.subcategoryId,
    this.childcategoryId,

    this.description,

    this.rating,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    cprice = json['cprice'];
    pprice = json['pprice'];
    inCart = json['in_cart'];
    quantity = json['quantity'];
    isFavorite = json['is_favorite'];
    reviews = json['reviews'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    childcategoryId = json['childcategory_id'];
    description = json['description'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    data['cprice'] = cprice;
    data['pprice'] = pprice;
    data['in_cart'] = inCart;
    data['quantity'] = quantity;
    data['is_favorite'] = isFavorite;
    data['reviews'] = reviews;
    data['category_id'] = categoryId;
    data['subcategory_id'] = subcategoryId;
    data['childcategory_id'] = childcategoryId;
    data['rating'] = rating;
    return data;
  }
}
