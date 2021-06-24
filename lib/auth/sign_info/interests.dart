import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/providers/login_provider.dart';

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  late LoginProvider loginProvider;

  late SignInfoProvider provider;

  List<Map<String, dynamic>> interests = [
    {'name': 'Art', 'icon': MyIcons.palette},
    {'name': 'Music', 'icon': MyIcons.music},
    {'name': 'Dance', 'icon': MyIcons.dance},
    {'name': 'Comedy', 'icon': MyIcons.comedy},
    {'name': 'Acting', 'icon': MyIcons.acting},
    {'name': 'Fashion', 'icon': MyIcons.fashion},
  ];

  List<Map<String, dynamic>> selected = [];

  @override
  Widget build(BuildContext context) {
    loginProvider = Provider.of<LoginProvider>(context);

    provider = Provider.of<SignInfoProvider>(context);

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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).buttonColor,
          onPressed: () {
            loginProvider.login();
          },
          child: Icon(MyIcons.check, size: 30),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Select the fields you are interested in. Please pick a minimum of three.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: ListView.builder(
                      itemCount: interests.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        bool isSelected = selected.contains(interests[index]);
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isSelected
                                    ? selected.remove(interests[index])
                                    : selected.add(interests[index]);
                              });
                            },
                            child: Chip(
                              elevation: 1,
                              avatar: Icon(interests[index]['icon']),
                              backgroundColor: isSelected
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).chipTheme.backgroundColor,
                              labelPadding: EdgeInsets.symmetric(vertical: 2),
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(interests[index]['name']),
                                  SizedBox(
                                    width: isSelected ? 5 : 15,
                                  ),
                                  if (isSelected)
                                    Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(colors: [
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              Theme.of(context).buttonColor
                                            ])),
                                        child: Icon(MyIcons.check, size: 18))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ));
  }
}
