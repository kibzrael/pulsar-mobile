import 'package:flutter/material.dart';
import 'package:pulsar/widgets/text_button.dart';

class SelectUsername extends StatefulWidget {
  final Function(BuildContext context, String text) onSubmit;
  const SelectUsername({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _SelectUsernameState createState() => _SelectUsernameState();
}

class _SelectUsernameState extends State<SelectUsername> {
  // bool isLoading = false;

  String text = '';

  @override
  void initState() {
    super.initState();
  }

  // checkUsername() async {
  //   setState(() => isLoading = true);
  //   await Future.delayed(const Duration(seconds: 2));
  //   setState(() => isLoading = false);
  // }

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
          title: const Text('Select username'),
          actions: [
            MyTextButton(
                text: 'Done', onPressed: () => widget.onSubmit(context, text))
          ],
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
                  decoration: const InputDecoration(
                      hintText: 'Username',
                      helperText:
                          'Only letters, numbers, underscores(_) and periods(.) are allowed',
                      helperMaxLines: 4),
                  onChanged: (value) => setState(() {
                        text = value;
                        // checkUsername();
                      }),
                  onSubmitted: (value) => text = ''),
              const Spacer(),
            ],
          ),
        )),
      ),
    );
  }
}
