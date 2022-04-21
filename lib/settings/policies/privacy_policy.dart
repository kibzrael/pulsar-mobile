import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/widgets/progress_indicator.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  PDFDocument? document;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    document =
        await PDFDocument.fromAsset('assets/documents/Privacy Policy.pdf');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: document == null
          ? const Center(child: MyProgressIndicator())
          : PDFViewer(document: document!),
    );
  }
}
