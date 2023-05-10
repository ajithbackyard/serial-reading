import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

void main() {
  runApp(DirectionApp((direction) {
    print('Direction: $direction');
  }));
}

class DirectionApp extends StatefulWidget {
  final Function(String) onDirectionChanged;

  DirectionApp(this.onDirectionChanged);

  @override
  _DirectionAppState createState() => _DirectionAppState();
}

class _DirectionAppState extends State<DirectionApp> {
  double _x = 0.0, _y = 0.0, _z = 0.0;

  @override
  void initState() {
    super.initState();

    // Start listening to the accelerometer
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;
      });

      String direction = _getDirection();
      widget.onDirectionChanged(direction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Direction App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Direction:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                _getDirection(),
                style: TextStyle(fontSize: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDirection() {
    double angle = _getAngle();

    if (angle >= -45 && angle < 45) {
      return 'back';
    } else if (angle >= 45 && angle < 135) {
      return 'left';
    } else if (angle >= 135 || angle < -135) {
      return 'front';
    } else {
      return 'right';
    }
  }

  double _getAngle() {
    return -180 * atan2(_x, _y) / pi;
  }
}
