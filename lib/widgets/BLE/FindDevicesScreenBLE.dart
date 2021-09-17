import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:htl_car/widgets/BLE/DeviceScreenBLE.dart';
import 'package:htl_car/widgets/DeviceScreen.dart';

StreamController<bool> streamController = StreamController();

class FindDevicesScreenBLE extends StatefulWidget {
  final BleManager bleManager;

  const FindDevicesScreenBLE(this.bleManager);

  @override
  _FindDevicesScreen createState() => new _FindDevicesScreen();
}

class _FindDevicesScreen extends State<FindDevicesScreenBLE> {
  Timer clearTimer;
  List<ScanResult> _devicesList = [];
  List<String> _peripheralNames = [];

  StreamSubscription subscription;

  BleManager bleManager;

  @override
  void initState() {
    bleManager = widget.bleManager;
    super.initState();

    subscription = bleManager.startPeripheralScan().listen((scanResult) {
      // do something with scan results

      if (scanResult.peripheral.name.toString().length > 2 &&
          scanResult.peripheral.name != null) {
        if (!_peripheralNames.contains(scanResult.peripheral.name)) {
          _devicesList.add(scanResult);
          _peripheralNames.add(scanResult.peripheral.name);
        }
        print("found ${scanResult.peripheral.name}");
      }
    });
  }

  bool isDisconnecting = false;
  @override
  void dispose() {
    super.dispose();
    bleManager.destroyClient();
    bleManager.stopPeripheralScan();
    subscription.cancel();
    print("kjasdhjfkasdlfnaskjldvcnkadsjvnjasdkfklö");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _devicesList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_devicesList[index].peripheral.name),
          subtitle: Text(_devicesList[index].peripheral.identifier.toString()),
          trailing: ElevatedButton(
              child: Text('Connect'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DeviceScreenBLE(_devicesList[index].peripheral),
                    ));
              }),
        );
      },
    );
  }
}
