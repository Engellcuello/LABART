import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';  // Import correcto

class TDeviceUtils {


  static double getBottomNavigationBarHeight() {
    return kBottomNavigationBarHeight;
  }

  static double getAppBarHeight(){
    return kToolbarHeight;
  }

  //ESTE CODE SIRVE PARA REDIRECCIONAR A UNA URL
  static Future<void> launchUrl(String url) async { 
    if (!await launchUrlString(url)) { 
      throw 'Could not launch $url';  // Agregado punto y coma
    }
  }
}
