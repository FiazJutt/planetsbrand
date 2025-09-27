class GroceriesModel {
  int? statusCode;
  int? status;
  List<Data>? data;

  GroceriesModel({this.statusCode, this.status, this.data});

  GroceriesModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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

  Data({
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
  });

  Data.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
