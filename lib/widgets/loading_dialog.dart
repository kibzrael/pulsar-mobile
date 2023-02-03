import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/widgets/progress_indicator.dart';

class LoadingDialog extends StatefulWidget {
  final Future Function(BuildContext context) process;
  final String text;
  final bool pop;
  const LoadingDialog(this.process,
      {Key? key, this.text = 'Processing', this.pop = true})
      : super(key: key);

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  void initState() {
    super.initState();
    process();
  }

  process() async {
    await widget.process(context).then((response) {
      if (widget.pop) Navigator.pop(context, response);
    });
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
              MyProgressIndicator(
                margin: EdgeInsets.zero,
                color: Colors.grey[350],
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
