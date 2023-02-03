import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/text_input.dart';

class CountryCodes extends StatefulWidget {
  const CountryCodes({Key? key}) : super(key: key);

  @override
  State<CountryCodes> createState() => _CountryCodesState();
}

class _CountryCodesState extends State<CountryCodes> {
  List<Map<String, String>> codes = [
    {'country': 'Kenya', 'code': '+254'},
    {'country': 'Kuwait', 'code': '+349'}
  ];

  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      title: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
            padding: const EdgeInsets.fromLTRB(30, 4, 30, 12),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: MyTextInput(
              hintText: 'Country Code',
              height: 42,
              prefix: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  MyIcons.search,
                  color:
                      Theme.of(context).inputDecorationTheme.hintStyle!.color,
                ),
              ),
              onChanged: (text) {},
              onSubmitted: (text) {},
            )),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView.builder(
            itemCount: codes.length,
            itemBuilder: (context, index) {
              return MyListTile(
                leading: const Icon(Icons.flag_outlined),
                title: codes[index]['country'],
                trailingText: codes[index]['code'],
                flexRatio: const [3, 1],
              );
            }),
      ),
    );
  }
}
