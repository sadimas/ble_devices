import 'package:citrusdev_ble_app/controllers/bluetooth_controller.dart';
import 'package:citrusdev_ble_app/views/device_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BluetoothService> _services = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Bluetooth Devices',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.yellow], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: GetBuilder<BluetoothController>(
            init: BluetoothController(),
            builder: (controller) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(child: ElevatedButton(onPressed: () => controller.scanDevices(), child: const Text('Scan devices'))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          StreamBuilder<List<ScanResult>>(
                              stream: controller.scanResults,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final data = snapshot.data![index];
                                      return Card(
                                          elevation: 2,
                                          child: ListTile(
                                            title: data.device.platformName != '' ? Text(data.device.platformName) : const Text('unknown device'),
                                            subtitle: Row(
                                              children: [
                                                Text(data.device.remoteId.str),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(data.rssi.toString()),
                                              ],
                                            ),
                                            trailing: ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  controller.connectToDevice(data.device);
                                                  await Future.delayed(const Duration(seconds: 7));
                                                  _services = await data.device.discoverServices();
                                                  print(_services);

                                                  Get.to(() => DevicePage(
                                                        deviceName: data.device.platformName,
                                                        device: data.device, service: _services,
                                                      ));
                                                } on Exception catch (e) {
                                                  var snackBar = const SnackBar(content: Text('Unable to connect'));
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                }
                                                controller.disconnectDevice(data.device);
                                              },
                                              child: const Text('Connect'),
                                            ),
                                          ));
                                    },
                                  );
                                } else {
                                  return const Center(child: Text('No devices to connect'));
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
