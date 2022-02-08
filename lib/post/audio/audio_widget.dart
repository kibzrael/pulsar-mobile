import 'package:flutter/material.dart';

class AudioWidget extends StatefulWidget {
  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: SizedBox(
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: double.infinity,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white10,
                ),
                child: ListView.builder(
                    itemCount: 15,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white12, width: 1)),
                      );
                    }),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                width: 18,
                height: 75,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(15)),
                ),
              ),
            ),
            Positioned(
              left: 0,
              child: Container(
                width: 18,
                height: 75,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(15)),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              top: (120 - 75) / 2,
              child: Container(
                width: double.infinity,
                height: 1.5,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: (120 - 75) / 2,
              child: Container(
                width: double.infinity,
                height: 1.5,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Positioned(
              left: 18,
              child: Container(
                width: 5,
                height: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient:
                        LinearGradient(begin: Alignment.topCenter, colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primaryVariant,
                    ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
