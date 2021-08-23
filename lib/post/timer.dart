import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CaptureTimer extends StatefulWidget {
  final double initial;
  final Function(int index) onPressed;

  CaptureTimer({required this.initial, required this.onPressed});

  @override
  _CaptureTimerState createState() => _CaptureTimerState();
}

class _CaptureTimerState extends State<CaptureTimer> {
  int timer = 1;

  @override
  Widget build(BuildContext context) {
    Widget timerWidget(int timer) {
      return Text('${timer.toString()}s');
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 45, vertical: 4),
      child: CupertinoSegmentedControl<int>(
          borderColor: Colors.transparent,
          unselectedColor: Colors.black26,
          selectedColor: Colors.white,
          pressedColor: Colors.black26,
          groupValue: timer,
          children: {
            0: timerWidget(30),
            1: timerWidget(60),
            2: timerWidget(90),
          },
          onValueChanged: (int index) {
            setState(() {
              timer = index;
            });
            widget.onPressed(index == 0
                ? 30
                : index == 1
                    ? 60
                    : 90);
          }),
    );
  }
}
