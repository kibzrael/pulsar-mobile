import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/widgets/progress_indicator.dart';

class TermsOfUse extends StatefulWidget {
  const TermsOfUse({Key? key}) : super(key: key);

  @override
  State<TermsOfUse> createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
  PDFDocument? document;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    document =
        await PDFDocument.fromAsset('assets/documents/Terms of Service.pdf');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Use')),
      body: document == null
          ? const Center(child: MyProgressIndicator())
          : PDFViewer(document: document!),
    );
  }
}
