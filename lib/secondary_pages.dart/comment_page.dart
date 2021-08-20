import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/models/comment_card.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';
import 'package:pulsar/widgets/text_input.dart';

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String comment = '';

  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      maxRatio: 0.9,
      child: Column(
        children: [
          Flexible(
            child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  return CommentCard(attachment: index.isEven);
                }),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: MyTextInput(
              hintText: 'Make a comment...',
              maxLines: 7,
              height: null,
              padding: EdgeInsets.only(left: 12),
              prefix: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(MyIcons.attatchment),
              ),
              onChanged: (text) {
                setState(() {
                  comment = text;
                });
              },
              onSubmitted: (text) {
                if (comment.length > 0 && comment.trim() != '') {
                  setState(() {});
                  // await for message to be added
                }
              },
              suffix: Row(
                children: [
                  if (comment.length < 1)
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(MyIcons.camera),
                    ),
                  if (comment.length < 1)
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(MyIcons.mic),
                    ),
                  InkWell(
                    onTap: () {},
                    child: Card(
                      margin: EdgeInsets.all(2),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21)),
                      child: Container(
                        child: Icon(MyIcons.send),
                        height: 42,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
