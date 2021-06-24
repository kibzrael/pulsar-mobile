import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/list_tile.dart';

class Cache extends StatefulWidget {
  @override
  _CacheState createState() => _CacheState();
}

class _CacheState extends State<Cache> {
  @override
  Widget build(BuildContext context) {
    return MyListTile(
      title: 'Clear Cache',
      leading: Icon(
        MyIcons.cache,
        color: Theme.of(context).textTheme.subtitle2!.color,
      ),
      trailingArrow: false,
      trailingText: '24mb',
    );
  }
}
