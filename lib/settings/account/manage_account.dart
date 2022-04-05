import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/placeholders/not_implemented.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/settings/account/change_password.dart';
import 'package:pulsar/settings/account/email.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/profile_pic.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';

class ManageAccount extends StatefulWidget {
  const ManageAccount({Key? key}) : super(key: key);

  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  late User user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Account'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfilePic(user.profilePic?.thumbnail, radius: 36),
                    const SizedBox(width: 15),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('@${user.username}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontSize: 21)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(user.category,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(fontSize: 18)),
                        ])
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MyListTile(
                title: 'Email',
                trailingText: user.email ?? 'None',
                flexRatio: const [0, 1],
                onPressed: () => Navigator.of(context).push(
                    myPageRoute(builder: (context) => const ChangeEmail())),
              ),
              // MyListTile(
              //   title: 'Phone',
              //   trailingText: '0723573568',
              //   flexRatio: const [2, 3],
              //   onPressed: () => Navigator.of(context).push(
              //       myPageRoute(builder: (context) => const ChangePhone())),
              // ),
              MyListTile(
                leading: Icon(MyIcons.password),
                title: 'Change Password',
                onPressed: () => Navigator.of(context).push(
                    myPageRoute(builder: (context) => const ChangePassword())),
              ),
              const SizedBox(
                height: 30,
              ),
              Section(
                title: 'Linked Accounts',
                child: Column(children: [
                  MyListTile(
                    title: 'Facebook',
                    leading: const Image(
                      image: AssetImage('assets/images/logos/facebook.png'),
                      width: 36,
                    ),
                    subtitle: '@${user.username}',
                    onPressed: toastNotImplemented,
                  ),
                  MyListTile(
                    title: 'Google',
                    leading: const Image(
                      image: AssetImage('assets/images/logos/google.png'),
                      width: 36,
                    ),
                    subtitle: '@${user.username}',
                    onPressed: toastNotImplemented,
                  ),
                  MyListTile(
                    title: 'Twitter',
                    leading: const Image(
                      image: AssetImage('assets/images/logos/twitter.png'),
                      width: 36,
                    ),
                    subtitle: '@${user.username}',
                    onPressed: toastNotImplemented,
                  ),
                  MyListTile(
                    title: 'Instagram',
                    leading: const Image(
                      image: AssetImage('assets/images/logos/instagram.png'),
                      width: 36,
                    ),
                    subtitle: '@${user.username}',
                    onPressed: toastNotImplemented,
                  ),
                ]),
              ),

              const SizedBox(height: 30),
              MyListTile(
                  trailing: Icon(MyIcons.delete,
                      color: Theme.of(context).colorScheme.error),
                  title: 'Delete Account',
                  titleColor: Theme.of(context).colorScheme.error,
                  trailingArrow: false,
                  onPressed: () async {
                    var response = await openDialog(
                      context,
                      (context) => MyDialog(
                        title: 'Delete @${user.username}?',
                        body:
                            "Confirm that you want to delete your account. This action is irreversible",
                        actions: const ['Cancel', 'Delete'],
                        destructive: 'Delete',
                      ),
                      dismissible: true,
                    );
                    if (response == 'Delete') {
                      await user.delete(context);
                      // loginProvider!.logout(context);
                      // Navigator.pop(context);
                    }

                    //  log out
                  })
            ],
          ),
        ),
      ),
    );
  }
}
