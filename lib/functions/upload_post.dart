import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart' as parser;
import 'package:image/image.dart' as img;
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/response.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/providers/background_operations.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/post.dart';

class UploadPost {
  User user;
  Challenge? challenge;
  bool allowComments;
  File video;
  Uint8List thumbnail;
  String? caption;
  String? location;
  List<Interest> tags;
  String filter;
  List<String> linkedAccounts;

  double progress = 0.0;

  bool error = false;

  String token;

  CancelToken cancelToken = CancelToken();

  UploadPost({
    required this.user,
    required this.video,
    required this.thumbnail,
    required this.token,
    this.challenge,
    this.caption,
    this.allowComments = true,
    this.filter = "Original",
    this.tags = const [],
    this.location,
    this.linkedAccounts = const [],
  });

  upload(BuildContext context) async {
    BackgroundOperations bgOperations =
        Provider.of<BackgroundOperations>(context, listen: false);

    String uploadUrl = getUrl(PostUrls.upload);

    String identifier = '${DateTime.now()}'.replaceAll('.', '');
    Directory dir = await getTemporaryDirectory();
    File thumbnailFile =
        await File(join(dir.path, '$identifier.jpg')).writeAsBytes(thumbnail);
    img.Image? image = img.decodeImage(thumbnail);
    if (image != null) {
      img.Image resized = img.copyResize(image, width: 480);
      thumbnailFile = await File(join(dir.path, '$identifier.jpg'))
          .writeAsBytes(img.encodeJpg(resized));
    }

    FormData form = FormData.fromMap({
      'caption': caption,
      'challenge': challenge?.id,
      'allowComments': allowComments.toString(),
      'tags': tags.map((e) => e.name).join(','),
      'filter': filter,
      'source': await MultipartFile.fromFile(video.path,
          filename: 'video.mp4', contentType: parser.MediaType('video', 'mp4')),
      'thumbnail': await MultipartFile.fromFile(thumbnailFile.path,
          filename: 'thumbnail.jpg',
          contentType: parser.MediaType('image', 'jpeg')),
    });

    MyResponse response = MyResponse();

    try {
      Dio dio = Dio();

      Response requestResponse = await dio.post(
        uploadUrl,
        options: Options(headers: {
          'Authorization': token,
          "Content-type": "multipart/form-data",
          'Connection': 'keep-alive',
        }),
        data: form,
        cancelToken: cancelToken,
        onSendProgress: (int sent, int total) {
          progress = sent / total;
          bgOperations.notify();
          debugPrint("sent${sent.toString()} total${total.toString()}");
        },
      );

      response.statusCode = requestResponse.statusCode;
      if (requestResponse.data is Map) {
        response.body = requestResponse.data;

        bgOperations.uploadPost = null;
        bgOperations.notify();
      } else {
        error = true;
        response.body = {
          'message':
              'There has been a problem processing your request. Please try again later.'
        };
      }
    } catch (e) {
      response.statusCode = 503;
      response.body = {
        'message':
            'There has been a problem processing your request. Please try again later.'
      };
      error = true;

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(e.toString()),
      //   duration: const Duration(seconds: 10),
      // ));
      debugPrint(e.toString());

      Fluttertoast.showToast(msg: e.toString());
    }
  }

  cancel(BuildContext context) {
    BackgroundOperations bgOperations =
        Provider.of<BackgroundOperations>(context, listen: false);
    cancelToken.cancel();
    bgOperations.uploadPost = null;
    bgOperations.notify();
  }
}
