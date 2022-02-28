import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/text_button.dart';

class SlideTemplate extends StatelessWidget {
  final String illustration;
  final String description;
  final TextStyle? style;
  final Widget? title;
  final Widget? trailing;
  final Function(int page)? toPage;
  final Function()? onNext;
  final Function()? onSkip;
  final int index;
  const SlideTemplate(
      {required this.illustration,
      required this.description,
      this.style,
      this.title,
      this.trailing,
      this.toPage,
      this.onNext,
      this.onSkip,
      this.index = 0,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          height: constraints.maxHeight,
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(
                illustration,
                height: constraints.maxWidth * 3 / 4,
              ),
              const Spacer(),
              if (title != null) title!,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 18),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: style,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 3; i++)
                    InkWell(
                      onTap: () {
                        if (toPage != null) {
                          toPage!(i);
                        }
                      },
                      child: Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.surface,
                            gradient: index == i ? primaryGradient() : null,
                            border: index == i
                                ? null
                                : Border.all(
                                    color: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor!)),
                      ),
                    )
                ],
              ),
              const Spacer(),
              if (trailing != null)
                trailing!
              else
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyTextButton(
                          text: 'Skip',
                          onPressed: () {
                            if (onSkip != null) {
                              onSkip!();
                            }
                          }),
                      ActionButton(
                        title: 'Next',
                        width: 100,
                        height: 42,
                        onPressed: () {
                          if (onNext != null) {
                            onNext!();
                          }
                        },
                      )
                    ],
                  ),
                )
            ],
          ),
        );
      }),
    );
  }
}
