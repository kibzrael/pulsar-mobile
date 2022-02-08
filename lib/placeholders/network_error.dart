import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/secondary_button.dart';

class NetworkError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              MyIcons.networkError,
              size: 100,
              color: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(height: 15),
            Text('Opps!',
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 30)),
            SizedBox(height: 12),
            Text('No Connection',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 21)),
            SizedBox(height: 24),
            SecondaryButton(text: 'Retry', width: 120, height: 36)
          ],
        ));
  }
}
