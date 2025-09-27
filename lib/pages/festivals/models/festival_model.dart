class FestivalModel {
  int? statusCode;
  int? status;
  List<FestivalList>? festivalList;
  int? currentPage;
  int? lastPage;
  int? total;
  int? perPage;

  FestivalModel({
    this.statusCode,
    this.status,
    this.festivalList,
    this.currentPage,
    this.lastPage,
    this.total,
    this.perPage,
  });

  FestivalModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    if (json['festivalList'] != null) {
      festivalList = <FestivalList>[];
      json['festivalList'].forEach((v) {
        festivalList!.add(FestivalList.fromJson(v));
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
    if (festivalList != null) {
      data['festivalList'] = festivalList!.map((v) => v.toJson()).toList();
    }
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['total'] = total;
    data['per_page'] = perPage;
    return data;
  }
}

class FestivalList {
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
  List<String>? size;
  int? rating;

  FestivalList({
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
    this.size,
    this.rating,
  });

  FestivalList.fromJson(Map<String, dynamic> json) {
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
    size = json['size'].cast<String>();
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
    data['size'] = size;
    data['rating'] = rating;
    return data;
  }
}
