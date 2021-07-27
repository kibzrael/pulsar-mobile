import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/widgets/list_tile.dart';

class LogOut extends StatefulWidget {
  @override
  _LogOutState createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
  LoginProvider? loginProvider;
  @override
  Widget build(BuildContext context) {
    loginProvider = Provider.of<LoginProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
          onTap: () {
            loginProvider!.logout(context);
            Navigator.pop(context);
          },
          child: MyListTile(
            title: 'Log out',
            trailingArrow: false,
            trailing: Icon(MyIcons.logOut),
          )),
    );
  }
}
