import 'package:flutter/material.dart';

class UploadProgressScreen extends StatefulWidget {
  const UploadProgressScreen({Key? key}) : super(key: key);

  @override
  _UploadProgressScreenState createState() => _UploadProgressScreenState();
}

class _UploadProgressScreenState extends State<UploadProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Progress'),
      ),
    );
  }
}
