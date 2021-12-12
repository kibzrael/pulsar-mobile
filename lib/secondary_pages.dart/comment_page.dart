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
  late TextEditingController commentController;

  String comment = '';

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      maxRatio: 0.9,
      child: Scaffold(
        body: Column(
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
              child: Row(
                children: [
                  Flexible(
                    child: MyTextInput(
                      hintText: 'Make a comment...',
                      maxLines: 7,
                      height: null,
                      controller: commentController,
                      padding: EdgeInsets.fromLTRB(
                          4, 2, comment.length < 1 ? 4 : 8, 2),
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      if (comment.length > 0 && comment.trim() != '') {
                        setState(() {
                          commentController.text = '';
                          comment = '';
                        });
                      }
                    },
                    child: Card(
                      margin: EdgeInsets.all(2),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21)),
                      child: Container(
                        child: Icon(
                          MyIcons.send,
                          color: Colors.white,
                        ),
                        height: 42,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21),
                            gradient: LinearGradient(colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primaryVariant
                            ])),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
