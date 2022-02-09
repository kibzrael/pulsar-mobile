import 'package:flutter/material.dart';
import 'package:pulsar/ads/list_tile_ad.dart';
import 'package:pulsar/classes/challenge.dart';

class ChallengeRules extends StatefulWidget {
  final Challenge challenge;
  final String rules;
  const ChallengeRules(this.challenge, {Key? key, required this.rules}) : super(key: key);
  @override
  _ChallengeRulesState createState() => _ChallengeRulesState();
}

class _ChallengeRulesState extends State<ChallengeRules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Instructions'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            child: Text(
              '#${widget.challenge.name}',
              style:
                  Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 24),
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            child: Text(
              widget.rules,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontStyle: FontStyle.italic, fontSize: 16.5),
            ),
          ),
          const SizedBox(height: 15),
          const ListTileAd()
        ],
      ),
    );
  }
}
