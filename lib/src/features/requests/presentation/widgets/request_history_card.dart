import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../localization/codegen_loader.g.dart';
import '../../domain/request_model.dart';

class RequestHistoryCard extends StatelessWidget {
  final Request request;
  final String? userRole;
  final ThemeData theme;

  const RequestHistoryCard({
    required this.request,
    required this.userRole,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = request.stateRequest;
    final Color statusColor = isCompleted
        ? Colors.green
        : theme.colorScheme.error.withAlpha((255 * 0.8).round());

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${LocaleKeys.requests_history_request_of.tr()} ${request.skillDescription}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
                if (userRole == 'requester') ...[
                  const SizedBox(width: 12),
                  Text(
                    isCompleted
                        ? LocaleKeys.requests_history_attended.tr()
                        : LocaleKeys.requests_history_cancelled.tr(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${LocaleKeys.requests_history_date.tr()}: ${DateFormat.yMd().add_jm().format(request.dateRequest)}',
              style: TextStyle(
                color:
                    theme.colorScheme.onSurface.withAlpha((255 * 0.7).round()),
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${LocaleKeys.requests_history_duration.tr()}: ${request.duration}',
              style: TextStyle(
                color:
                    theme.colorScheme.onSurface.withAlpha((255 * 0.7).round()),
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
