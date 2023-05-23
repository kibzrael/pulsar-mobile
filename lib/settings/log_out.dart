import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/list_tile.dart';

class LogOut extends StatefulWidget {
  const LogOut({Key? key}) : super(key: key);

  @override
  State<LogOut> createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
  LoginProvider? loginProvider;
  @override
  Widget build(BuildContext context) {
    loginProvider = Provider.of<LoginProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: MyListTile(
        title: local(context).logOut,
        trailingArrow: false,
        trailing: Icon(MyIcons.logOut),
        onPressed: () async {
          await openDialog(
            context,
            (context) => MyDialog(
              title: '${local(context).logOut}?',
              body: local(context).logoutDescription,
              actions: [local(context).cancel, local(context).logOut],
              destructive: local(context).logOut,
            ),
            dismissible: true,
          ).then((response) {
            if (response == local(context).logOut) {
              loginProvider!.logout(context);
              // Navigator.pop(context);
            }
          });
        },
      ),
    );
  }
}
