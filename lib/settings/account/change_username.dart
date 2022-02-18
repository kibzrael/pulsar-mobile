import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/text_button.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  late TextEditingController controller;

  bool isSubmitting = false;

  String text = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: 'tahliastanton');
  }

  onSubmit() {}

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;

    double size =
        MediaQuery.of(context).size.height - (topPadding + kToolbarHeight);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change username'),
          actions: [MyTextButton(text: 'Done', onPressed: onSubmit)],
        ),
        body: SingleChildScrollView(
            child: Container(
          height: size,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Text('Enter the username\nyou\'d like to use.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1),
              const SizedBox(height: 30),
              TextField(
                  autofocus: true,
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: 'Username',
                      suffixIcon: Icon(MyIcons.close),
                      helperText:
                          'Only letters, numbers, underscores(_) and periods(.) are allowed',
                      helperMaxLines: 4),
                  onChanged: (value) => setState(() => text = value),
                  onSubmitted: (text) {}),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              //     child: FittedBox(
              //       fit: BoxFit.scaleDown,
              //       child: Text(
              //         'Only letters, numbers and ._ are allowed',
              //         style: Theme.of(context)
              //             .textTheme
              //             .subtitle2!
              //             .copyWith(fontSize: 12),
              //       ),
              //     ),
              //   ),
              // ),
              const Spacer(),
            ],
          ),
        )),
      ),
    );
  }
}
