import 'package:flutter/material.dart'; 


class TTextFormFieldTheme { 
  TTextFormFieldTheme._(); 


  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme( 
    errorMaxLines: 3, 
    prefixIconColor: Colors.grey, 
    suffixIconColor: Colors.grey, 
    // constraints: const BoxConstraints.expand(height: 14.inputFieldHeight), 
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.black), 
    hintStyle: const TextStyle().copyWith(fontSize: 14, 
    color: Colors.black), 
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal), 
    floatingLabelStyle: const TextStyle().copyWith(
      color: Color.fromARGB((0.8 * 255).toInt(), 0, 0, 0), // Equivalente a withOpacity(0.8)
    ),
    border: const OutlineInputBorder().copyWith( 
    borderRadius: BorderRadius.circular(14), 
    borderSide: const BorderSide(width: 1, color: Colors.grey), 
    ),
    enabledBorder: const OutlineInputBorder().copyWith( 
    borderRadius: BorderRadius.circular(14), 
    borderSide: const BorderSide(width: 1, color: Colors.grey), 
    ), 
    focusedBorder:const OutlineInputBorder().copyWith( 
    borderRadius: BorderRadius.circular(14), 
    borderSide: const BorderSide(width: 1, color: Colors.black12), 
    ),
    errorBorder: const OutlineInputBorder().copyWith( 
    borderRadius: BorderRadius.circular(14), 
    borderSide: const BorderSide (width: 1, color: Colors.red), 
    ), 
    focusedErrorBorder: const OutlineInputBorder().copyWith( 
    borderRadius: BorderRadius.circular(14), 
    borderSide: const BorderSide (width: 2, color: Colors.orange), 
    ), 
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    // constraints: const BoxConstraints.expand(height: 14.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.white),
    hintStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.white),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: Color.fromARGB((0.8 * 255).toInt(), 255, 255, 255), // Blanco con opacidad 0.8
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 2, color: Colors.orange),
    ),
  );
}