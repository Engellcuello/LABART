import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:labart/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPController extends GetxController {
  final TextEditingController fieldOne = TextEditingController();
  final TextEditingController fieldTwo = TextEditingController();
  final TextEditingController fieldThree = TextEditingController();
  final TextEditingController fieldFour = TextEditingController();
  final TextEditingController fieldFive = TextEditingController();
  final TextEditingController fieldSix = TextEditingController();

  final FocusNode fieldOneFocusNode = FocusNode();
  final FocusNode fieldTwoFocusNode = FocusNode();
  final FocusNode fieldThreeFocusNode = FocusNode();
  final FocusNode fieldFourFocusNode = FocusNode();
  final FocusNode fieldFiveFocusNode = FocusNode();
  final FocusNode fieldSixFocusNode = FocusNode();

  TextEditingController getControllerForField(int fieldNumber) {
    switch(fieldNumber) {
      case 1: return fieldOne;
      case 2: return fieldTwo;
      case 3: return fieldThree;
      case 4: return fieldFour;
      case 5: return fieldFive;
      case 6: return fieldSix;
      default: throw Exception('Invalid field number');
    }
  }

  int? getLastFilledField() {
    if (fieldSix.text.isNotEmpty) return 6;
    if (fieldFive.text.isNotEmpty) return 5;
    if (fieldFour.text.isNotEmpty) return 4;
    if (fieldThree.text.isNotEmpty) return 3;
    if (fieldTwo.text.isNotEmpty) return 2;
    if (fieldOne.text.isNotEmpty) return 1;
    return null;
  }

  FocusNode getFocusNodeForField(int fieldNumber) {
    switch(fieldNumber) {
      case 1: return fieldOneFocusNode;
      case 2: return fieldTwoFocusNode;
      case 3: return fieldThreeFocusNode;
      case 4: return fieldFourFocusNode;
      case 5: return fieldFiveFocusNode;
      case 6: return fieldSixFocusNode;
      default: throw Exception('Invalid field number');
    }
  }

  Future<bool> verifyOTP() async {
    String otp = fieldOne.text + 
                fieldTwo.text + 
                fieldThree.text + 
                fieldFour.text + 
                fieldFive.text + 
                fieldSix.text;
    
    if (otp.length != 6) {
      Get.snackbar(
        'Error', 
        'Por favor ingresa el código completo de 6 dígitos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedOTP = prefs.getString('register_otp') ?? '';
    
    return otp == storedOTP;
  }

  Future<int?> resendOTP() async {
    fieldOne.clear();
    fieldTwo.clear();
    fieldThree.clear();
    fieldFour.clear();
    fieldFive.clear();
    fieldSix.clear();
    fieldOneFocusNode.requestFocus();

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('register_email') ?? '';

      if (email.isEmpty) {
        return null;
      }

      final response = await http.post(
        Uri.parse('${THttpHelper.baseUrl}/email'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"destinatario": email}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await prefs.setString('register_otp', responseData['OTP']);
      }

      return response.statusCode;
    } catch (e) {
      print('Error en resendOTP: $e');
      return null;
    }
  }

  @override
  void onClose() {
    fieldOne.dispose();
    fieldTwo.dispose();
    fieldThree.dispose();
    fieldFour.dispose();
    fieldFive.dispose();
    fieldSix.dispose();
    fieldOneFocusNode.dispose();
    fieldTwoFocusNode.dispose();
    fieldThreeFocusNode.dispose();
    fieldFourFocusNode.dispose();
    fieldFiveFocusNode.dispose();
    fieldSixFocusNode.dispose();
    super.onClose();
  }
}