import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/my_galaxy/search/search_suggestions.dart';
import 'package:pulsar/providers/settings_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/challenges.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/user.dart';
import 'package:pulsar/widgets/custom_tab.dart';
import 'package:pulsar/widgets/search_field.dart';
import 'package:pulsar/widgets/text_button.dart';
import 'package:pulsar/my_galaxy/search/challenge_results.dart';
import 'package:pulsar/my_galaxy/search/user_results.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late SettingsProvider settingsProvider;
  List<String> suggestions = [];

  late UserProvider userProvider;

  late PageController pageController;
  late TabController tabController;
  int tabIndex = 0;

  late FocusNode focusNode;
  late TextEditingController controller;

  bool get isEditing =>
      pageController.hasClients ? pageController.page == 0 : true;

  String keyword = '';

  @override
  void initState() {
    super.initState();
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    suggestions = [...settingsProvider.settings.searchHistory];
    pageController = PageController();
    focusNode = FocusNode();
    controller = TextEditingController();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(tabListener);
    fetchSuggestions();
  }

  tabListener() {
    setState(() {
      tabIndex = tabController.index;
    });
  }

  fetchSuggestions() async {
    suggestions = [
      ...settingsProvider.settings.searchHistory
          .where((e) => e.contains(keyword))
    ];
    debugPrint("Suggestions: $suggestions");
    // Fetch from server
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> search(int page, int index) async {
    if (!settingsProvider.settings.searchHistory.contains(keyword)) {
      settingsProvider.settings.searchHistory = [
        keyword,
        ...settingsProvider.settings.searchHistory
      ];
    }
    settingsProvider.save(notify: false);
    List<Map<String, dynamic>> results = [];
    String url;
    if (page == 0) {
      url = getUrl(UserUrls.search(keyword.trim(), index));
    } else {
      url = getUrl(ChallengesUrl.search(keyword.trim(), index));
    }

    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': userProvider.user.token ?? ''});

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      results = [...List<Map<String, dynamic>>.from(body['results'])];
    } else {
      Fluttertoast.showToast(msg: body['message']);
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    userProvider = Provider.of<UserProvider>(context);
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
                  pageController.jumpToPage(0);
                  fetchSuggestions();
                },
                onChanged: (text) {
                  keyword = text;
                  pageController.jumpToPage(0);
                  fetchSuggestions();
                },
                controller: controller,
                onSubmitted: (text) {
                  pageController.jumpToPage(1);
                  setState(() {});
                },
                hintText:
                    tabIndex == 0 ? 'Search Users...' : 'Search Challenges...',
                autofocus: isEditing,
                focusNode: focusNode,
                initial: keyword,
              ),
            ),
            actions: [
              MyTextButton(
                  text: 'Search',
                  onPressed: () {
                    focusNode.unfocus();
                    pageController.jumpToPage(1);
                    setState(() {});
                  })
            ],
            bottom: isEditing
                ? null
                : TabBar(
                    indicator: const BoxDecoration(),
                    unselectedLabelColor:
                        Theme.of(context).unselectedWidgetColor,
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
              SearchSuggestions(suggestions, onSearch: (text) {
                keyword = text;
                controller.text = text;
                focusNode.unfocus();
                pageController.jumpToPage(1);
                setState(() {});
              }, onSelect: (text) {
                keyword = text;
                controller.text = text;
                controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length));
                fetchSuggestions();
                setState(() {});
              }),
              Container(
                color: Theme.of(context).colorScheme.surface,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    UserResults(
                      target: search,
                    ),
                    ChallengeResults(
                      target: search,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
