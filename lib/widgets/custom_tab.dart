import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String text;
  final bool divider;
  final IconData? icon;
  const CustomTab(this.text, {Key? key, this.divider = true, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Tab(
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: icon == null
                    ? Text(
                        text,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    : Icon(icon),
              ),
            ),
            if (divider)
              Container(
                width: 0.75,
                height: 15,
                color: Theme.of(context).dividerColor,
              )
          ],
        ),
      ),
    );
  }
}
