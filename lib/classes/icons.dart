import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pulsar/classes/svg_icons.dart';

class MyIcons {
  MyIcons._();

  static IconData account = myIcon(Icons.person, Icons.person_outline);

  static IconData acting = myIcon(Icons.people, Icons.people);

  static IconData activity = myIcon(Icons.bar_chart, Icons.bar_chart);

  static IconData ad = myIcon(Icons.ad_units, Icons.ad_units);

  static IconData add = myIcon(Icons.add, Icons.add);

  static IconData addOutlined =
      myIcon(Icons.add_circle_outline, Icons.add_circle_outline);

  static IconData attatchment =
      myIcon(Icons.attachment, Icons.attachment_outlined);

  static IconData back = myIcon(Icons.arrow_back, Icons.arrow_back_ios);

  static IconData billing = myIcon(Icons.attach_money, Icons.attach_money);

  static IconData block = myIcon(Icons.block, Icons.block);

  static IconData cache = myIcon(Icons.cached, Icons.cached);

  static IconData camera = myIcon(Icons.camera, Icons.camera);

  static IconData check = myIcon(Icons.check, Icons.check);

  static IconData clearAll = myIcon(Icons.clear_all, Icons.clear_all);

  static IconData close = myIcon(Icons.close, Icons.close);

  static IconData comedy = myIcon(Icons.emoji_emotions, Icons.emoji_emotions);

  static IconData comment = myIcon(SvgIcons.comment, SvgIcons.comment);

  static IconData dance = myIcon(Icons.emoji_people, Icons.emoji_people);

  static IconData dataSaver = myIcon(Icons.data_usage, Icons.data_usage);

  static IconData delete = myIcon(Icons.delete, Icons.delete);

  static IconData email = myIcon(Icons.email, Icons.email_outlined);

  static IconData expand = myIcon(
      Icons.keyboard_arrow_down_rounded, Icons.keyboard_arrow_down_sharp);

  static IconData explore = myIcon(Icons.explore, Icons.explore_outlined);

  static IconData eye = myIcon(Icons.visibility, Icons.visibility_outlined);

  static IconData eyeOff =
      myIcon(Icons.visibility_off, Icons.visibility_off_outlined);

  static IconData facebook = myIcon(SvgIcons.facebook, SvgIcons.facebook);

  static IconData fashion =
      myIcon(Icons.face_retouching_natural, Icons.face_retouching_natural);

  static IconData favorite = myIcon(Icons.star, Icons.star);

  static IconData filterList = myIcon(Icons.filter_list, Icons.filter_list);

  static IconData filters =
      myIcon(Icons.filter_vintage, Icons.filter_vintage_outlined);

  static IconData flashlight =
      myIcon(Icons.flash_on_rounded, Icons.flash_on_rounded);

  static IconData forward =
      myIcon(Icons.arrow_forward, Icons.arrow_forward_ios);

  static IconData google = myIcon(SvgIcons.google, SvgIcons.google);

  static IconData help = myIcon(Icons.help_outline, Icons.help_outline);

  static IconData home = myIcon(Icons.home, Icons.home_outlined);

  static IconData info = myIcon(Icons.info_outline, Icons.info_outline);

  static IconData interactions = myIcon(Icons.favorite, Icons.favorite);

  static IconData keyboardUp =
      myIcon(Icons.keyboard_arrow_up, Icons.keyboard_arrow_up);

  static IconData language = myIcon(Icons.language, Icons.language);

  static IconData like = myIcon(Icons.favorite, Icons.favorite);

  static IconData likeOutline =
      myIcon(Icons.favorite_outline, Icons.favorite_outline);

  static IconData location =
      myIcon(Icons.location_on, Icons.location_on_outlined);

  static IconData logOut = myIcon(Icons.logout, Icons.logout);

  static IconData message = myIcon(SvgIcons.chat, SvgIcons.chat);

  static IconData mic = myIcon(Icons.mic, Icons.mic);

  static IconData more = myIcon(Icons.more_horiz, Icons.more_horiz);

  static IconData music = myIcon(SvgIcons.music, SvgIcons.music);

  static IconData mute =
      myIcon(Icons.notifications_off, Icons.notifications_off);

  static IconData networkError = myIcon(Icons.cloud_off, Icons.cloud_off);

  static IconData notifications =
      myIcon(SvgIcons.notifications, SvgIcons.notifications);

  static IconData palette = myIcon(Icons.palette, Icons.palette_outlined);

  static IconData phone = myIcon(Icons.phone, Icons.phone_outlined);

  static IconData pin = myIcon(SvgIcons.pin, SvgIcons.pin); //change

  static IconData play =
      myIcon(Icons.play_arrow_rounded, Icons.play_arrow_rounded);

  static IconData policies = myIcon(Icons.policy, Icons.policy);

  static IconData posts = myIcon(Icons.grid_view, Icons.grid_view);

  static IconData privacy = myIcon(Icons.shield, Icons.shield);

  static IconData reply = myIcon(Icons.reply, Icons.reply);

  static IconData report = myIcon(Icons.report, Icons.report);

  static IconData repost = myIcon(Icons.repeat, Icons.repeat);

  static IconData reposted = myIcon(Icons.repeat_one, Icons.repeat_one);

  static IconData search = myIcon(Icons.search, Icons.search);

  static IconData send = myIcon(Icons.send, Icons.send_outlined);

  static IconData share = myIcon(Icons.share, Icons.share_outlined);

  static IconData sort = myIcon(Icons.sort, Icons.sort);

  static IconData spam = myIcon(Icons.inbox, Icons.inbox_outlined);

  static IconData speed = myIcon(Icons.shutter_speed, Icons.shutter_speed);

  static IconData switchCamera = myIcon(Icons.autorenew, Icons.autorenew);

  static IconData terms = myIcon(Icons.book, Icons.book);

  static IconData theme =
      myIcon(Icons.star_half_rounded, Icons.star_half_rounded);

  static IconData trailingArrow =
      myIcon(Icons.arrow_forward_ios, Icons.arrow_forward_ios);

  static IconData tune = myIcon(Icons.tune, Icons.tune);

  static IconData twitter = myIcon(SvgIcons.twitter, SvgIcons.twitter);

  //
  // ios and android checkup
  //
  static IconData myIcon(IconData android, IconData ios) {
    if (Platform.isAndroid) {
      return android;
    } else {
      return ios;
    }
  }
}
