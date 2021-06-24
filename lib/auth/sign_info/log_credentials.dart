import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/text_input.dart';

class LogCredentials extends StatefulWidget {
  @override
  _LogCredentialsState createState() => _LogCredentialsState();
}

class _LogCredentialsState extends State<LogCredentials> {
  late SignInfoProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SignInfoProvider>(context);

    double size = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(
        appBar: AppBar(
          title: Text('Credentials'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).buttonColor,
          onPressed: () {
            provider.nextPage();
          },
          child: Icon(MyIcons.forward, size: 30),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: size,
            padding: EdgeInsets.all(30),
            child: Column(children: [
              Text(
                'Please select a suitable username and password',
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              Spacer(flex: 1),
              MyTextInput(
                hintText: 'Username',
                onChanged: (text) {},
                onSubmitted: (text) {},
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 5, 0, 12),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sorry the username is in use',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              SizedBox(height: 15),
              MyTextInput(
                hintText: 'Password',
                onChanged: (text) {},
                onSubmitted: (text) {},
              ),
              Spacer(
                flex: 2,
              )
            ]),
          ),
        ));
  }
}
