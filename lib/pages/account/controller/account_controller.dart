import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:planetbrand/pages/account/model/address_model.dart';
import 'package:planetbrand/pages/account/model/profile_model.dart';
import 'package:planetbrand/pages/auth/login_screen.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';
import 'package:planetbrand/utils/local_stoarge.dart';

class AccountController extends GetxController {
  RxBool loader = false.obs;
  Rx<ProfileModel?> profileModel = Rx(null);

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  RxString gender = "".obs;
  RxBool showPassword = true.obs;
  RxBool showConfPassword = true.obs;
  RxBool showNewPassword = true.obs;

  TextEditingController countryController = TextEditingController();
  TextEditingController addressCityController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController addressNameController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  RxString selectAddressType = "".obs;
  RxBool isDefault = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
    getAddress();
  }

  getProfile() async {
    try {
      loader(true);
      final response = await ApiHelper.postRequestWithToken(
        customerProfileEndPoint,
        {'customer_id': LocalStorage.getUserID().toString()},
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        profileModel.value = ProfileModel.fromJson(responseData);
        nameController.text = profileModel.value?.customerProfile?.name ?? "";
        emailController.text = profileModel.value?.customerProfile?.email ?? "";
        phoneController.text = profileModel.value?.customerProfile?.phone ?? "";
        addressController.text =
            profileModel.value?.customerProfile?.address ?? "";
        cityController.text = profileModel.value?.customerProfile?.city ?? "";
        gender.value = profileModel.value?.customerProfile?.gender ?? "";
      } else {
        log("CUSTOMER PROFILE :: $responseData");
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }

  changePassword() async {
    if (oldPasswordController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Your Current Password");
    } else if (newPasswordController.text.isEmpty) {
      errorSnackBar(message: "Please Enter New Password");
    } else if (newPasswordController.text != confirmPasswordController.text) {
      errorSnackBar(message: "Your New and Confirm Password Not Matched");
    } else {
      try {
        loader(true);
        final response = await ApiHelper.postRequestWithToken(
          customerChangePasswordEndPoint,
          {
            'customer_id': LocalStorage.getUserID().toString(),
            "current_password": oldPasswordController.text,
            "new_password": newPasswordController.text,
          },
        );
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == "Successfully updated your password") {
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
          successSnackBar(message: responseData['success']);
          Get.offAll(() => LoginScreen());
        } else {
          errorSnackBar(message: responseData['unsuccess']);
          log("CUSTOMER PROFILE :: $responseData");
        }
      } catch (e) {
        rethrow;
      } finally {
        loader(false);
      }
    }
  }

  updateProfile() async {
    if (nameController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Name");
    } else if (emailController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Email");
    } else if (gender.value.isEmpty) {
      errorSnackBar(message: "Please Select Gender");
    } else if (phoneController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Phone Number");
    } else if (cityController.text.isEmpty) {
      errorSnackBar(message: "Please Enter City Name");
    } else if (addressController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Your Address");
    } else {
      try {
        loader(true);
        final response =
            await ApiHelper.postRequestWithToken(customerEditProfileEndPoint, {
              "name": nameController.text,
              "email": emailController.text,
              "gender": gender.value,
              "city": cityController.text,
              "address": addressController.text,
              "phone": phoneController.text,
            });
        final responseData = jsonDecode(response.body);
        if (responseData['status_code'] == 200) {
          nameController.clear();
          emailController.clear();
          cityController.clear();
          addressController.clear();
          phoneController.clear();
          gender.value = "";
          Get.back();
          getProfile();
          infoSnackBar(message: responseData['success']);
        } else {
          // errorSnackBar(message: responseData['message']);
          log("customerEditProfileEndPoint :: $responseData");
        }
      } catch (e) {
        rethrow;
      } finally {
        loader(false);
      }
    }
  }

  RxBool addressLoader = false.obs;
  Rx<AddressResponse?> addressResponse = Rx(null);

  getAddress() async {
    try {
      addressLoader(true);
      final response = await ApiHelper.getRequestWithToken(
        userAddressesEndPoint,
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        addressResponse.value = AddressResponse.fromJson(responseData);
      } else {
        log("userAddressesEndPoint  :: $responseData");
      }
    } catch (e) {
      rethrow;
    } finally {
      addressLoader(false);
    }
  }

  RxBool saveLoader = false.obs;
  saveAddress() async {
    if (selectAddressType.value.isEmpty) {
      errorSnackBar(message: "Please Select Address Type");
    } else if (countryController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Country Name");
    } else if (provinceController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Province Name");
    } else if (addressCityController.text.isEmpty) {
      errorSnackBar(message: "Please Enter City Name");
    } else if (addressNameController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Address");
    } else {
      try {
        saveLoader(true);
        final response =
            await ApiHelper.postRequestWithToken(userManageAddressEndPoint, {
              "type": selectAddressType.value,
              "country": countryController.text,
              "province": provinceController.text,
              "city": addressCityController.text,
              "address": addressNameController.text,
              "zip": zipController.text,
              "default": isDefault.value,
            });
        final responseData = jsonDecode(response.body);
        if (responseData['status_code'] == 200) {
          getAddress();
          Get.back();
          clearFields();
          successSnackBar(message: responseData['message']);
        } else {
          errorSnackBar(message: responseData['message']);
        }
      } catch (e) {
        rethrow;
      } finally {
        saveLoader(false);
      }
    }
  }

  RxBool updateLoader = false.obs;
  updateAddress({required int id}) async {
    if (selectAddressType.value.isEmpty) {
      errorSnackBar(message: "Please Select Address Type");
    } else if (countryController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Country Name");
    } else if (provinceController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Province Name");
    } else if (addressCityController.text.isEmpty) {
      errorSnackBar(message: "Please Enter City Name");
    } else if (addressNameController.text.isEmpty) {
      errorSnackBar(message: "Please Enter Address");
    } else {
      try {
        updateLoader(true);
        final response =
            await ApiHelper.postRequestWithToken(userManageAddressEndPoint, {
              "id": id,
              "type": selectAddressType.value,
              "country": countryController.text,
              "province": provinceController.text,
              "city": addressCityController.text,
              "address": addressNameController.text,
              "zip": zipController.text,
              "default": isDefault.value,
            });
        final responseData = jsonDecode(response.body);
        if (responseData['status_code'] == 200) {
          getAddress();
          Get.back();
          clearFields();
          successSnackBar(message: responseData['message']);
        } else {
          errorSnackBar(message: responseData['message']);
        }
      } catch (e) {
        rethrow;
      } finally {
        updateLoader(false);
      }
    }
  }

  deleteAddress({required int id}) async {
    try {
      addressLoader(true);
      final response = await ApiHelper.postRequestWithToken(
        userDeleteAddressEndPoint,
        {'id': id},
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        getAddress();
        successSnackBar(message: responseData['message']);
      } else {
        log("CUSTOMER PROFILE :: $responseData");
        errorSnackBar(message: responseData['message']);
      }
    } catch (e) {
      rethrow;
    } finally {
      addressLoader(false);
    }
  }

  void clearFields() {
    selectAddressType.value = "";
    isDefault.value = false;
    countryController.clear();
    provinceController.clear();
    addressCityController.clear();
    addressNameController.clear();
    zipController.clear();
  }
}
