import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/list_tile.dart';

class SelectTheme extends StatefulWidget {
  @override
  _SelectThemeState createState() => _SelectThemeState();
}

class _SelectThemeState extends State<SelectTheme> {
  late ThemeProvider themeProvider;
  late int value;

  void themeSwitch(int index) {
    themeProvider.switchTheme(index);
    setState(() {
      value = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    value = themeProvider.themeValue;
    return Scaffold(
      appBar: AppBar(title: Text('Theme')),
      body: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              MyListTile(
                title: 'Light Theme',
                trailingArrow: false,
                onPressed: () => themeSwitch(0),
                trailing: Radio<int>(
                    value: 0,
                    groupValue: value,
                    onChanged: (value) {
                      themeSwitch(value!);
                    }),
              ),
              MyListTile(
                title: 'Dark Theme',
                trailingArrow: false,
                onPressed: () => themeSwitch(1),
                trailing: Radio<int>(
                    value: 1,
                    groupValue: value,
                    onChanged: (value) {
                      themeSwitch(value!);
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
