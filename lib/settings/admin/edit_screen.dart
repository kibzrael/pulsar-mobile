import 'package:flutter/material.dart';
import 'package:pulsar/widgets/text_button.dart';

class EditScreen extends StatefulWidget {
  final String field;
  final int maxLength;
  final String? initialText;
  const EditScreen(
      {Key? key,
      required this.field,
      required this.maxLength,
      this.initialText})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController controller;
  String text = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;

    double size =
        MediaQuery.of(context).size.height - (topPadding + kToolbarHeight);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Screen"),
        actions: [
          MyTextButton(
              text: "Done",
              onPressed: () {
                Navigator.pop(context, text);
              })
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        height: size,
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Text('Edit the value of\n${widget.field}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1),
            const SizedBox(height: 30),
            TextField(
                controller: controller,
                autofocus: true,
                maxLength: widget.maxLength,
                decoration: InputDecoration(
                  hintText: widget.field,
                ),
                onChanged: (value) => setState(() {
                      text = value;
                    }),
                onSubmitted: (value) => text = ''),
            const Spacer(),
          ],
        ),
      )),
    );
  }
}
