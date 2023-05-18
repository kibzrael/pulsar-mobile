import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pulsar/providers/localization_provider.dart';

class NetworkError extends StatelessWidget {
  final double? width;
  final Function() onRetry;
  const NetworkError({Key? key, this.width, required this.onRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRetry,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/illustrations/no connection.svg',
                    width: width ?? constraints.maxWidth,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        local(context).noConnection,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 32, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Text(
                    local(context).tapToRetry,
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
      ),
    );
  }
}

class NetworkErrorModel extends StatelessWidget {
  final Function() onRetry;
  const NetworkErrorModel({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(builder: (context, constraints) {
          return Row(
            children: [
              SvgPicture.asset(
                'assets/illustrations/no connection.svg',
                width: constraints.maxWidth / 2,
              ),
              SizedBox(
                width: constraints.maxWidth / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 4),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          local(context).noConnection,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Text(
                      local(context).tapToRetry,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontSize: 21, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
