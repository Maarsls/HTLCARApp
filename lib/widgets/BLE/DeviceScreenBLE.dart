import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:htl_car/models/BLEManager.dart';
import 'package:htl_car/widgets/BLE/OptionsBLE.dart';
import 'package:htl_car/widgets/BLE/MovementBLE.dart';

StreamController<bool> streamController = StreamController();

class DeviceScreenBLE extends StatefulWidget {
  final Peripheral device;

  const DeviceScreenBLE(this.device);
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreenBLE> {
  int _selectedIndex = 0;
  BLEManager bleManager;

  List<Widget> _children = List<Widget>();
  @override
  void initState() {
    super.initState();
    bleManager = new BLEManager(widget.device);

    AutoOrientation.landscapeAutoMode();

    _children.add(MovementBLE(bleManager));
    _children.add(OptionsBLE(bleManager));
  }

  @override
  void dispose() {
    super.dispose();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<PeripheralConnectionState>(
          stream: widget.device.observeConnectionState(),
          initialData: PeripheralConnectionState.connecting,
          builder: (c, snapshot) {
            print(snapshot.data);
            switch (snapshot.data) {
              case PeripheralConnectionState.connected:
                return Text('verbunden mit ${widget.device.name}');
                break;
              case PeripheralConnectionState.connecting:
                return Text('wird verbunden mit ${widget.device.name}');
                break;
              case PeripheralConnectionState.disconnected:
                return Text('Verbindung abgebrochen mit ${widget.device.name}');
                break;
              default:
                return Text(
                    snapshot.data.toString().substring(21).toUpperCase());
                break;
            }
          },
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Steuerung',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brush_outlined),
            label: 'Optionen',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

void connectPeripheral(Peripheral peripheral) async {
  await peripheral.connect();
}
