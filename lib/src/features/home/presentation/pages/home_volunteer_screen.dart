import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../localization/codegen_loader.g.dart';
import '../../../../common/utils/constants/providers.dart';
import '../widgets/home_widget.dart';

class HomeVolunteerScreen extends ConsumerWidget {
  final VoidCallback? onDialogRequested;

  const HomeVolunteerScreen({super.key, this.onDialogRequested});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (onDialogRequested != null) {
        onDialogRequested!();
      }
    });

    return FutureBuilder<bool>(
      future: authService.isTokenValid(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          );
        }

        if (!snapshot.data!) {
          return Scaffold(
            body: Center(
              child: Text(LocaleKeys.home_volunteer_sessionExpired.tr()),
            ),
          );
        }

        final profileAsync = ref.watch(profileFutureProvider);

        return Scaffold(
          body: profileAsync.when(
            data: (profile) {
              return HomeWidget(
                greeting: LocaleKeys.home_volunteer_greeting.tr(namedArgs: {
                  'firstName': profile?.firstName ?? '',
                  'lastName': profile?.lastName ?? '',
                }),
                subtitle: LocaleKeys.home_volunteer_subtitle.tr(),
                buttonText: LocaleKeys.home_volunteer_buttonText.tr(),
                isRequester: false,
              );
            },
            loading: () {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              );
            },
            error: (err, stack) {
              if (kDebugMode) {
                print('Error al cargar el perfil: $err');
                print('Stack trace: $stack');
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
