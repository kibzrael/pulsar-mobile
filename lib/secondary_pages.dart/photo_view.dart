import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotoView extends StatelessWidget {
  final String tag;
  final String photo;
  PhotoView(this.photo, {this.tag = ''});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          // backgroundColor: Colors.white.withOpacity(0.0),
          ),
      body: Center(
        child: Hero(
          tag: tag,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(photo),
                  fit: BoxFit.cover,
                )),
          ),
        ),
      ),
    );
  }
}
