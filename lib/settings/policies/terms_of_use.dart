import 'package:flutter/material.dart';
import 'package:pulsar/placeholders/not_implemented.dart';

class TermsOfUse extends StatefulWidget {
  const TermsOfUse({Key? key}) : super(key: key);

  @override
  State<TermsOfUse> createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Terms of Use')),
        body: const NotImplementedError());
  }
}
