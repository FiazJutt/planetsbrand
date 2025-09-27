import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static Future<void> initStorage() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void setEmailAddress({required String emailAddress}) {
    prefs.setString('emailAddress', emailAddress);
  }

  static String? getEmailAddress() {
    return prefs.getString('emailAddress');
  }

  static void setPassword({required String password}) {
    prefs.setString('password', password);
  }

  static String? getPassword() {
    return prefs.getString('password');
  }

  static void setToken({required String token}) {
    prefs.setString('token', token);
  }

  static String? getToken() {
    return prefs.getString('token');
  }

  static void setUserID({required int userID}) {
    prefs.setInt('userID', userID);
  }

  static int? getUserID() {
    return prefs.getInt('userID');
  }

  // Clear all stored data
  static Future<void> clearAll() async {
    await prefs.clear();
  }
}
