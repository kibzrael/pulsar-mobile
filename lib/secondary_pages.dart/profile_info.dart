import 'package:flutter/material.dart';
import 'package:pulsar/widgets/text_button.dart';

class ProfileInfo extends StatefulWidget {
  final String info;
  final int maxCharacters;
  final bool multiline;
  const ProfileInfo(this.info,
      {Key? key, required this.maxCharacters, this.multiline = false})
      : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.info}'),
        actions: [MyTextButton(text: 'Done', onPressed: () {})],
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(30),
        height: size,
        child: Column(
          children: [
            Text(
              'Edit your ${widget.info.toLowerCase()} with a maximum of ${widget.maxCharacters} characters',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
                autofocus: true,
                decoration: InputDecoration(hintText: widget.info),
                maxLength: widget.maxCharacters,
                maxLines: widget.multiline ? 7 : 1,
                minLines: 1,
                buildCounter: (
                  context, {
                  required int currentLength,
                  required int? maxLength,
                  required bool isFocused,
                }) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      '${maxLength! - currentLength}',
                    ),
                  );
                }),
            const Spacer(),
          ],
        ),
      )),
    );
  }
}
