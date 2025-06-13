import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../localization/codegen_loader.g.dart';
import '../../../../../common/animations/animated_route.dart';
import '../../../../../routing/app_router.dart';
import 'user_type_selection_screen.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _accepted = false;

  UserType userType = UserType.requester;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final route = ModalRoute.of(context);
      if (route != null && route.settings.arguments is Map<String, dynamic>) {
        final args = route.settings.arguments as Map<String, dynamic>;
        final typeString = args['userType'] as String?;

        if (typeString == 'volunteer') {
          setState(() {
            userType = UserType.volunteer;
          });
        } else {
          setState(() {
            userType = UserType.requester;
          });
        }
      }
    });
  }

  void _onCheckboxChanged(bool? value) {
    setState(() {
      _accepted = value ?? false;
    });
  }

  void _onNextPressed() {
    if (_accepted) {
      final route = userType == UserType.volunteer
          ? AppRouter.signUpVolunteerRoute
          : AppRouter.signUpRequesterRoute;

      Navigator.of(context).push(animatedRouteTo(
        context,
        route,
        args: {
          'userType': userType.name,
        },
        duration: const Duration(milliseconds: 300),
        type: RouteTransitionType.pureFade,
        curve: Curves.easeInOut,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.secondary,
      body: Column(
        children: [
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.surface),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  LocaleKeys.auth_termsAndConditions_title.tr(),
                  style: TextStyle(
                    color: theme.surface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        LocaleKeys.auth_termsAndConditions_description.tr(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _accepted,
                        onChanged: _onCheckboxChanged,
                      ),
                      Expanded(
                        child: Text(
                          LocaleKeys.auth_termsAndConditions_acceptLabel.tr(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _accepted ? _onNextPressed : null,
                    child: Text(LocaleKeys.auth_termsAndConditions_next.tr()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
