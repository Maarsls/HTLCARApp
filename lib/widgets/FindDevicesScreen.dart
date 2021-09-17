import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:htl_car/widgets/DeviceScreen.dart';

StreamController<bool> streamController = StreamController();

class FindDevicesScreen extends StatefulWidget {
  @override
  _FindDevicesScreen createState() => new _FindDevicesScreen();
}

class _FindDevicesScreen extends State<FindDevicesScreen> {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  @override
  void initState() {
    super.initState();

    getPairedDevices();
  }

  bool isDisconnecting = false;
  @override
  void dispose() {
    super.dispose();
  }

  List<BluetoothDevice> _devicesList = [];

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _devicesList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      //is used to make the widget refreshable
      onRefresh: getPairedDevices,
      child: ListView.builder(
          itemCount: _devicesList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_devicesList[index].name),
              subtitle: Text(_devicesList[index].address.toString()),
              trailing: ElevatedButton(
                  child: Text('Connect'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeviceScreen(
                            _devicesList[index],
                          ),
                        ));
                  }),
            );
          }),
    );
  }
}
