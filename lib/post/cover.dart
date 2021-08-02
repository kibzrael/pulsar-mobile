import 'package:flutter/material.dart';
import 'package:pulsar/post/trim.dart';

class PostCover extends StatefulWidget {
  @override
  _PostCoverState createState() => _PostCoverState();
}

class _PostCoverState extends State<PostCover> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
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
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            width: 25,
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white12, width: 1)),
                          );
                        }),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: 18,
                    height: 100,
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(begin: Alignment.topCenter, colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).buttonColor,
                        ]),
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(15))),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(15)),
                      child: CustomPaint(
                        size: Size(18, 100),
                        painter: HandlePainter(),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: Container(
                    width: 18,
                    height: 100,
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(begin: Alignment.topCenter, colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).buttonColor,
                        ]),
                        borderRadius:
                            BorderRadius.horizontal(left: Radius.circular(15))),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(15)),
                      child: CustomPaint(
                        size: Size(18, 100),
                        painter: HandlePainter(),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                )
              ],
            ),
            SizedBox(
              height: 15,
            )
          ],
        ));
  }
}
