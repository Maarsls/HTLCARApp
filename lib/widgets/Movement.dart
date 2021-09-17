import 'dart:async';
import 'package:flutter/material.dart';
import 'package:htl_car/models/BluetoothManager.dart';
import 'package:sensors/sensors.dart';

class Movement extends StatefulWidget {
  final BluetoothManager manager;

  const Movement(this.manager, {Key key}) : super(key: key);

  method() => createState().stop();
  @override
  _MovementState createState() => _MovementState();
}

class _MovementState extends State<Movement> {
  TextEditingController ledController = TextEditingController();
  StreamSubscription<dynamic> _streamSubscriptions;

  double _currentV = 20;
  double _sendV = 20;
  bool autonom = false;

  void stop() {
    setState(() {
      autonom = true;
    });
    print(autonom);
  }

  @override
  void initState() {
    super.initState();
    _sendV = 20;

    /*_streamSubscriptions = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        if (!widget.manager.getIsConnecting() && !autonom) {
          widget.manager
              .sendMessageToBluetooth("Y " + event.x.toStringAsPrecision(3));
        }
        _streamSubscriptions
            .pause(new Future.delayed(const Duration(milliseconds: 200)));
      },
    );*/
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscriptions.cancel();
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
                divisions: 100,
                label: _currentV.round().toString(),
                onChangeEnd: sendVelo,
                onChanged: setVelo,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => widget.manager.sendMessageToBluetooth("V"),
                  child: Text("Vor"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => widget.manager.sendMessageToBluetooth("Z"),
                  child: Text("Zurück"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void setVelo(double value) {
    setState(() {
      _currentV = value;
      _sendV = value;
    });
  }

  void sendVelo(double value) {
    print("asdfasdfasd");
    widget.manager.sendMessageToBluetooth('G ' + _sendV.toStringAsPrecision(3));
  }
}
