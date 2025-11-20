/// Validates that a URL string contains a scheme and host.
bool isValidUrl(String url) {
  if (url.isEmpty) return false;

  final uri = Uri.tryParse(url.trim());
  if (uri == null) return false;

  final hasSupportedScheme =
      uri.scheme == 'https' || uri.scheme == 'http' || uri.scheme == 'about';

  return hasSupportedScheme && uri.host.isNotEmpty;
}


