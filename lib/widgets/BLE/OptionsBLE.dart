import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:htl_car/models/BluetoothManager.dart';
import 'package:htl_car/models/BluetoothManagerBLE.dart';
import 'package:htl_car/models/BLEManager.dart';

class OptionsBLE extends StatefulWidget {
  final BLEManager bleManager;

  const OptionsBLE(this.bleManager);

  @override
  _ChangeColorState createState() => _ChangeColorState();
}

class _ChangeColorState extends State<OptionsBLE> {
  double _currentR = 20;
  double _currentG = 20;
  double _currentB = 20;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () => _showAutonom(),
            child: Text("Autonom fahren"),
          ),
          ElevatedButton(
            onPressed: () => null /*widget.manager.writeData("C")*/,
            child: Text("selbst steuern"),
          )
        ],
      ),
    );
  }

  Future<void> _showAutonom() async {
    //widget.m.method();
    //widget.manager.sendMessageToBluetooth("C");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Du fährst nun autonom'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Willst du wieder selbst steuren,'),
                Text('dann klicke unten auf Steuerung'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('verstanden'),
              onPressed: () {
                Navigator.pop(context);
                //widget.manager.writeData("C");
              },
            ),
          ],
        );
      },
    );
  }
}
