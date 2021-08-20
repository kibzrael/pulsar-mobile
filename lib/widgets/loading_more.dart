import 'package:flutter/material.dart';
import 'package:pulsar/widgets/progress_indicator.dart';

class LoadingMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: MyProgressIndicator(
        margin: EdgeInsets.all(8),
      ),
    );
  }
}
