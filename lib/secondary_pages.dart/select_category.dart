import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/auth/sign_info/seach_category.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/search_input.dart';

class SelectCategory extends StatefulWidget {
  final List<Interest> categories;
  final Interest? selectedCategory;
  final bool isSolo;
  final Function(Interest selected) onSelect;
  const SelectCategory(
      {Key? key,
      required this.categories,
      required this.selectedCategory,
      this.isSolo = true,
      required this.onSelect})
      : super(key: key);

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool get isSolo => widget.isSolo;

  List<Interest> categories = [];

  search() {
    Navigator.of(context)
        .push(myPageRoute(builder: (context) => const SearchCategory()));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    categories = [...widget.categories];

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          height: constraints.maxHeight,
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
                  child: SearchInput(
                    onPressed: search,
                    text: 'Search Categores',
                    height: 50,
                  )),
              const SizedBox(
                height: 30,
              ),
              Flexible(
                child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 21,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.75),
                    itemBuilder: (context, index) {
                      Interest category = categories[index];

                      bool selected =
                          category.user == widget.selectedCategory?.user;

                      return LayoutBuilder(builder: (context, snapshot) {
                        return InkWell(
                          onTap: () {
                            widget.onSelect(category);
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
                                              category.coverPhoto!.thumbnail),
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
                                      ? category.user
                                      : category.users ?? category.user,
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
      );
    });
  }
}
