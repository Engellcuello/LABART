import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labart/common/styles/spacing_styles.dart';
import 'package:labart/features/autentication/screens/login_singup/login_singup.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/constants/text_strings.dart';
import 'package:labart/utils/helpers/helper_functions.dart';

class SucessScreen extends StatelessWidget {
  const SucessScreen({super.key, required this.image, required this.title, required this.subtitle, required this.onPressed});

  final String image, title, subtitle;
  final VoidCallback onPressed; 

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: TSpacingStyle.paddingWithAppBarHeight * 2,
            child: Column(
              children: [
                Image(image: AssetImage(image), width: THelperFunctions.screenWidth() * 0.8,),
                const SizedBox(height: TSizes.spaceBtwSections,),

                Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: TSizes.spaceBtwItems,),
                Text(subtitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
                const SizedBox(height: TSizes.spaceBtwItems,),

                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: ()=>Get.offAll(() => const AuthScreen()), child: Text(TTexts.tContinue))),

              ],
            ),
          ),
      ),
    );
  }
}