import 'package:flutter/material.dart';
import 'package:pulsar/placeholders/not_implemented.dart';

class Drafts extends StatefulWidget {
  const Drafts({Key? key}) : super(key: key);

  @override
  _DraftsState createState() => _DraftsState();
}

class _DraftsState extends State<Drafts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drafts')),
      body: const NotImplementedError(),
    );
  }
}
