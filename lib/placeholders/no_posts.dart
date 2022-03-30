import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoPosts extends StatelessWidget {
  final AlignmentGeometry alignment;
  const NoPosts({Key? key, this.alignment = Alignment.topCenter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.all(30),
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
                    'No Content',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontSize: 32, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Text(
                'There are no videos here',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 21, fontWeight: FontWeight.w400),
              )
            ],
          ),
        );
      }),
    );
  }
}

class NoPostsModel extends StatelessWidget {
  const NoPostsModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6),
      child: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            SvgPicture.asset(
              'assets/illustrations/no data.svg',
              width: constraints.maxWidth / 2,
            ),
            SizedBox(
              width: constraints.maxWidth / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'No Content\nAvailable',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
