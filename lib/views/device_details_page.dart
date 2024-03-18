import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DevicePage extends StatefulWidget {
  final String deviceName;
  final BluetoothDevice device;
 
  final List<BluetoothService> service;
  const DevicePage({
    Key? key,
    required this.deviceName,
    required this.device, required this.service, 
  }) : super(key: key);

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:  Text(
          widget.deviceName,
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildRemoteId(context),
            ],
          ),
        ),
      
    );
  }
  Widget buildRemoteId(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
         
          Text('Remote Id: ${widget.device.remoteId}'),
        
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
              itemCount: widget.service.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  leading:  Text('BlutoothService uuid:'),
                  trailing:  Text(widget.service[index].uuid.toString()),
                ),
              )),
          
          // Text('BluetoothService ${widget.service.}'),
         
        ],
      ),
    );
  }
// List<Widget> _buildServiceTiles(BuildContext context, BluetoothDevice d) {
//     return services
//         .map(
//           (s) => ServiceTile(
//             service: s,
//             characteristicTiles: s.characteristics.map((c) => _buildCharacteristicTile(c)).toList(),
//           ),
//         )
//         .toList();
//   }

//   CharacteristicTile _buildCharacteristicTile(BluetoothCharacteristic c) {
//     return CharacteristicTile(
//       characteristic: c,
//       descriptorTiles: c.descriptors.map((d) => DescriptorTile(descriptor: d)).toList(),
//     );
//   }

}