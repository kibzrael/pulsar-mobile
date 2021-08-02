import 'package:flutter/material.dart';
import 'package:pulsar/ads/native_ad.dart';
import 'package:pulsar/classes/challenge.dart';

class ChallengeRules extends StatefulWidget {
  final Challenge challenge;
  final String rules;
  ChallengeRules(this.challenge, {required this.rules});
  @override
  _ChallengeRulesState createState() => _ChallengeRulesState();
}

class _ChallengeRulesState extends State<ChallengeRules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenge Instructions'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            child: Text(
              '#${widget.challenge.name}',
              style:
                  Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 24),
              maxLines: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            child: Text(
              widget.rules,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontStyle: FontStyle.italic, fontSize: 16.5),
            ),
          ),
          SizedBox(height: 15),
          MyNativeAd()
        ],
      ),
    );
  }
}
