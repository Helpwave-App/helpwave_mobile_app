import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../localization/codegen_loader.g.dart';
import '../../../common/utils/constants/providers.dart';
import '../../../common/utils/constants/secure_storage.dart';
import '../../../common/utils/firebase/firebase_options.dart';
import '../presentation/profile_stat_card_widget.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  String? userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await SecureStorage.getRole();
    if (mounted) {
      setState(() {
        userRole = role;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsyncValue = ref.watch(profileFutureProvider);
    final controller = ref.watch(userInfoControllerProvider.notifier);
    final isLoading = ref.watch(userInfoControllerProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          LocaleKeys.profile_user_info_screen_app_bar_title.tr(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        elevation: 0,
        actions: [
          if (isEditing)
            IconButton(
              icon: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final profile = profileAsyncValue.asData?.value;
                  if (profile != null) {
                    controller.saveProfileChanges(
                      context,
                      _formKey,
                      profile,
                      () => setState(() => isEditing = false),
                    );
                  }
                }
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => isEditing = true),
            ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => isEditing = false),
            ),
        ],
      ),
      body: profileAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
              '${LocaleKeys.profile_user_info_screen_error_loading.tr()}: $e'),
        ),
        data: (profile) {
          if (profile == null) {
            return Center(
              child: Text(
                  LocaleKeys.profile_user_info_screen_error_no_profile.tr()),
            );
          }

          if (!isEditing) {
            controller.initControllers(profile);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primary,
                  backgroundImage: profile.photoUrl.isNotEmpty
                      ? NetworkImage(profile.photoUrl)
                      : null,
                  child: profile.photoUrl.isEmpty
                      ? Icon(Icons.person,
                          size: 50, color: theme.colorScheme.onPrimary)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  '${profile.firstName} ${profile.lastName}',
                  style: theme.textTheme.headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 28),

                /// Mostrar stats solo si el usuario es voluntario
                if (userRole == 'volunteer') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ProfileStatCard(
                        icon: Icons.star,
                        value: profile.scoreProfile.toStringAsFixed(1),
                        label: LocaleKeys.profile_user_info_screen_stats_score
                            .tr(),
                        iconColor: Colors.amber,
                      ),
                      Consumer(
                        builder: (context, ref, _) {
                          final asyncLevel =
                              ref.watch(levelFutureProvider(profile.level));
                          return asyncLevel.when(
                            data: (level) => ProfileStatCard(
                              iconWidget: SizedBox(
                                width: 32,
                                height: 32,
                                child: Image.network(
                                  '$imageBaseUrl${level.photoUrl}',
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return const Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, size: 32);
                                  },
                                ),
                              ),
                              value: level.nameLevel,
                              label: LocaleKeys
                                  .profile_user_info_screen_stats_level
                                  .tr(),
                            ),
                            loading: () => ProfileStatCard(
                              icon: Icons.hourglass_top,
                              value: '...',
                              label: LocaleKeys
                                  .profile_user_info_screen_stats_level
                                  .tr(),
                            ),
                            error: (e, _) => ProfileStatCard(
                              icon: Icons.warning_amber_rounded,
                              iconColor: Colors.red,
                              value: 'Sin nivel',
                              label: LocaleKeys
                                  .profile_user_info_screen_stats_level
                                  .tr(),
                            ),
                          );
                        },
                      ),
                      ProfileStatCard(
                        icon: Icons.volunteer_activism,
                        value: profile.assistances.toString(),
                        label: LocaleKeys
                            .profile_user_info_screen_stats_assistances
                            .tr(),
                        iconColor: theme.colorScheme.tertiary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 42),
                ],

                // Formulario
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: isEditing,
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: LocaleKeys
                              .profile_user_info_screen_form_email
                              .tr(),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys
                                .profile_user_info_screen_validation_email_required
                                .tr();
                          }
                          if (!value.contains('@')) {
                            return LocaleKeys
                                .profile_user_info_screen_validation_email_invalid
                                .tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        enabled: isEditing,
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: LocaleKeys
                              .profile_user_info_screen_form_phone
                              .tr(),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys
                                .profile_user_info_screen_validation_phone_required
                                .tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: isEditing
                            ? () async {
                                final initialDate = controller.parseDate(
                                        controller.birthdayController.text) ??
                                    DateTime(1970, 1, 1);
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: initialDate,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  helpText: LocaleKeys
                                      .profile_user_info_screen_form_birthday_picker
                                      .tr(),
                                  locale: const Locale('es', ''),
                                );

                                if (pickedDate != null) {
                                  final formatted =
                                      '${pickedDate.day.toString().padLeft(2, '0')}/'
                                      '${pickedDate.month.toString().padLeft(2, '0')}/'
                                      '${pickedDate.year}';
                                  setState(() {
                                    controller.birthdayController.text =
                                        formatted;
                                  });
                                }
                              }
                            : null,
                        child: AbsorbPointer(
                          child: TextFormField(
                            enabled: isEditing,
                            controller: controller.birthdayController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: LocaleKeys
                                  .profile_user_info_screen_form_birthday
                                  .tr(),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LocaleKeys
                                    .profile_user_info_screen_validation_birthday_required
                                    .tr();
                              }
                              if (controller.parseDate(value) == null) {
                                return LocaleKeys
                                    .profile_user_info_screen_validation_birthday_invalid
                                    .tr();
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
