import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/settings/language.dart';
import 'package:pulsar/widgets/route.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          debugPrint('Clicked');
          Navigator.of(context)
              .push(myPageRoute(builder: (context) => const Language()));
        },
        child: Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'English',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Icon(MyIcons.expand, size: 21)
            ],
          ),
        ),
      ),
    );
  }
}
