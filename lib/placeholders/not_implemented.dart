import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pulsar/providers/localization_provider.dart';

class NotImplementedError extends StatelessWidget {
  const NotImplementedError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/illustrations/404.svg',
                  width: constraints.maxWidth,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      local(context).notImplemented,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 32, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Text(
                  local(context).notImplementedDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 21, fontWeight: FontWeight.w400),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

toastNotImplemented() {
  Fluttertoast.showToast(msg: 'Feature Not Implemented');
}
