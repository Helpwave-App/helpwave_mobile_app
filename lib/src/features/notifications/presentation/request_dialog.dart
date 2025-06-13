import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';

class RequestDialog extends StatelessWidget {
  final String skill;
  final String fullname;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const RequestDialog({
    super.key,
    required this.skill,
    required this.fullname,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.notification_requestDialog_title.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${LocaleKeys.notification_requestDialog_requester.tr()}: $fullname',
          ),
          const SizedBox(height: 8),
          Text(
            '${LocaleKeys.notification_requestDialog_skill.tr()}: $skill',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop('reject');
            onReject();
          },
          child: Text(LocaleKeys.notification_requestDialog_reject.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop('accept');
            onAccept();
          },
          child: Text(LocaleKeys.notification_requestDialog_accept.tr()),
        ),
      ],
    );
  }
}
