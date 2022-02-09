import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/seach_category.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/search_input.dart';

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({Key? key}) : super(key: key);

  @override
  _ChooseCategoryState createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late SignInfoProvider provider;

  List<Interest> categories = [];

  Interest? selectedCategory;

  search() {
    Navigator.of(context)
        .push(myPageRoute(builder: (context) => const SearchCategory()));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    provider = Provider.of<SignInfoProvider>(context);

    bool isSolo = provider.user.userType == UserType.solo;

    categories = [
      ...provider.interests.where((element) => element.parent == null)
    ];

    double size = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: signInfoAppBar(
            title: 'Category',
            onBack: provider.previousPage,
            onForward: () {
              provider.user.category = selectedCategory;
              provider.nextPage();
            }),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            height: size,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  alignment: Alignment.center,
                  child: Text(
                    'Who do you consider yoursel${isSolo ? 'f' : 'ves'} to be?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 24),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Hero(
                      tag: 'searchCategory',
                      child: SearchInput(
                        onPressed: search,
                        text: (isSolo
                                ? selectedCategory?.category
                                : selectedCategory?.pCategory ??
                                    selectedCategory?.category) ??
                            'Category',
                        height: 50,
                      ),
                    )),
                const SizedBox(
                  height: 30,
                ),
                Flexible(
                  child: GridView.builder(
                      itemCount: categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 21,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.75),
                      itemBuilder: (context, index) {
                        Interest category = categories[index];
                        bool selected = category == selectedCategory;
                        return LayoutBuilder(builder: (context, snapshot) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: snapshot.maxWidth,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .inputDecorationTheme
                                            .fillColor,
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                category.coverPhoto!),
                                            fit: BoxFit.cover),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    if (selected)
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor),
                                          child: Container(
                                            width: 27,
                                            height: 27,
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: secondaryGradient(
                                                  begin: Alignment.topLeft),
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Icon(
                                                MyIcons.check,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                const Spacer(),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    isSolo
                                        ? category.category
                                        : category.pCategory ??
                                            category.category,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: const TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          );
                        });
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
