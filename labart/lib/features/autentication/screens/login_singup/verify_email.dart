import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:labart/features/autentication/screens/login_singup/sucess_screen.dart';
import 'package:labart/features/autentication/screens/login_singup/widgets/otpController.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:labart/utils/constants/image_strings.dart';
import 'package:labart/utils/constants/text_strings.dart';
import 'package:labart/features/autentication/screens/login_singup/login_singup.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rive/rive.dart' as rive;
import 'package:vibration/vibration.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  int _resendCooldown = 0;
  Timer? _cooldownTimer;
  bool _isLoading = false;
  String? _errorMessage;
  final OTPController otpController = Get.put(OTPController());

  void _startResendCooldown() {
    setState(() {
      _resendCooldown = 180; // Cambiado a 30 segundos para pruebas (original 300 = 5 min)
    });
    
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown <= 0) {
        timer.cancel();
      } else {
        setState(() {
          _resendCooldown--;
        });
      }
    });
  }

  Future<Map<String, String>> _getRegistrationData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('register_name') ?? '',
      'email': prefs.getString('register_email') ?? '',
      'password': prefs.getString('register_password') ?? '',
      'otp': prefs.getString('register_otp') ?? '',
    };
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final registrationData = await _getRegistrationData();
      final response = await http.post(
        Uri.parse('${THttpHelper.baseUrl}/signin'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Nombre_usuario": registrationData['name'],
          "correo_usuario": registrationData['email'],
          "contrasena": registrationData['password']
        }),
      );

      if (response.statusCode == 201) {
        // Limpiar los datos de registro del caché
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('register_name');
        await prefs.remove('register_email');
        await prefs.remove('register_password');
        await prefs.remove('register_otp');
        
        if (!mounted) return;
        Get.off(() => SucessScreen(
          image: TImages.sentEmail, 
          title: TTexts.yourAccountCreatedTitle, 
          subtitle: TTexts.yourAccountCreatedSubtitle, 
          onPressed: () => Get.offAll(() => const AuthScreen())
        ));
      } else {
        setState(() {
          _errorMessage = "Error en el registro (Código ${response.statusCode})";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _errorMessage = "No se pudo conectar al servidor.";
      });
    } on FormatException catch (e) {
      setState(() {
        _errorMessage = "Respuesta inválida del servidor: ${e.message}";
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error inesperado: $e";
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showOTPResultDialog(bool isSuccess, BuildContext context) async {
    await Vibration.vibrate(duration: 80);

    // Usar SimpleAnimation con autoplay pero sin loop
    final controller = rive.SimpleAnimation(
      isSuccess ? 'Timeline 1' : 'show',
      autoplay: true,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: rive.RiveAnimation.asset(
                    isSuccess
                        ? 'lib/assets/animations/checkmark.riv'
                        : 'lib/assets/animations/error_icon.riv',
                    fit: BoxFit.contain,
                    controllers: [controller],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isSuccess ? 'Verificación exitosa' : 'Código OTP incorrecto',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSuccess ? Colors.green : Colors.red,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Esperar suficiente tiempo para que la animación complete
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // La animación se quedará en el último frame automáticamente
    await Future.delayed(const Duration(milliseconds: 1000)); // Tiempo adicional
    
    if (context.mounted) Navigator.of(context).pop();

    if (isSuccess) {
      await _register();
    }
  }

  Future<void> _showEmailSentDialog(BuildContext context) async {
    await Vibration.vibrate(duration: 80);

    final controller = rive.SimpleAnimation('Timeline 1', autoplay: true);

    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: rive.RiveAnimation.asset(
                    'lib/assets/animations/checkmark.riv',
                    fit: BoxFit.contain,
                    controllers: [controller],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Código OTP reenviado',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.green,
                      ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Aceptar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      otpController.fieldOneFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
  _cooldownTimer?.cancel();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const AuthScreen()), 
            icon: const Icon(CupertinoIcons.clear)
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Image(image: const AssetImage(TImages.verifyEmail), width: THelperFunctions.screenWidth() * 0.8,),
              const SizedBox(height: TSizes.spaceBtwSections),
              
              Text(
                TTexts.confirmEmail, 
                style: Theme.of(context).textTheme.headlineMedium, 
                textAlign: TextAlign.center
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                'labartSupport@gmail.com', 
                style: Theme.of(context).textTheme.labelLarge, 
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                TTexts.confirmEmailSubtitle, 
                style: Theme.of(context).textTheme.labelMedium, 
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) => 
                    _buildOTPField(context, otpController, index + 1)),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoading 
                        ? Theme.of(context).primaryColor.withOpacity(0.7) 
                        : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (_isLoading) return; // early return
                    setState(() => _isLoading = true);
                    final isValid = await otpController.verifyOTP();
                    await _showOTPResultDialog(isValid, context);
                    if (mounted) setState(() => _isLoading = false);
                  },
                  child: _isLoading 
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          TTexts.tContinue,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwItems),
              
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: (_isLoading || _resendCooldown > 0)
                      ? null
                      : () async {
                          setState(() => _isLoading = true);
                          final responseCode = await otpController.resendOTP();
                          setState(() => _isLoading = false);

                          if (responseCode == 200) {
                            _startResendCooldown();
                            await _showEmailSentDialog(context);
                          } else if (responseCode != null) {
                            Get.snackbar('Error', 'No se pudo reenviar el código');
                          } else {
                            Get.snackbar('Error', 'No se encontró el correo en caché');
                          }
                        },
                  child: Text(
                    _resendCooldown > 0
                        ? 'Reenviar en ${_formatTime(_resendCooldown)}'
                        : TTexts.resendEmail,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: _resendCooldown > 0 
                          ? Colors.grey 
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),

              // Añade este método auxiliar para formatear el tiempo:
              

              // Modifica el método _startResendCooldown:
              
            ],
          ),
        ),
      ),
    );
  }

  

  Widget _buildOTPField(BuildContext context, OTPController controller, int fieldNumber) {
    final textController = controller.getControllerForField(fieldNumber);
    final focusNode = controller.getFocusNodeForField(fieldNumber);
    final nextFocusNode = fieldNumber < 6 ? controller.getFocusNodeForField(fieldNumber + 1) : null;
    final previousFocusNode = fieldNumber > 1 ? controller.getFocusNodeForField(fieldNumber - 1) : null;

    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: textController,
        focusNode: focusNode,
        autofocus: fieldNumber == 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: Theme.of(context).textTheme.headlineSmall,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (nextFocusNode != null) {
              Future.delayed(Duration(milliseconds: 50), () {
                FocusScope.of(context).requestFocus(nextFocusNode);
              });
            } else {
              // Último campo - quitar el teclado
              focusNode.unfocus();
            }
          } else if (value.isEmpty && previousFocusNode != null) {
            Future.delayed(Duration(milliseconds: 50), () {
              FocusScope.of(context).requestFocus(previousFocusNode);
            });
          }
        },
        onTap: () {
          // Si el campo está vacío y hay campos anteriores con datos, mover el foco al último con datos
          if (textController.text.isEmpty) {
            final lastFilledField = controller.getLastFilledField();
            if (lastFilledField != null && fieldNumber > lastFilledField + 1) {
              FocusScope.of(context).requestFocus(
                controller.getFocusNodeForField(lastFilledField + 1)
              );
              return;
            }
          }
          focusNode.requestFocus();
        },
      ),
    );
  }
}
