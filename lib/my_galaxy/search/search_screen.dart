import 'package:flutter/material.dart';
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
  TabController? tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(tabListener);
  }

  tabListener() {
    setState(() {
      tabIndex = tabController!.index;
    });
  }

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
              onChanged: (text) {},
              onSubmitted: (text) {},
              hintText:
                  tabIndex == 0 ? 'Search Users...' : 'Search Challenges...',
              autofocus: true,
            ),
          ),
          actions: [MyTextButton(text: 'Search', onPressed: () {})],
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
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: TabBarView(
            controller: tabController,
            children: const [
              UserResults(),
              ChallengeResults(),
            ],
          ),
        ),
      ),
    );
  }
}
