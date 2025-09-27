class SearchProductModel {
  int? statusCode;
  int? status;
  int? currentPage;
  int? lastPage;
  int? total;
  List<Products>? products;

  SearchProductModel({
    this.statusCode,
    this.status,
    this.currentPage,
    this.lastPage,
    this.total,
    this.products,
  });

  SearchProductModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    total = json['total'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['total'] = total;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  String? name;
  String? photo;
  int? cprice;
  int? pprice;
  bool? inCart;
  int? quantity;
  bool? isFavorite;
  int? reviews;
  int? categoryId;
  int? subcategoryId;
  int? childcategoryId;
  List<String>? color;
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
    this.color,
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
    color = json['color'].cast<String>();
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
    data['color'] = color;
    data['description'] = description;
    data['rating'] = rating;
    return data;
  }
}
