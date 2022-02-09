import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/list_tile.dart';

class LogOut extends StatefulWidget {
  const LogOut({Key? key}) : super(key: key);

  @override
  _LogOutState createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
  LoginProvider? loginProvider;
  @override
  Widget build(BuildContext context) {
    loginProvider = Provider.of<LoginProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: MyListTile(
        title: 'Log out',
        trailingArrow: false,
        trailing: Icon(MyIcons.logOut),
        onPressed: () async {
          var response = await openDialog(
            context,
            (context) => const MyDialog(
              title: 'Log out?',
              body: "Confirm that you want to log out",
              actions: ['Cancel', 'Log out'],
              destructive: 'Log out',
            ),
            dismissible: true,
          );
          if (response == 'Log out') {
            loginProvider!.logout(context);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
