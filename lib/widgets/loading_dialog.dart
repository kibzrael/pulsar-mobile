import 'package:flutter/cupertino.dart';
import 'package:pulsar/widgets/progress_indicator.dart';

class LoadingDialog extends StatefulWidget {
  final Future Function() process;
  final String text;
  const LoadingDialog(this.process, {Key? key, this.text = 'Processing'})
      : super(key: key);

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
    var response = await widget.process();
    Navigator.pop(context, response);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: CupertinoAlertDialog(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MyProgressIndicator(
                margin: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${widget.text}...',
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
