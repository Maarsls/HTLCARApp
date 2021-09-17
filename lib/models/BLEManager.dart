import 'dart:convert';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class BLEManager {
  Peripheral _device;
  Characteristic _targetCharacteristics;

  BLEManager(Peripheral device) {
    _device = device;

    connect();
  }

  void connect() async {
    await _device.connect();
    discoverServices();
  }

  discoverServices() async {
    if (_device == null) return;

    await _device.discoverAllServicesAndCharacteristics();

    /*List<Service> services = await _device.services();
    services.forEach((service) {
      // do something with service
      print("Service: " + service.uuid.toString());
      if (service.uuid.toString() == "0000ffe0-0000-1000-8000-00805f9b34fb") {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() ==
              "0000ffe1-0000-1000-8000-00805f9b34fb") {
            print("habs gfunden");
            _targetCharacteristics = characteristic;
            _isFound = true;
          }
        });
      }
    });*/

    List<Characteristic> characteristics =
        await _device.characteristics("0000ffe0-0000-1000-8000-00805f9b34fb");

    for (Characteristic c in characteristics) {
      if (c.uuid.toString() == "0000ffe1-0000-1000-8000-00805f9b34fb") {
        print("habs gfunden");
        _targetCharacteristics = c;
      }
    }
  }

  /*writeDataAndWaitForRespond() async {
    writeData("A 300 300 300");
    List<BluetoothService> services = await targetDevice.discoverServices();
    print("////////////////We're here, listening to Hive...");
    // isDeviceTurnedOn = true;
    services.forEach((service) async {
      Future.delayed(const Duration(milliseconds: 500), () async {
        print("Entered the loop...");
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          List<int> value = await c.read();
          String stringValue = new String.fromCharCodes(value);
          print("The recieved Characteristic Value is $stringValue and $value");
          print("Entered the second loop...");
          var descriptors = c.descriptors;
          print("The descriptors value is equal to: $descriptors");
          for (BluetoothDescriptor d in descriptors) {
            List<int> value = await d.read();
            print("Entered the third loop...");
            String stringValue = new String.fromCharCodes(value);
            print("The recieved Value is $stringValue and $value");
          }
        }
      });
    });
  }*/

  void writeData(String data) {
    try {
      List<int> bytes = utf8.encode(data + "\r\n");
      _targetCharacteristics.write(bytes, false);
    } catch (error, stackTrace) {}
  }

  void cancel() {
    _device.disconnectOrCancelConnection();
  }
}
