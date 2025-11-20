import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/utils/url_validator.dart';
import '../../../services/local_storage_service.dart';

/// Displays the saved URL inside a WebView.
class WebViewPage extends ConsumerStatefulWidget {
  const WebViewPage({super.key});

  static const routeName = '/webview';

  @override
  ConsumerState<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends ConsumerState<WebViewPage> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _pageUrl;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    final storage = ref.read(localStorageServiceProvider);
    final savedUrl = storage.getSelectedUrl();

    if (!isValidUrl(savedUrl)) {
      setState(() {
        _errorMessage = 'Saved URL is invalid. Please update it in Settings.';
        _isLoading = false;
      });
      return;
    }

    final uri = Uri.parse(savedUrl);

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            setState(() {
              _errorMessage = error.description;
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(uri);

    setState(() {
      _controller = controller;
      _pageUrl = savedUrl;
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _controller == null
                ? null
                : () {
                    _controller!.reload();
                  },
          ),
        ],
      ),
      body: SafeArea(
        child: _errorMessage != null
            ? _ErrorView(message: _errorMessage!)
            : _controller == null
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      WebViewWidget(controller: _controller!),
                      if (_isLoading)
                        const LinearProgressIndicator(minHeight: 3),
                      if (_pageUrl != null)
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(8),
                            color:
                                Theme.of(context).colorScheme.surfaceVariant,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _pageUrl!,
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}


