import 'package:flutter/material.dart';

class EditBirthday extends StatefulWidget {
  const EditBirthday({Key? key}) : super(key: key);

  @override
  _EditBirthdayState createState() => _EditBirthdayState();
}

class _EditBirthdayState extends State<EditBirthday> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Birthday')));
  }
}
