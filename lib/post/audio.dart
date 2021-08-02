import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/post/trim.dart';

class PostAudio extends StatefulWidget {
  @override
  _PostAudioState createState() => _PostAudioState();
}

class _PostAudioState extends State<PostAudio> {
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
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(15))),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(MyIcons.volume),
                ),
              ),
              InkWell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(MyIcons.add),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
