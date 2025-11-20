import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Types of mock devices we can connect to.
enum DeviceType { wifi, bluetooth }

/// Simple entity describing a nearby device.
class DeviceInfo {
  const DeviceInfo({
    required this.name,
    required this.type,
  });

  final String name;
  final DeviceType type;

  String get displayLabel =>
      type == DeviceType.wifi ? '$name (Wi-Fi)' : '$name (Bluetooth)';
}

/// Provides a mock list of nearby network devices.
class MockDeviceService {
  const MockDeviceService();

  List<DeviceInfo> fetchNearbyDevices() {
    return const [
      DeviceInfo(name: 'Printer A', type: DeviceType.wifi),
      DeviceInfo(name: 'Printer B', type: DeviceType.wifi),
      DeviceInfo(name: 'Office AP', type: DeviceType.wifi),
      DeviceInfo(name: 'Bluetooth Speaker', type: DeviceType.bluetooth),
      DeviceInfo(name: 'Team Headset', type: DeviceType.bluetooth),
    ];
  }
}

final mockDeviceServiceProvider = Provider<MockDeviceService>(
  (ref) => const MockDeviceService(),
);


