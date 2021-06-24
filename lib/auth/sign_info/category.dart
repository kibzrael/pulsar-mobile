import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/data/categories.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/text_input.dart';

class ChooseCategory extends StatefulWidget {
  @override
  _ChooseCategoryState createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  late SignInfoProvider provider;

  List<Interest> categories = [
    music,
    art,
    photography,
    comedy,
    dance,
    gymnastics,
    modelling,
    acting,
    interiorDesign,
    makeup,
    magic,
    puppetry
  ];

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SignInfoProvider>(context);

    double size = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              MyIcons.back,
            ),
            onPressed: () {
              provider.previousPage();
            }),
        title: Text('Category'),
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
          padding: EdgeInsets.all(15),
          height: size,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                alignment: Alignment.center,
                child: Text(
                  'Who do you consider yourself to be? Select a title that best suites you.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: MyTextInput(
                  hintText: 'Category',
                  prefix: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(MyIcons.search),
                  ),
                  onChanged: (text) {},
                  onSubmitted: (text) {},
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Flexible(
                child: ListView.builder(
                    itemCount: categories.length,
                    padding: EdgeInsets.only(bottom: kToolbarHeight),
                    itemBuilder: (context, index) {
                      return MyListTile(
                        title: categories[index].category,
                        leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(context).dividerColor,
                            backgroundImage:
                                AssetImage('${categories[index].coverPhoto}')),
                        subtitle: '2K users',
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
