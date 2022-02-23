import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/my_galaxy/search/serach_suggestions.dart';
import 'package:pulsar/providers/settings_provider.dart';
import 'package:pulsar/widgets/custom_tab.dart';
import 'package:pulsar/widgets/search_field.dart';
import 'package:pulsar/widgets/text_button.dart';
import 'package:pulsar/my_galaxy/search/challenge_results.dart';
import 'package:pulsar/my_galaxy/search/user_results.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late SettingsProvider settingsProvider;
  List<String> suggestions = [];

  late PageController pageController;
  late TabController tabController;
  int tabIndex = 0;

  bool isEditing = true;

  @override
  void initState() {
    super.initState();
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    suggestions = [...settingsProvider.settings.searchHistory];
    pageController = PageController();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(tabListener);
  }

  tabListener() {
    setState(() {
      tabIndex = tabController.index;
    });
  }

  fetchSuggestion() async {}

  search() async {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            title: Hero(
              tag: 'searchPulsar',
              child: SearchField(
                onTap: () {
                  setState(() => isEditing = true);
                  pageController.jumpToPage(0);
                },
                onChanged: (text) {
                  setState(() => isEditing = true);
                  pageController.jumpToPage(0);
                  fetchSuggestion();
                },
                onSubmitted: (text) {
                  setState(() => isEditing = false);
                  pageController.jumpToPage(1);
                  search();
                },
                hintText:
                    tabIndex == 0 ? 'Search Users...' : 'Search Challenges...',
                autofocus: true,
              ),
            ),
            actions: [
              MyTextButton(
                  text: 'Search',
                  onPressed: () {
                    setState(() => isEditing = false);
                    pageController.jumpToPage(1);
                    search();
                  })
            ],
            bottom: TabBar(
                indicator: const BoxDecoration(),
                unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
                labelPadding: EdgeInsets.zero,
                controller: tabController,
                tabs: const [
                  CustomTab('Users'),
                  CustomTab(
                    'Challenges',
                    divider: false,
                  )
                ]),
          ),
          body: PageView(
            controller: pageController,
            children: [
              SearchSuggestions(suggestions),
              Container(
                color: Theme.of(context).colorScheme.surface,
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    UserResults(),
                    ChallengeResults(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
