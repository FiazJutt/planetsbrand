class ShopAndProductModel {
  int? statusCode;
  int? status;
  String? message;
  Topshop? topshop;

  ShopAndProductModel({
    this.statusCode,
    this.status,
    this.message,
    this.topshop,
  });

  ShopAndProductModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    topshop =
        json['topshop'] != null ? Topshop.fromJson(json['topshop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (topshop != null) {
      data['topshop'] = topshop!.toJson();
    }
    return data;
  }
}

class Topshop {
  int? id;
  String? frenchiseId;
  String? subHeadOfficeId;
  String? name;
  String? photo;
  String? gender;
  String? dob;
  String? zip;
  String? residency;
  String? country;
  String? state;
  String? city;
  String? address;
  String? province;
  String? phone;
  String? fax;
  String? email;
  String? emailVerifiedAt;
  String? isProvider;
  String? shopName;
  String? ownerName;
  String? shopNumber;
  String? shopAddress;
  String? regNumber;
  String? shopMessage;
  String? isVendor;
  String? shopDetails;
  String? wholesaler;
  String? fUrl;
  String? gUrl;
  String? tUrl;
  String? lUrl;
  String? iUrl;
  String? wUrl;
  String? wCheck;
  String? fCheck;
  String? tCheck;
  String? lCheck;
  String? iCheck;
  String? shippingCost;
  String? currentBalance;
  String? affilateCode;
  String? affilateIncome;
  String? top;
  String? brand;
  String? grocery;
  String? topByCategory;
  String? navShop;
  String? topRated;
  String? logo;
  String? gCheck;
  String? vType;
  String? date;
  String? comingShop;
  String? mailSent;
  String? createdAt;
  String? updatedAt;
  String? stripeId;
  String? cardBrand;
  String? cardLastFour;
  String? trialEndsAt;
  String? forgetpasswordcode;
  String? codeexpireat;
  String? gif;
  String? gif1;
  String? gif2;
  String? saleTax;
  String? isRemoveRequest;
  List<Products>? products;
  int? totalproducts;
  int? overallrating;

  Topshop({
    this.id,
    this.frenchiseId,
    this.subHeadOfficeId,
    this.name,
    this.photo,
    this.gender,
    this.dob,
    this.zip,
    this.residency,
    this.country,
    this.state,
    this.city,
    this.address,
    this.province,
    this.phone,
    this.fax,
    this.email,
    this.emailVerifiedAt,
    this.isProvider,
    this.shopName,
    this.ownerName,
    this.shopNumber,
    this.shopAddress,
    this.regNumber,
    this.shopMessage,
    this.isVendor,
    this.shopDetails,
    this.wholesaler,
    this.fUrl,
    this.gUrl,
    this.tUrl,
    this.lUrl,
    this.iUrl,
    this.wUrl,
    this.wCheck,
    this.fCheck,
    this.tCheck,
    this.lCheck,
    this.iCheck,
    this.shippingCost,
    this.currentBalance,
    this.affilateCode,
    this.affilateIncome,
    this.top,
    this.brand,
    this.grocery,
    this.topByCategory,
    this.navShop,
    this.topRated,
    this.logo,
    this.gCheck,
    this.vType,
    this.date,
    this.comingShop,
    this.mailSent,
    this.createdAt,
    this.updatedAt,
    this.stripeId,
    this.cardBrand,
    this.cardLastFour,
    this.trialEndsAt,
    this.forgetpasswordcode,
    this.codeexpireat,
    this.gif,
    this.gif1,
    this.gif2,
    this.saleTax,
    this.isRemoveRequest,
    this.products,
    this.totalproducts,
    this.overallrating,
  });

