import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planetbrand/pages/auth/login_screen.dart';
import 'package:planetbrand/pages/landing/landing_screen.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';
import 'package:planetbrand/utils/local_stoarge.dart';

class AuthController extends GetxController {
  // Text Editing Controllers
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController confPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  // State Management
  RxBool showPassword = true.obs;
  RxBool showConfPassword = true.obs;
  RxBool checkTermsCondition = false.obs;
  RxBool loader = false.obs;

  // Google SignIn
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? user;

  // Sign Up
  Future<void> signUp() async {
    if (nameController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Your Full Name");
    } else if (emailController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Your Email");
    } else if (passwordController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Your Password");
    } else if (passwordController.text != confPasswordController.text) {
      errorSnackBar(message: "Your Password & Confirm Password do not match");
    } else if (!checkTermsCondition.value) {
      errorSnackBar(message: "Please accept the Terms & Conditions");
    } else {
      try {
        loader(true);
        final response = await ApiHelper.postRequest(registerEndPoint, {
          "name": nameController.text.trim(),
          'email': emailController.text.trim(),
          "password": passwordController.text.trim(),
          "c_password": passwordController.text.trim(),
        });

        final responseData = jsonDecode(response.body);
        if (responseData['status_code'] == 200) {
          nameController.clear();
          confPasswordController.clear();
          Get.to(() => LoginScreen());
          successSnackBar(message: responseData['message']);
        } else {
          errorSnackBar(message: responseData['message']);
        }
      } catch (e) {
        log("SignUp Error: $e");
      } finally {
        loader(false);
      }
    }
  }

  // Sign In
  Future<void> signin() async {
    if (emailController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Your Email");
    } else if (passwordController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Your Password");
    } else {
      try {
        loader(true);
        final response = await ApiHelper.postRequest(loginEndPoint, {
          'email': emailController.text.trim(),
          "password": passwordController.text.trim(),
        });

        final responseData = jsonDecode(response.body);
        if (responseData['status_code'] == 200) {
          LocalStorage.setEmailAddress(
            emailAddress: emailController.text.trim(),
          );
          LocalStorage.setPassword(password: passwordController.text.trim());
          LocalStorage.setToken(token: responseData['access_token']);
          LocalStorage.setUserID(userID: responseData['customer']['id']);

          Get.to(() => LandingScreen());
          emailController.clear();
          passwordController.clear();
          successSnackBar(message: "Login Successfully");
        } else {
          errorSnackBar(message: responseData['message']);
        }
      } catch (e) {
        log("Signin Error: $e");
      } finally {
        loader(false);
      }
    }
  }

  // Forgot Password
  Future<void> forgotPassword() async {
    if (emailController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Your Email");
    } else {
      try {
        loader(true);
        final response = await ApiHelper.postRequest(forgotPasswodEndPoint, {
          'email': emailController.text.trim(),
        });

        final responseData = jsonDecode(response.body);
        if (responseData['status_code'] == 200) {
          Get.to(() => LoginScreen());
          emailController.clear();
          successSnackBar(message: responseData['message']);
        } else {
          errorSnackBar(message: responseData['message']);
        }
      } catch (e) {
        log("Forgot Password Error: $e");
      } finally {
        loader(false);
      }
    }
  }

  // Google Login
  Future<void> googleLogin() async {
    try {
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        log("Google login cancelled by user");
        return;
      }

      user = googleUser;
      final googleAuth = await googleUser.authentication;

      log("Google Access Token: ${googleAuth.accessToken}");
      log("Google ID Token: ${googleAuth.idToken}");

      var data = {
        "email": googleUser.email,
        "user_type": "customer",
        "name": googleUser.displayName ?? googleUser.email,
        "login_with": "google",
      };

      await postThirdPartyLogin(data);
    } catch (e) {
      log("Google Login Error: $e");
    }
  }

  // Facebook Login
  Future<void> facebookLogin() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        log("Facebook User Email: $userData");

        var data = {
          "email": userData['email'],
          "user_type": "customer",
          "name": userData['name'] ?? userData['email'],
          "login_with": "facebook",
        };

        await postThirdPartyLogin(data);
      } else {
        errorSnackBar(message: loginResult.message ?? "Facebook login failed");
        log("Facebook Login Failed: ${loginResult.message}");
      }
    } catch (e) {
      log("Facebook Login Error: $e");
    }
  }

  // Third Party Login (Google/Facebook)
  Future<void> postThirdPartyLogin(Map<String, dynamic> bodyData) async {
    try {
      loader(true);
      final response = await ApiHelper.postRequest(
        thirdPartyLoginEndPoint,
        bodyData,
      );
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        log("Third Party Login Success: $jsonData");

        // Store user data
        LocalStorage.setEmailAddress(emailAddress: bodyData['email']);
        LocalStorage.setToken(token: jsonData['access_token']);
        LocalStorage.setUserID(userID: jsonData['customer']['id']);

        Get.to(() => LandingScreen());
        successSnackBar(message: "Login Successfully");
      } else {
        errorSnackBar(
          message: jsonData['message'] ?? "Third party login failed",
        );
        log("Third Party Login Failed: $jsonData");
      }
    } catch (e) {
      log("Third Party Login Error: $e");
    } finally {
      loader(false);
    }
  }
}
