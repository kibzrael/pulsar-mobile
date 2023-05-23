import 'package:flutter/material.dart';
import 'package:pulsar/placeholders/not_implemented.dart';
import 'package:pulsar/providers/localization_provider.dart';

class Drafts extends StatefulWidget {
  const Drafts({Key? key}) : super(key: key);

  @override
  State<Drafts> createState() => _DraftsState();
}

class _DraftsState extends State<Drafts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(local(context).drafts)),
      body: const NotImplementedError(),
    );
  }
}
