import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/url_validator.dart';
import '../../../services/local_storage_service.dart';
import '../../../services/mock_device_service.dart';

/// Immutable state for the settings screen.
class SettingsState {
  const SettingsState({
    required this.url,
    required this.devices,
    required this.selectedDevice,
    required this.isLoading,
    required this.isSaving,
    required this.errorMessage,
  });

  factory SettingsState.initial() => SettingsState(
        url: 'https://flutter.dev',
        devices: const [],
        selectedDevice: null,
        isLoading: true,
        isSaving: false,
        errorMessage: null,
      );

  final String url;
  final List<DeviceInfo> devices;
  final String? selectedDevice;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;

  SettingsState copyWith({
    String? url,
    List<DeviceInfo>? devices,
    String? selectedDevice,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
  }) {
    return SettingsState(
      url: url ?? this.url,
      devices: devices ?? this.devices,
      selectedDevice: selectedDevice ?? this.selectedDevice,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
    );
  }
}

/// Controls Settings state, handles persistence and validation.
class SettingsController extends StateNotifier<SettingsState> {
  SettingsController(
    this._localStorageService,
    this._deviceService,
  ) : super(SettingsState.initial()) {
    _loadInitialData();
  }

  final LocalStorageService _localStorageService;
  final MockDeviceService _deviceService;

  Future<void> _loadInitialData() async {
    try {
      final storedUrl = _localStorageService.getSelectedUrl();
      final storedDevice = _localStorageService.getSelectedDevice();
      final devices = _deviceService.fetchNearbyDevices();

      state = state.copyWith(
        url: storedUrl,
        selectedDevice: storedDevice,
        devices: devices,
        isLoading: false,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load saved settings.',
      );
    }
  }

  void updateUrl(String value) {
    state = state.copyWith(url: value, errorMessage: null);
  }

  void updateSelectedDevice(String? deviceName) {
    state = state.copyWith(selectedDevice: deviceName, errorMessage: null);
  }

  Future<bool> persistSelections() async {
    if (!isValidUrl(state.url)) {
      state = state.copyWith(errorMessage: 'Please enter a valid website URL.');
      return false;
    }
    if (state.selectedDevice == null) {
      state = state.copyWith(errorMessage: 'Please select a device.');
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      await _localStorageService.saveSelectedUrl(state.url.trim());
      await _localStorageService.saveSelectedDevice(state.selectedDevice!);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save your settings. Try again.',
      );
      return false;
    }
  }
}

/// Public provider for the settings controller.
final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  final deviceService = ref.watch(mockDeviceServiceProvider);
  return SettingsController(storage, deviceService);
});


