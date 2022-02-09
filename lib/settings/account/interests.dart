import 'package:flutter/material.dart';

class EditInterests extends StatefulWidget {
  const EditInterests({Key? key}) : super(key: key);

  @override
  _EditInterestsState createState() => _EditInterestsState();
}

class _EditInterestsState extends State<EditInterests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Interests')));
  }
}
