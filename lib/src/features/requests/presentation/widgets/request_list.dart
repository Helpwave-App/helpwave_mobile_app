import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../localization/codegen_loader.g.dart';
import '../../application/request_history_controller.dart';
import '../../domain/request_model.dart';
import 'request_history_card.dart';

class RequestList extends StatelessWidget {
  final List<Request> requests;
  final String? userRole;
  final ThemeData theme;
  final RequestHistoryController controller;

  const RequestList({
    required this.requests,
    required this.userRole,
    required this.theme,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return Center(
        child: Text(
          LocaleKeys.requests_history_empty.tr(),
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha((255 * 0.7).round()),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return RequestHistoryCard(
                request: request,
                userRole: userRole,
                theme: theme,
              );
            },
          ),
        ),
      ],
    );
  }
}
