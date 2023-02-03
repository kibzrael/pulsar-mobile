import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoComments extends StatelessWidget {
  const NoComments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 30),
      child: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/illustrations/no data.svg',
                width: constraints.maxWidth,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'No Comments',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 32, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Text(
                'Be the first to comment...',
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
    );
  }
}
