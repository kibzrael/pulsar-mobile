import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/secondary_pages.dart/select_category.dart';

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    provider = Provider.of<SignInfoProvider>(context);

    bool isSolo = provider.user.userType == UserType.solo;

    categories = [
      ...provider.interests.where((element) => element.parent == null)
    ];

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
          body: SelectCategory(
              categories: categories,
              selectedCategory: selectedCategory,
              isSolo: isSolo,
              onSelect: (category) {
                setState(() => selectedCategory = category);
              })),
    );
  }
}
