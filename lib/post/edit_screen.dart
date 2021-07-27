import 'package:flutter/material.dart';
import 'package:pulsar/post/audio.dart';
import 'package:pulsar/post/cover.dart';
import 'package:pulsar/post/edits.dart';
import 'package:pulsar/post/upload_screen.dart';
import 'package:pulsar/widgets/custom_tab.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/text_button.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            MyTextButton(
                text: 'Next',
                onPressed: () {
                  Navigator.of(context)
                      .push(myPageRoute(builder: (context) => UploadScreen()));
                })
          ],
        ),
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
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      VideoEdits(),
                      PostAudio(),
                      PostCover(),
                    ]),
              )
            ],
          ),
        ),
        bottomNavigationBar: TabBar(
          indicator: BoxDecoration(),
          unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
          labelPadding: EdgeInsets.zero,
          tabs: [
            CustomTab('Edits'),
            CustomTab('Audio'),
            CustomTab(
              'Cover',
              divider: false,
            )
          ],
        ),
      ),
    );
  }
}
