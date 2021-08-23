import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/text_button.dart';

class PostCover extends StatefulWidget {
  final Function() pop;
  PostCover({required this.pop});
  @override
  _PostCoverState createState() => _PostCoverState();
}

class _PostCoverState extends State<PostCover> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Cover'),
          leading: IconButton(
            icon: Icon(MyIcons.close),
            onPressed: () {
              widget.pop();
            },
          ),
          actions: [
            MyTextButton(
                text: 'Done',
                onPressed: () {
                  widget.pop();
                })
          ],
        ),
        Spacer(),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white12,
                        ),
                        child: ListView.builder(
                            itemCount: 15,
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                width: 25,
                                height: 75,
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
                        height: 75,
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(15))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(15)),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: Container(
                        width: 18,
                        height: 75,
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(15))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(15)),
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 90,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                    )
                  ],
                ),
              ],
            )),
      ],
    );
  }
}
