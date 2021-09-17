import 'package:flutter/material.dart';
import 'package:htl_car/models/BluetoothManager.dart';
import 'package:htl_car/widgets/DeviceScreen.dart';

import 'Movement.dart';

class Autonom extends StatefulWidget {
  final BluetoothManager manager;
  final Movement m;

  const Autonom(
    this.manager,
    this.m,
  );

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Autonom> {
  @override
  void initState() {
    super.initState();
  }

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
            onPressed: () => widget.manager.sendMessageToBluetooth("C"),
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
                widget.manager.sendMessageToBluetooth("C");
              },
            ),
          ],
        );
      },
    );
  }
}
