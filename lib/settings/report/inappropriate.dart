import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/widgets/list_tile.dart';

class ReportInappropriate extends StatefulWidget {
  final User? user;
  final Post? post;
  const ReportInappropriate({this.user, this.post, Key? key}) : super(key: key);

  @override
  State<ReportInappropriate> createState() => _ReportInappropriateState();
}

class _ReportInappropriateState extends State<ReportInappropriate> {
  late String issue;
  late User? user;
  late Post? post;

  String description = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      issue = local(context).none;
    });
    user = widget.user;
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          child: Container(
        height: constraints.maxHeight,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                local(context).inappropriateTitle,
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),
            MyListTile(
              title: local(context).issue,
              trailingText: issue,
              flexRatio: const [0, 1],
            ),
            MyListTile(
              title: local(context).users(1),
              trailingText: user?.username ?? local(context).none,
              flexRatio: const [0, 1],
            ),
            MyListTile(
              title: local(context).posts(1),
              trailingText: post?.caption ?? local(context).none,
              flexRatio: const [0, 1],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                maxLength: 255,
                minLines: 1,
                maxLines: 4,
                onChanged: (text) => setState(() => description = text),
                decoration: InputDecoration(
                    hintText: local(context).description,
                    counter: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${description.length}/255',
                        style:
                            Theme.of(context).inputDecorationTheme.counterStyle,
                      ),
                    ),
                    helperMaxLines: 3,
                    helperText: local(context).inappropriateDescription),
              ),
            ),
            const SizedBox(height: 15),
            MyListTile(
                leading: Icon(MyIcons.attatchment),
                title: local(context).attachment)
          ],
        ),
      ));
    });
  }
}
