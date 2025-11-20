import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/presentation/settings_page.dart';
import '../../../widgets/app_logo.dart';

/// Simple mock login screen.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  Future<void> _simulateLogin(BuildContext context) async {
    // Simulate a network delay for realism.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!context.mounted) return;

    Navigator.pushReplacementNamed(context, SettingsPage.routeName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Login with Google'),
                    onPressed: () => _simulateLogin(context),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.facebook),
                    label: const Text('Login with Facebook'),
                    onPressed: () => _simulateLogin(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


