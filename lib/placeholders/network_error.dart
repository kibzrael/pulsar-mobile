import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NetworkError extends StatelessWidget {
  const NetworkError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: LayoutBuilder(builder: (context, constraints) {
          return SvgPicture.asset(
            'assets/illustrations/404.svg',
            width: constraints.maxWidth,
          );
        }),
      ),
    );
  }
}
