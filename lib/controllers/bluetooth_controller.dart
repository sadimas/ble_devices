import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  Future scanDevices() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    // FlutterBluePlus.stopScan();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    // print(device);
    await device.connect(timeout: const Duration(seconds: 15));

    device.connectionState.listen((isConnected) {
      if (isConnected == BluetoothConnectionState.connected) {
        print('device name: ${device.advName}');
      } else {
        print('Device disconnected');
      }
    });
  }

Future<void> disconnectDevice(BluetoothDevice device) async {
    
    await device.disconnect();
    
  }


  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

   



}
