import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/settings_controller.dart';
import '../../webview/presentation/webview_page.dart';

/// Lets the user configure website URL and nearby device.
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  static const routeName = '/settings';

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(settingsControllerProvider);
    _urlController = TextEditingController(text: state.url);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _handleSave({bool navigateToWebView = false}) async {
    final notifier = ref.read(settingsControllerProvider.notifier);
    final success = await notifier.persistSelections();

    if (!mounted || !success) return;

    if (navigateToWebView) {
      Navigator.pushNamed(context, WebViewPage.routeName);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SettingsState>(
      settingsControllerProvider,
      (_, next) {
        if (_urlController.text != next.url) {
          _urlController.text = next.url;
        }
      },
    );

    final state = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Website URL',
                        hintText: 'https://flutter.dev',
                      ),
                      onChanged: ref
                          .read(settingsControllerProvider.notifier)
                          .updateUrl,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: state.selectedDevice,
                      decoration: const InputDecoration(
                        labelText: 'Nearby Device',
                      ),
                      items: state.devices
                          .map(
                            (device) => DropdownMenuItem(
                              value: device.name,
                              child: Text(device.displayLabel),
                            ),
                          )
                          .toList(),
                      onChanged: ref
                          .read(settingsControllerProvider.notifier)
                          .updateSelectedDevice,
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      icon: const Icon(Icons.save),
                      label: Text(
                        state.isSaving ? 'Saving…' : 'Save Settings',
                      ),
                      onPressed: state.isSaving ? null : () => _handleSave(),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.public),
                      label: const Text('Open Web Page'),
                      onPressed: state.isSaving
                          ? null
                          : () => _handleSave(navigateToWebView: true),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
