import 'package:flutter/material.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/constants/image_strings.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:rive/rive.dart' hide Image;
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({super.key});

  @override
  _SuccessDialogState createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late RiveAnimationController _riveController;
  late AudioPlayer _audioPlayer;
  
  static const String riveAnimationPath = "lib/assets/animations/checkmark.riv";
  static const String successSound = TImages.succes1;

  @override
  void initState() {
    super.initState();
    
    _audioPlayer = AudioPlayer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _riveController = SimpleAnimation('check');
    
    // Iniciar animación después de un pequeño delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animationController.forward();
        _playSuccessSoundAndHaptic();
      }
    });
    
    // Cerrar automáticamente después de que complete la animación
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  
    Future<void> _playSuccessSoundAndHaptic() async {
      
      try {
        await Future.wait([
          _audioPlayer.setVolume(0.02),
          _audioPlayer.play(AssetSource(successSound)),
          Vibration.vibrate(duration: 80,),
        ]);
      } catch (e) {
        debugPrint('Error playing sound or haptic feedback: $e');
      }
    }

  @override
  void dispose() {
    _animationController.dispose();
    _riveController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: dark ? TColors.black : Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: RiveAnimation.asset(
                  riveAnimationPath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "¡Descarga Exitosa!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}