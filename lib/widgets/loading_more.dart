import 'package:flutter/material.dart';
import 'package:pulsar/widgets/progress_indicator.dart';

class LoadingMore extends StatelessWidget {
  const LoadingMore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const MyProgressIndicator(
        margin: EdgeInsets.all(8),
      ),
    );
  }
}
