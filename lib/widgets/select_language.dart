import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/settings/language.dart';
import 'package:pulsar/widgets/route.dart';

class SelectLanguage extends StatefulWidget {
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(myPageRoute(builder: (context) => Language()));
        },
        child: Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            border: Border.all(color: Theme.of(context).cardColor, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'English',
                style: TextStyle(
                  fontSize: 21,
                ),
              ),
              Icon(MyIcons.expand)
            ],
          ),
        ),
      ),
    );
  }
}
