import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:htl_car/models/BluetoothManager.dart';
import 'package:htl_car/models/BluetoothManagerBLE.dart';
import 'package:htl_car/models/BLEManager.dart';
import 'package:sensors/sensors.dart';

class MovementBLE extends StatefulWidget {
  final BLEManager bleManager;

  const MovementBLE(this.bleManager);

  @override
  _MovementState createState() => _MovementState();
}

class _MovementState extends State<MovementBLE> {
  double _currentV = 5;
  StreamSubscription<dynamic> _streamSubscriptions;
  List<double> _accelerometerValues;

  BLEManager _bluetoothManagerBLENew;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bluetoothManagerBLENew = widget.bleManager;

    /*_streamSubscriptions = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        if (widget.manager.isFound())
          widget.manager.writeData("Y " + event.y.toStringAsPrecision(3));
        _streamSubscriptions
            .pause(new Future.delayed(const Duration(milliseconds: 100)));
      },
    );*/
  }

  @override
  void dispose() {
    super.dispose();
    widget.bleManager.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 50),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Geschwindigkeit'),
              Slider(
                activeColor: Colors.greenAccent,
                value: _currentV,
                min: 0,
                max: 255,
                divisions: 255,
                label: _currentV.round().toString(),
                onChanged: (double value) => sendVelo(value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed:
                      () => /*widget.manager.writeData("V")*/ _bluetoothManagerBLENew
                          .writeData("V"),
                  child: Text("Vor"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed:
                      () => /*widget.manager.writeData("Z")*/ _bluetoothManagerBLENew
                          .writeData("AT+NameBLE"),
                  child: Text("Zurück"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed:
                      () => /*widget.manager.writeData("Z")*/ _bluetoothManagerBLENew
                          .writeData("AT"),
                  child: Text("AT"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void sendVelo(double value) {
    setState(() {
      _currentV = value;
    });
    //widget.manager.writeData("G " + value.toString());
  }
}
