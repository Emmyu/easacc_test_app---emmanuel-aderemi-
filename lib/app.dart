import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/styles/app_theme.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/settings/presentation/settings_page.dart';
import 'features/webview/presentation/webview_page.dart';

/// Root widget for the Easacc Test App.
class EasaccTestApp extends ConsumerWidget {
  const EasaccTestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);

    return MaterialApp(
      title: 'Easacc Test App',
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        SettingsPage.routeName: (_) => const SettingsPage(),
        WebViewPage.routeName: (_) => const WebViewPage(),
      },
    );
  }
}


