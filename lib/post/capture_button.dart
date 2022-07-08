import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/providers/theme_provider.dart';

class CaptureButton extends StatefulWidget {
  final Function() onPressed;
  final Function() onStop;
  final bool isRecording;

  final double position;
  final double max;
  const CaptureButton(
      {Key? key,
      required this.isRecording,
      required this.onPressed,
      required this.onStop,
      required this.position,
      required this.max})
      : super(key: key);

  @override
  _CaptureButtonState createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: widget.onPressed,
      onLongPressDown: (_) {
        widget.onPressed();
      },
      onLongPressEnd: (_) {},
      child:

          // SleekCircularSlider(
          //   appearance: CircularSliderAppearance(
          //       size: 80,
          //       angleRange: 360,
          //       startAngle: 270.0,
          //       customWidths:
          //           CustomSliderWidths(trackWidth: 3, progressBarWidth: 3),
          //       customColors: CustomSliderColors(
          //           dotColor: Colors.transparent,
          //           trackColor: Colors.white,
          //           progressBarColors: [
          //             Colors.blue,
          //             Colors.deepPurpleAccent,
          //             Theme.of(context).accentColor
          //           ],
          //           dynamicGradient: true),
          //       animationEnabled: false),
          //   initialValue: 0,
          //   min: 0,
          //   max: 100,
          //   innerWidget: (_) {
          //     return Container(
          //         margin: EdgeInsets.all(12),
          //         alignment: Alignment.center,
          //         decoration: BoxDecoration(
          //           color: Theme.of(context).accentColor,
          //           shape: BoxShape.circle,
          //         ),
          //         child: Icon(
          //           MyIcons.camera,
          //           color: Colors.white,
          //           size: 35,
          //         ));
          //   },
          // )
          Stack(
        alignment: Alignment.center,
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return SweepGradient(
                  transform: const GradientRotation(4.75),
                  stops: widget.isRecording
                      ? [
                          0.0, (widget.position / widget.max) * 0.5,
                          widget.position / widget.max,
                          widget.position / widget.max,
                          // 0.25,
                          // 0.5,
                          // 0.5
                        ]
                      : [0, 0, 0, 0],
                  colors: [
                    Colors.blue,
                    Colors.deepPurpleAccent,
                    Theme.of(context).colorScheme.secondary,
                    Colors.white
                  ]).createShader(rect);
            },
            child: Container(
              margin: const EdgeInsets.all(12),
              constraints: const BoxConstraints(maxHeight: 100, maxWidth: 100),
              decoration: BoxDecoration(
                  color: Colors.white10,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3)),
            ),
          ),
          AnimatedContainer(
              padding: const EdgeInsets.all(4),
              duration: const Duration(seconds: 1),
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: widget.isRecording ? null : accentGradient(),
                color: widget.isRecording
                    ? Colors.redAccent
                    : Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: widget.isRecording
                    ? Text(
                        '${((widget.max - widget.position) / 1000).ceil()}',
                        style: const TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w800),
                      )
                    : Icon(
                        MyIcons.camera,
                        color: Colors.white,
                        size: 42,
                      ),
              ))
        ],
      ),
    );
  }
}
