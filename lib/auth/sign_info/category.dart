import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/secondary_pages.dart/select_category.dart';

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({Key? key}) : super(key: key);

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late SignInfoProvider provider;

  Interest? selectedCategory;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    provider = Provider.of<SignInfoProvider>(context);

    bool isSolo = provider.user.userType == UserType.solo;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: signInfoAppBar(context,
              title: local(context).category,
              onBack: provider.previousPage, onForward: () {
            if (selectedCategory != null) {
              provider.user.category = selectedCategory!;
            }
            provider.nextPage();
          }),
          body: SelectCategory(
              categories: provider.interests,
              selectedCategory: selectedCategory,
              isSolo: isSolo,
              onSelect: (category) {
                setState(() => selectedCategory = category);
              })),
    );
  }
}
