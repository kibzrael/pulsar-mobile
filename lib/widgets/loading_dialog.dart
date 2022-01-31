import 'package:flutter/cupertino.dart';
import 'package:pulsar/widgets/progress_indicator.dart';

class LoadingDialog extends StatefulWidget {
  final Future<Null> Function() process;
  final String text;
  LoadingDialog(this.process, {this.text = 'Processing'});

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  void initState() {
    super.initState();
    process();
  }

  process() async {
    await widget.process();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36),
      child: CupertinoAlertDialog(
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyProgressIndicator(
                margin: EdgeInsets.zero,
              ),
              SizedBox(height: 24),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${widget.text}...',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
