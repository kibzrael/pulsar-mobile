import 'package:flutter/material.dart';
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
        body: Container(
          color: Theme.of(context).colorScheme.surface,
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
