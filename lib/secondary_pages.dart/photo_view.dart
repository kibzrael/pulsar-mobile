import 'package:flutter/material.dart';
import 'package:pulsar/providers/theme_provider.dart';

class PhotoView extends StatelessWidget {
  final String tag;
  final String photo;
  PhotoView(this.photo, {this.tag = ''});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkTheme,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Hero(
            tag: tag,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  image: DecorationImage(
                    image: AssetImage(photo),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
