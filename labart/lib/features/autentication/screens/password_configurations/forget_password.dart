import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/features/autentication/screens/password_configurations/reset_password.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/constants/text_strings.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(TTexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwItems,),
              Text(TTexts.confirmEmail, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: TSizes.spaceBtwSections,),

              TextFormField(
                decoration: InputDecoration(labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct_right_copy)),
              ),
              const SizedBox(height: TSizes.spaceBtwSections,),

              SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton(onPressed: ()=> Get.off(()=> const ResetPassword()), child: const Text(TTexts.submit)),
                ), 
              
              
            ],
          ),
        ),
    );
  }
}