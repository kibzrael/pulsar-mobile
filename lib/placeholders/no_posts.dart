import 'package:flutter/material.dart';
import 'package:pulsar/providers/theme_provider.dart';

class NoPosts extends StatelessWidget {
  const NoPosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                secondaryGradient(begin: Alignment.topLeft)
                    .createShader(bounds),
            child: const Icon(
              Icons.video_library,
              size: 75,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Text('No videos yet',
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontSize: 24)),
        ],
      ),
    );
  }
}
