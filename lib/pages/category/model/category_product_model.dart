class CategoryProductModel {
  int? statusCode;
  int? status;
  List<Products>? products;
  Category? category;
  List<Subcats>? subcats;

  CategoryProductModel({
    this.statusCode,
    this.status,
    this.products,
    this.category,
    this.subcats,
  });

  CategoryProductModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['subcats'] != null) {
      subcats = <Subcats>[];
      json['subcats'].forEach((v) {
        subcats!.add(Subcats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (subcats != null) {
      data['subcats'] = subcats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  int? categoryId;
  int? subcategoryId;
  int? childcategoryId;
  String? userId;
  String? name;
  String? photo;
  String? size;
  String? color;
  int? cprice;
  int? pprice;
  String? description;
  String? stock;
  String? policy;
  String? status;
  String? views;
  String? tags;
  String? featured;
  String? best;
  String? top;
  String? hot;
  String? latest;
  String? big;
  String? festival;
  String? dealOfTheDay;
  String? shopStatus;
  String? features;
  String? colors;
  String? productCondition;
  String? ship;
  String? isMeta;
  String? metaTag;
  String? metaDescription;
  String? youtube;
  String? type;
  String? file;
  String? license;
  String? licenseQty;
  String? link;
  String? platform;
  String? region;
  String? metaTitle;
  String? metaKeyword;
  String? licenceType;
  String? measure;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? imageUrl;

  Products({
    this.id,
    this.categoryId,
    this.subcategoryId,
    this.childcategoryId,
    this.userId,
    this.name,
    this.photo,
    this.size,
    this.color,
    this.cprice,
    this.pprice,
    this.description,
    this.stock,
    this.policy,
    this.status,
    this.views,
    this.tags,
    this.featured,
    this.best,
    this.top,
    this.hot,
    this.latest,
    this.big,
    this.festival,
    this.dealOfTheDay,
    this.shopStatus,
    this.features,
    this.colors,
    this.productCondition,
    this.ship,
    this.isMeta,
    this.metaTag,
    this.metaDescription,
    this.youtube,
    this.type,
    this.file,
    this.license,
    this.licenseQty,
    this.link,
    this.platform,
    this.region,
    this.metaTitle,
    this.metaKeyword,
    this.licenceType,
    this.measure,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.imageUrl,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    childcategoryId = json['childcategory_id'];
    userId = json['user_id'];
    name = json['name'];
    photo = json['photo'];
    size = json['size'];
    color = json['color'];
    cprice = json['cprice'];
    pprice = json['pprice'];
    description = json['description'];
    stock = json['stock'];
    policy = json['policy'];
    status = json['status'];
    views = json['views'];
    tags = json['tags'];
    featured = json['featured'];
    best = json['best'];
    top = json['top'];
    hot = json['hot'];
    latest = json['latest'];
    big = json['big'];
    festival = json['festival'];
    dealOfTheDay = json['deal_of_the_day'];
    shopStatus = json['shop_status'];
    features = json['features'];
    colors = json['colors'];
    productCondition = json['product_condition'];
    ship = json['ship'];
    isMeta = json['is_meta'];
    metaTag = json['meta_tag'];
    metaDescription = json['meta_description'];
    youtube = json['youtube'];
    type = json['type'];
    file = json['file'];
    license = json['license'];
    licenseQty = json['license_qty'];
    link = json['link'];
    platform = json['platform'];
    region = json['region'];
    metaTitle = json['meta_title'];
    metaKeyword = json['meta_keyword'];
    licenceType = json['licence_type'];
    measure = json['measure'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['subcategory_id'] = subcategoryId;
    data['childcategory_id'] = childcategoryId;
    data['user_id'] = userId;
    data['name'] = name;
    data['photo'] = photo;
    data['size'] = size;
    data['color'] = color;
    data['cprice'] = cprice;
    data['pprice'] = pprice;
    data['description'] = description;
    data['stock'] = stock;
    data['policy'] = policy;
    data['status'] = status;
    data['views'] = views;
    data['tags'] = tags;
    data['featured'] = featured;
    data['best'] = best;
    data['top'] = top;
    data['hot'] = hot;
    data['latest'] = latest;
    data['big'] = big;
    data['festival'] = festival;
    data['deal_of_the_day'] = dealOfTheDay;
    data['shop_status'] = shopStatus;
    data['features'] = features;
    data['colors'] = colors;
    data['product_condition'] = productCondition;
    data['ship'] = ship;
    data['is_meta'] = isMeta;
    data['meta_tag'] = metaTag;
    data['meta_description'] = metaDescription;
    data['youtube'] = youtube;
    data['type'] = type;
    data['file'] = file;
    data['license'] = license;
    data['license_qty'] = licenseQty;
    data['link'] = link;
    data['platform'] = platform;
    data['region'] = region;
    data['meta_title'] = metaTitle;
    data['meta_keyword'] = metaKeyword;
    data['licence_type'] = licenceType;
    data['measure'] = measure;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['image_url'] = imageUrl;
    return data;
  }
}

class Category {
  int? id;
  String? catName;
  String? catSlug;
  String? status;
  String? type;
  String? photo;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? imageUrl;

  Category({
    this.id,
    this.catName,
    this.catSlug,
    this.status,
    this.type,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.imageUrl,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catName = json['cat_name'];
    catSlug = json['cat_slug'];
    status = json['status'];
    type = json['type'];
    photo = json['photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    imageUrl = json['image_url'];
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
    data['image_url'] = imageUrl;
    return data;
  }
}

class Subcats {
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

  Subcats({
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

  Subcats.fromJson(Map<String, dynamic> json) {
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
