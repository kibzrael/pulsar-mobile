import 'package:flutter/material.dart';

class MyBottomSheet extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final double maxRatio;
  MyBottomSheet({required this.child, this.title, this.maxRatio = 1});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        constraints: BoxConstraints(
            maxHeight: maxRatio *
                    (constraints.maxHeight -
                        (MediaQuery.of(context).padding.top + kToolbarHeight)) +
                6),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 180,
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          borderRadius: BorderRadius.circular(15)),
                      height: 5,
                      width: 150,
                      margin: EdgeInsets.only(bottom: 15),
                    ),
                  ),
                  if (title != null) title!,
                  Flexible(
                    child: Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: child),
                  ),
                ],
              ),
            ),
          ),
        ]),
      );
    });
  }
}
