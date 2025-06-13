import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../routing/app_router.dart';
import '../data/videocall_service.dart';

class ConnectingScreen extends StatefulWidget {
  final int idRequest;

  const ConnectingScreen({super.key, required this.idRequest});

  @override
  State<ConnectingScreen> createState() => _ConnectingScreenState();
}

class _ConnectingScreenState extends State<ConnectingScreen> {
  final List<String> tips = [
    LocaleKeys.videocalls_connectingScreen_tips_tip1.tr(),
    LocaleKeys.videocalls_connectingScreen_tips_tip2.tr(),
    LocaleKeys.videocalls_connectingScreen_tips_tip3.tr(),
    LocaleKeys.videocalls_connectingScreen_tips_tip4.tr(),
    LocaleKeys.videocalls_connectingScreen_tips_tip5.tr(),
  ];

  int currentTipIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTipsRotation();
  }

  void _startTipsRotation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        currentTipIndex = (currentTipIndex + 1) % tips.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _cancelAndReturnToHome() async {
    final service = VideocallService();

    try {
      await service.cancelRequest(widget.idRequest);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(LocaleKeys.videocalls_connectingScreen_cancelFailed.tr())),
      );
    }

    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.homeRequesterRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            LocaleKeys.videocalls_connectingScreen_appBarTitle.tr(),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocaleKeys.videocalls_connectingScreen_establishingConnection
                    .tr(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.videocalls_connectingScreen_searchingAssistance.tr(),
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  tips[currentTipIndex],
                  key: ValueKey(currentTipIndex),
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showCancelConfirmationDialog,
                  child:
                      Text(LocaleKeys.videocalls_connectingScreen_cancel.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelConfirmationDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            LocaleKeys.videocalls_connectingScreen_cancelRequestTitle.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            LocaleKeys.videocalls_connectingScreen_cancelRequestQuestion.tr(),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                textStyle: theme.textTheme.labelLarge,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(LocaleKeys.videocalls_connectingScreen_no.tr()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: theme.textTheme.labelLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _cancelAndReturnToHome();
              },
              child:
                  Text(LocaleKeys.videocalls_connectingScreen_yesCancel.tr()),
            ),
          ],
        );
      },
    );
  }
}
