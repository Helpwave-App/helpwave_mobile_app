import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onButtonPressed != null) {
              onButtonPressed!();
            }
          },
          child: Text(
            buttonText ?? LocaleKeys.notification_infoDialog_accept.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
