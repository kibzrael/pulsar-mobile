import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/files.dart';
import 'package:pulsar/widgets/list_tile.dart';

class Cache extends StatefulWidget {
  const Cache({Key? key}) : super(key: key);

  @override
  State<Cache> createState() => _CacheState();
}

class _CacheState extends State<Cache> {
  int bytes = 0;
  String get size => fileSize(bytes);
  Future<Directory> get directory async => await getTemporaryDirectory();

  @override
  void initState() {
    super.initState();
    getSize();
  }

  getSize() async {
    Directory dir = await directory;
    if (dir.existsSync()) {
      dir.list(recursive: true, followLinks: false).listen((entity) {
        if (entity is File) {
          bytes += entity.lengthSync();
          setState(() {});
        }
      });
    }
  }

  clear() async {
    Directory dir = await directory;
    if (dir.existsSync()) {
      dir.list(recursive: true, followLinks: false).listen((entity) async {
        if (entity is File) {
          bytes -= entity.lengthSync();
          if (bytes < 0) {
            bytes = 0;
          }
          await entity.delete();
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListTile(
      title: 'Clear Cache',
      leading: Icon(
        MyIcons.cache,
        color: Theme.of(context).textTheme.titleSmall!.color,
      ),
      trailingArrow: false,
      trailingText: size,
      onPressed: clear,
      flexRatio: const [2, 1],
    );
  }
}
