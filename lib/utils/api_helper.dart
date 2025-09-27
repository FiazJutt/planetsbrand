import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:planetbrand/no_internet_screen.dart';
import 'package:planetbrand/utils/config.dart';
import 'package:planetbrand/utils/local_stoarge.dart';

class ApiHelper {
  static postRequest(String endpoint, var body) async {
    const String baseUrl = kcBaseAPIUrl;
    final Uri url = Uri.parse("$baseUrl$endpoint");
    log("URL :: $url :: BODY :: $body");

    try {
      final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        log(
          "URL :: $url :: STATUS CODE :: ${response.statusCode} :: BODY :: $responseData",
        );
      } else {
        log(
          "URL :: $url :: STATUS CODE :: ${response.statusCode} :: BODY :: ${response.body}",
        );
      }
      return response;
    } on SocketException {
      Get.offAll(() => NoInternetScreen());
    } catch (e) {
      log("URL :: $url :: STATUS CODE :: $e :: BODY :: $body");
      rethrow;
    }
  }

  static postRequestWithToken(String endpoint, var body) async {
    const String baseUrl = kcBaseAPIUrl;
    final Uri url = Uri.parse("$baseUrl$endpoint");
    log("URL :: $url :: BODY :: $body");

    try {
      final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer ${LocalStorage.getToken().toString()}",
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        log(
          "URL :: $url :: STATUS CODE :: ${response.statusCode} :: BODY :: $responseData",
        );
      } else {
        log(
          "URL :: $url :: STATUS CODE :: ${response.statusCode} :: BODY :: ${response.body}",
        );
      }
      return response;
    } on SocketException {
      Get.offAll(() => NoInternetScreen());
    } catch (e) {
      log("URL :: $url :: STATUS CODE :: $e :: BODY :: $body");
      rethrow;
    }
  }

  static getRequest(String endpoint) async {
    const String baseUrl = kcBaseAPIUrl;
    final Uri url = Uri.parse("$baseUrl$endpoint");
    log("URL :: $url");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        log(
          "URL :: $url :: STATUS CODE :: ${response.statusCode} :: BODY :: $responseData",
        );
      } else {
        log(
          "URL :: $url :: STATUS CODE :: ${response.statusCode} :: BODY :: ${response.body}",
        );
      }
      return response;
    } on SocketException {
      Get.offAll(() => NoInternetScreen());
    } catch (e) {
      log("URL :: $url :: STATUS CODE :: $e");
      rethrow;
    }
  }

  static getRequestWithToken(String endpoint) async {
    const String baseUrl = kcBaseAPIUrl;
    final Uri url = Uri.parse("$baseUrl$endpoint");
    log("URL :: $url");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer ${LocalStorage.getToken().toString()}",
        },
      );
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        log(
          "URL :: $url :: STATUS CODE :: ${response.statusCode} :: BODY :: $responseData",
        );
      } else {
        log(
          "URL :: $url :: STATUS CODE :: ${response.statusCode} :: BODY :: ${response.body}",
        );
      }
      return response;
    } on SocketException {
      Get.offAll(() => NoInternetScreen());
    } catch (e) {
      log("URL :: $url :: STATUS CODE :: $e");
      rethrow;
    }
  }
}
