import 'package:flutter/material.dart';
import 'package:pulsar/placeholders/not_implemented.dart';
import 'package:pulsar/providers/localization_provider.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(local(context).privacyPolicy)),
        body: const NotImplementedError());
  }
}
