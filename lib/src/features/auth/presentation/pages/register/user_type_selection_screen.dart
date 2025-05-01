import 'package:flutter/material.dart';

import '../../../../../common/animations/animated_route.dart';
import '../../../../../routing/app_router.dart';

enum UserType { volunteer, requester }

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  State<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  UserType? _selectedType;
  static const String imagePath = 'lib/src/assets/images/';

  void _onNextPressed() {
    if (_selectedType == null) return;

    // convierte UserType.volunteer -> "volunteer"
    final userType = _selectedType!.toString().split('.').last;

    Navigator.of(context).push(animatedRouteTo(
      context,
      AppRouter.termsRoute,
      args: {
        'userType': userType,
        'nextRoute': AppRouter.signUpRequesterRoute,
      },
      duration: const Duration(milliseconds: 1000),
      type: RouteTransitionType.pureFade,
      curve: Curves.easeInOutBack,
    ));
  }

  Widget _buildOption(UserType type, String label, String assetName) {
    final isSelected = _selectedType == type;
    final theme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? theme.tertiary : Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio<UserType>(
                  value: type,
                  groupValue: _selectedType,
                  onChanged: (val) => setState(() => _selectedType = val),
                  activeColor: theme.tertiary,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath + assetName,
                width: MediaQuery.of(context).size.width * 0.7,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
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
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.surface),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  'Tipo de usuario',
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
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOption(
                            UserType.requester,
                            // TODO: Cambiar el texto por uno mejor
                            'Persona que necesita ayuda',
                            'requester.png',
                          ),
                          _buildOption(
                            UserType.volunteer,
                            'Voluntario',
                            'volunteer.png',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedType != null ? _onNextPressed : null,
                      child: const Text('Siguiente'),
                    ),
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
