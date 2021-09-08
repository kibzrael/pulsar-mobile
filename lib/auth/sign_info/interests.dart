import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/data/categories.dart';
import 'package:pulsar/widgets/floating_button.dart';
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
          leading: IconButton(
              icon: Icon(MyIcons.back),
              onPressed: () {
                provider.previousPage();
              }),
          title: Text('Interests'),
          centerTitle: true,
        ),
        floatingActionButton: MyFloatingActionButton(
          color: disabled ? Theme.of(context).disabledColor : null,
          onPressed: disabled
              ? null
              : () {
                  login();
                },
          child: disabled
              ? Text(
                  '${selected.length}',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                )
              : isSubmitting
                  ? Padding(
                      padding: EdgeInsets.all(12.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: MyProgressIndicator(
                          margin: EdgeInsets.zero,
                        ),
                      ),
                    )
                  : Icon(MyIcons.check, size: 30),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: constraints.maxHeight,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                    child: Text(
                      'Select the fields you are interested in. Please pick a minimum of three.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                        itemCount: interests.length,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          Interest interest = interests[index];
                          bool isSelected = selected.contains(interest);

                          List<String> names = interest.name.split(' ');
                          return InkWell(
                            onTap: () {
                              setState(() {
                                isSelected
                                    ? selected.remove(interest)
                                    : selected.add(interest);
                              });
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                      image: interest.coverPhoto != null
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  interest.coverPhoto!))
                                          : null,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: isSelected
                                            ? Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.5)
                                            : Colors.black12,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: EdgeInsets.all(4),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            for (String name in names)
                                              Text(
                                                name,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                        color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      margin: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(colors: [
                                            Colors.blue,
                                            Theme.of(context).buttonColor
                                          ])),
                                      child: Icon(
                                        MyIcons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        }));
  }
}
