import 'package:flutter/material.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';

class OptionsRail extends StatefulWidget {
  final List<String> options;
  final String selected;
  const OptionsRail({Key? key, required this.options, required this.selected})
      : super(key: key);

  @override
  State<OptionsRail> createState() => _OptionsRailState();
}

class _OptionsRailState extends State<OptionsRail> {
  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (String option in widget.options)
            InkWell(
              onTap: () {
                Navigator.pop(context, option);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 8),
                elevation: option == widget.selected ? 4 : 0,
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  alignment: Alignment.center,
                  child: Text(
                    option,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 18),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
