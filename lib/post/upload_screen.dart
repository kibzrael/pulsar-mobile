import 'package:flutter/material.dart';
import 'package:pulsar/widgets/text_button.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MyTextButton(
              text: 'Upload',
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              })
        ],
      ),
    );
  }
}