  Topshop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    frenchiseId = json['frenchise_id'];
    subHeadOfficeId = json['sub_head_office_id'];
    name = json['name'];
    photo = json['photo'];
    gender = json['gender'];
    dob = json['dob'];
    zip = json['zip'];
    residency = json['residency'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    province = json['province'];
    phone = json['phone'];
    fax = json['fax'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    isProvider = json['is_provider'];
    shopName = json['shop_name'];
    ownerName = json['owner_name'];
    shopNumber = json['shop_number'];
    shopAddress = json['shop_address'];
    regNumber = json['reg_number'];
    shopMessage = json['shop_message'];
    isVendor = json['is_vendor'];
    shopDetails = json['shop_details'];
    wholesaler = json['wholesaler'];
    fUrl = json['f_url'];
    gUrl = json['g_url'];
    tUrl = json['t_url'];
    lUrl = json['l_url'];
    iUrl = json['i_url'];
    wUrl = json['w_url'];
    wCheck = json['w_check'];
    fCheck = json['f_check'];
    tCheck = json['t_check'];
    lCheck = json['l_check'];
    iCheck = json['i_check'];
    shippingCost = json['shipping_cost'];
    currentBalance = json['current_balance'];
    affilateCode = json['affilate_code'];
    affilateIncome = json['affilate_income'];
    top = json['top'];
    brand = json['brand'];
    grocery = json['grocery'];
    topByCategory = json['top_by_category'];
    navShop = json['nav_shop'];
    topRated = json['top_rated'];
    logo = json['logo'];
    gCheck = json['g_check'];
    vType = json['v_type'];
    date = json['date'];
    comingShop = json['coming_shop'];
    mailSent = json['mail_sent'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    stripeId = json['stripe_id'];
    cardBrand = json['card_brand'];
    cardLastFour = json['card_last_four'];
    trialEndsAt = json['trial_ends_at'];
    forgetpasswordcode = json['forgetpasswordcode'];
    codeexpireat = json['codeexpireat'];
    gif = json['gif'];
    gif1 = json['gif1'];
    gif2 = json['gif2'];
    saleTax = json['sale_tax'];
    isRemoveRequest = json['is_remove_request'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    totalproducts = json['totalproducts'];
    overallrating = json['overallrating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['frenchise_id'] = frenchiseId;
    data['sub_head_office_id'] = subHeadOfficeId;
    data['name'] = name;
    data['photo'] = photo;
    data['gender'] = gender;
    data['dob'] = dob;
    data['zip'] = zip;
    data['residency'] = residency;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['address'] = address;
    data['province'] = province;
    data['phone'] = phone;
    data['fax'] = fax;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['is_provider'] = isProvider;
    data['shop_name'] = shopName;
    data['owner_name'] = ownerName;
    data['shop_number'] = shopNumber;
    data['shop_address'] = shopAddress;
    data['reg_number'] = regNumber;
    data['shop_message'] = shopMessage;
    data['is_vendor'] = isVendor;
    data['shop_details'] = shopDetails;
    data['wholesaler'] = wholesaler;
    data['f_url'] = fUrl;
    data['g_url'] = gUrl;
    data['t_url'] = tUrl;
    data['l_url'] = lUrl;
    data['i_url'] = iUrl;
    data['w_url'] = wUrl;
    data['w_check'] = wCheck;
    data['f_check'] = fCheck;
    data['t_check'] = tCheck;
    data['l_check'] = lCheck;
    data['i_check'] = iCheck;
    data['shipping_cost'] = shippingCost;
    data['current_balance'] = currentBalance;
    data['affilate_code'] = affilateCode;
    data['affilate_income'] = affilateIncome;
    data['top'] = top;
    data['brand'] = brand;
    data['grocery'] = grocery;
    data['top_by_category'] = topByCategory;
    data['nav_shop'] = navShop;
    data['top_rated'] = topRated;
    data['logo'] = logo;
    data['g_check'] = gCheck;
    data['v_type'] = vType;
    data['date'] = date;
    data['coming_shop'] = comingShop;
    data['mail_sent'] = mailSent;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['stripe_id'] = stripeId;
    data['card_brand'] = cardBrand;
    data['card_last_four'] = cardLastFour;
    data['trial_ends_at'] = trialEndsAt;
    data['forgetpasswordcode'] = forgetpasswordcode;
    data['codeexpireat'] = codeexpireat;
    data['gif'] = gif;
    data['gif1'] = gif1;
    data['gif2'] = gif2;
    data['sale_tax'] = saleTax;
    data['is_remove_request'] = isRemoveRequest;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['totalproducts'] = totalproducts;
    data['overallrating'] = overallrating;
    return data;
  }
}

class Products {
  int? id;
  int? categoryId;
  int? subcategoryId;
  String? childcategoryId;
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
  int? ratings;

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
    this.ratings,
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
    ratings = json['ratings'];
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
    data['ratings'] = ratings;
    return data;
  }
}
