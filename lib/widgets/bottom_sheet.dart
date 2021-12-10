import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/providers/theme_provider.dart';

class MyBottomSheet extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final double maxRatio;
  final bool fullDialog;
  MyBottomSheet(
      {required this.child,
      this.title,
      this.maxRatio = 1,
      this.fullDialog = false});

  @override
  Widget build(BuildContext context) {
    double topPadding = Provider.of<ThemeProvider>(context).topPadding;
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        constraints: fullDialog
            ? null
            : BoxConstraints(
                maxHeight: maxRatio *
                        (constraints.maxHeight -
                            (MediaQuery.of(context).padding.top +
                                kToolbarHeight)) +
                    6),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // if (!fullDialog)
          //   Container(
          //     width: 180,
          //     height: 6,
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).scaffoldBackgroundColor,
          //       borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          //     ),
          //   ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(top: fullDialog ? 0 : 10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: fullDialog
                    ? null
                    : BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Column(
                mainAxisSize: fullDialog ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (!fullDialog)
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
                  if (fullDialog)
                    Container(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      height: topPadding,
                    ),
                  if (title != null) title!,
                  myFlex(
                    child: Container(
                        // color: Theme.of(context).colorScheme.surface,
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

  Widget myFlex({required Widget child}) {
    return fullDialog ? Expanded(child: child) : Flexible(child: child);
  }
}
