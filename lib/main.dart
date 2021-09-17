import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:htl_car/widgets/BLE/FindDevicesScreenBLE.dart';
import 'package:htl_car/widgets/BluetoothOffScreen.dart';
import 'package:htl_car/widgets/FindDevicesScreen.dart';
import 'dart:async';
import 'package:fimber/fimber.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool ble = true;
  BluetoothState myState = BluetoothState.UNKNOWN;
  BleManager bleManager = new BleManager();

  @override
  void initState() {
    setup(bleManager);
    super.initState();

    Timer.periodic(new Duration(seconds: 2), (timer) {
      bleManager.observeBluetoothState().listen((btState) {
        setState(() {
          myState = btState;
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bleManager.destroyClient();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: Color.fromRGBO(213, 95, 220, 1),
        home: Scaffold(
          appBar: AppBar(
            title: (myState == BluetoothState.POWERED_ON
                ? (ble
                    ? Text('Gefundene BLE Geräte!')
                    : Text('Gefundene RFCOMM Geräte!'))
                : Text('Bluetooth ist deaktiviert')),
            backgroundColor: (myState == BluetoothState.POWERED_ON
                ? Color.fromRGBO(213, 95, 220, 1)
                : Colors.lightBlue),
          ),
          body: StreamBuilder<BluetoothState>(
              stream: bleManager.observeBluetoothState(),
              initialData: BluetoothState.UNKNOWN,
              builder: (c, snapshot) {
                final state = snapshot.data;
                if (state == BluetoothState.POWERED_ON) {
                  if (ble) {
                    return FindDevicesScreenBLE(bleManager);
                  }
                  if (!ble) return FindDevicesScreen();
                }
                return BluetoothOffScreen(state: state);
              }),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Menü'),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(205, 196, 83, 1),
                  ),
                ),
                ListTile(
                  title: Text('BLE (Bluetooth Low Energy)'),
                  onTap: () {
                    setState(() {
                      ble = true;
                    });
                  },
                ),
                ListTile(
                  title: Text('RFCOMM (HC-05)'),
                  onTap: () {
                    setState(() {
                      ble = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

void setup(BleManager bleManager) async {
  await bleManager.createClient(
      restoreStateIdentifier: "example-restore-state-identifier",
      restoreStateAction: (peripherals) {
        peripherals?.forEach((peripheral) {
          Fimber.d("Restored peripheral: ${peripheral.name}");
        });
      });
}
