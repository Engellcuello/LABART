import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labart/features/autentication/screens/login_singup/login_singup.dart';
import 'package:labart/utils/constants/image_strings.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/constants/text_strings.dart';
import 'package:labart/utils/helpers/helper_functions.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: ()=> Get.back(), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [

                Image(image: AssetImage(TImages.sentEmail), width: THelperFunctions.screenWidth() * 0.8,),
                const SizedBox(height: TSizes.spaceBtwSections,),

                Text(TTexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: TSizes.spaceBtwItems,),
                Text(TTexts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center,),
                const SizedBox(height: TSizes.spaceBtwItems,),

                SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton(onPressed: ()=>Get.offAll(() => const AuthScreen()), child: Text(TTexts.done))
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                SizedBox(
                  width: double.infinity, 
                  child: TextButton(onPressed: (){}, child: Text(TTexts.resendEmail))
                ),


              ],
            ),
          ),
      ),
    );
  }
}