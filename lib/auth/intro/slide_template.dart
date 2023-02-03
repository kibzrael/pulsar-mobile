import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/text_button.dart';

class SlideTemplate extends StatelessWidget {
  final String illustration;
  final String description;
  final String title;
  final Function(int page)? toPage;
  final Function()? onNext;
  final Function()? onSkip;
  final int index;
  const SlideTemplate(
      {required this.illustration,
      required this.description,
      required this.title,
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
                height: constraints.maxWidth,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 24, fontWeight: FontWeight.w800),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
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
                            gradient: index == i ? accentGradient() : null,
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
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextButton(
                        text: 'Skip',
                        color: Theme.of(context).colorScheme.error,
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
