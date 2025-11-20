import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles persistence of simple settings using [SharedPreferences].
class LocalStorageService {
  LocalStorageService._(this._prefs);

  final SharedPreferences _prefs;

  static const _keySelectedUrl = 'selected_url';
  static const _keySelectedDevice = 'selected_device';

  /// Initializes the service and returns an instance.
  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService._(prefs);
  }

  String getSelectedUrl({String defaultValue = 'https://flutter.dev'}) {
    return _prefs.getString(_keySelectedUrl) ?? defaultValue;
  }

  Future<void> saveSelectedUrl(String url) async {
    await _prefs.setString(_keySelectedUrl, url);
  }

  String? getSelectedDevice() {
    return _prefs.getString(_keySelectedDevice);
  }

  Future<void> saveSelectedDevice(String deviceName) async {
    await _prefs.setString(_keySelectedDevice, deviceName);
  }
}

/// Provider injected at runtime in `main.dart`.
final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) => throw UnimplementedError(
    'LocalStorageService must be overridden before use.',
  ),
);


