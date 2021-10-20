import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/data/categories.dart';
import 'package:pulsar/widgets/floating_button.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/progress_indicator.dart';

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  late SignInfoProvider provider;

  bool isSubmitting = false;

  List<Interest> interests = allCategories;

  List<Interest> selected = [];

  void login() async {
    provider.user.interests = selected;
    setState(() {
      isSubmitting = true;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isSubmitting = false;
    });
    Navigator.of(context).pushReplacementNamed('/');
    return;
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SignInfoProvider>(context);

    bool disabled = selected.length < 3;

    return Scaffold(
        appBar: AppBar(
            title: SignInfoTitle(
          title: 'Interests',
          onBack: provider.previousPage,
          onForward: login,
        )),
        // floatingActionButton: MyFloatingActionButton(
        //   color: disabled ? Theme.of(context).disabledColor : null,
        //   onPressed: disabled
        //       ? null
        //       : () {
        //           login();
        //         },
        //   child: disabled
        //       ? Text(
        //           '${selected.length}',
        //           style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
        //         )
        //       : isSubmitting
        //           ? Padding(
        //               padding: EdgeInsets.all(12.0),
        //               child: FittedBox(
        //                 fit: BoxFit.scaleDown,
        //                 child: MyProgressIndicator(
        //                   margin: EdgeInsets.zero,
        //                 ),
        //               ),
        //             )
        //           : Icon(MyIcons.check, size: 30),
        // ),
        body: ListView.builder(
          itemCount: interests.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: Text(
                  'Select the fields you\nare interested in',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 24),
                ),
              );
            }

            Interest interest = interests[index - 1];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyListTile(
                  title: interest.name,
                  subtitle: '2K posts',
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        Theme.of(context).inputDecorationTheme.fillColor,
                    backgroundImage: AssetImage(interest.coverPhoto!),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.only(bottom: 12),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      for (int i = 0; i < 4; i++)
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(interest.name),
                                ),
                                Icon(MyIcons.add)
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}
