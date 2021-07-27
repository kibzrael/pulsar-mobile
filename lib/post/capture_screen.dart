import 'package:flutter/material.dart';
import 'package:pulsar/post/edit_screen.dart';
import 'package:pulsar/post/trim.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/text_button.dart';

class CaptureScreen extends StatefulWidget {
  @override
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 36),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TrimVideo(),
            )
          ],
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyTextButton(
                  text: 'Delete',
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MyTextButton(
                  text: 'Next',
                  onPressed: () {
                    Navigator.of(context)
                        .push(myPageRoute(builder: (context) => EditScreen()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
