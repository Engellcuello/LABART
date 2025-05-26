// lib/utils/dialog_utils.dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:vibration/vibration.dart';

Future<void> showResultDialog({
  required bool isSuccess,
  required BuildContext context,
  String? successText,
  String? errorText,
  Future<void> Function()? onSuccess,
}) async {
  await Vibration.vibrate(duration: 80);

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
                isSuccess
                    ? successText ?? 'Exito'
                    : errorText ?? 'Ocurrio un problema',
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

  await Future.delayed(const Duration(milliseconds: 1500));
  await Future.delayed(const Duration(milliseconds: 1000));

  if (context.mounted) Navigator.of(context).pop();

  if (isSuccess && onSuccess != null) {
    await onSuccess();
  }
}
