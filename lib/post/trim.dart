import 'package:flutter/material.dart';
import 'package:patterns_canvas/patterns_canvas.dart';

class TrimVideo extends StatefulWidget {
  const TrimVideo({Key? key}) : super(key: key);

  @override
  _TrimVideoState createState() => _TrimVideoState();
}

class _TrimVideoState extends State<TrimVideo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: SizedBox(
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).cardColor,
                ),
                child: ListView.builder(
                    itemCount: 15,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 75,
                        height: 100,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white12, width: 2)),
                      );
                    }),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text('0:00'),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text('1:13'),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 24,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(15)),
                  child: CustomPaint(
                    size: Size(24, 100),
                    painter: HandlePainter(),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(15)),
                  child: CustomPaint(
                    size: Size(24, 100),
                    painter: HandlePainter(),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 8,
                height: 135,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient:
                        LinearGradient(begin: Alignment.topCenter, colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).buttonColor,
                    ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HandlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Prepare a rectangle shape to draw the pattern on.
    final rect = Rect.fromLTRB(0, 0, 24, 100);

    // Create a Pattern object of diagonal stripes with the colors we want.
    final Pattern pattern = DiagonalStripesThick(
        bgColor: Colors.transparent,
        fgColor: Colors.grey[850]!,
        featuresCount: 20);

    // Paint the pattern on the rectangle.
    pattern.paintOnRect(canvas, size, rect);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
