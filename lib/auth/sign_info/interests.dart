import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/secondary_pages.dart/select_interests.dart';
import 'package:pulsar/widgets/loading_dialog.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({Key? key}) : super(key: key);

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late SignInfoProvider provider;

  List<Interest> interests = [];

  List<Interest> selected = [];

  void login() async {
    provider.user.interests = selected;

    await openDialog(
      context,
      (context) => LoadingDialog((_) async {
        await provider.submit(context);
        return;
      }),
    ).then((_) {
      Navigator.of(context, rootNavigator: true)
          .pushNamedAndRemoveUntil('/', (route) => false);
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    provider = Provider.of<SignInfoProvider>(context);

    interests = [...provider.interests];

    return Scaffold(
        appBar: signInfoAppBar(context,
            title: local(context).interests,
            onBack: provider.previousPage,
            onForward: login),
        body: SelectInterests(
            initialInterests: const [],
            interests: interests,
            onSelect: (selectedInterests) {
              setState(() => selected = selectedInterests);
            }));
  }
}
