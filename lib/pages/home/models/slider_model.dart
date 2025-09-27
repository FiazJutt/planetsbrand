class SliderModel {
  int? statusCode;
  int? status;
  List<String>? data;

  SliderModel({this.statusCode, this.status, this.data});

  SliderModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    status = json['status'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = statusCode;
    data['status'] = status;
    data['data'] = data;
    return data;
  }
}
