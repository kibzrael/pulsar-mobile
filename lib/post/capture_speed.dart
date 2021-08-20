import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CaptureSpeed extends StatefulWidget {
  final double initial;
  final Function(int index) onPressed;

  CaptureSpeed({required this.initial, required this.onPressed});

  @override
  _CaptureSpeedState createState() => _CaptureSpeedState();
}

class _CaptureSpeedState extends State<CaptureSpeed> {
  int speed = 2;

  @override
  void initState() {
    super.initState();
    speeds.forEach((key, value) {
      if (value == widget.initial) {
        speed = key;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget speedWidget(double speed) {
      return Text('${speed.toString()}x');
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: CupertinoSegmentedControl<int>(
          borderColor: Colors.transparent,
          unselectedColor: Colors.black26,
          selectedColor: Colors.white,
          pressedColor: Colors.black26,
          groupValue: speed,
          children: {
            0: speedWidget(speeds[0]!),
            1: speedWidget(speeds[1]!),
            2: speedWidget(speeds[2]!),
            3: speedWidget(speeds[3]!),
            4: speedWidget(speeds[4]!),
          },
          onValueChanged: (int index) {
            setState(() {
              speed = index;
            });
            widget.onPressed(index);
          }),
    );
  }
}

Map<int, double> speeds = {
  0: 0.3,
  1: 0.5,
  2: 1.0,
  3: 2.0,
  4: 3.0,
};
