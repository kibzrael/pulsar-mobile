import 'package:flutter/material.dart';

class User {
  int id;
  String username;
  String? fullname;
  String profilePic;
  String? bio;
  String category;
  String? portfolio;
  // Location location;
  // List<Interest> interests;
  // List<LinkedAccount> linkedAccounts;
  String? email;
  String? phone;
  DateTime? dateOfBirth;
  // UserPrivacy privacy;
  int? pins;
  int? pinned;
  int? posts;
  // Link profileUrl;
  DateTime? dateJoined;
  //
  bool? isPinned;
  bool? isBlocked;
  bool? isMuted;
  bool? isFavorite;

  /// Create a user from info.
  ///
  /// id and username are required
  User(
    this.id, {
    required this.username,
    this.bio,
    required this.category,
    this.dateJoined,
    this.dateOfBirth,
    this.email,
    this.fullname,
    //this.interests,
    this.isBlocked,
    this.isFavorite,
    this.isMuted,
    this.isPinned,
    //this.linkedAccounts,
    //this.location,
    this.phone,
    this.pinned,
    this.pins,
    this.portfolio,
    this.posts,
    //this.privacy,
    required this.profilePic,
    //this.profileUrl,
  });

  // Create a user from a json/ map
  //
  // map should contain id and username fields

  User.fromJson(Map<String, dynamic> info)
      : assert(info['id'] != null),
        assert(info['id'] is int),
        assert(info['username'] != null),
        assert(info['username'] is String),
        id = info['id'] is int ? info['id'] : int.tryParse(info['id']),
        username = info['username'],
        bio = info['bio'],
        category = info['category'],
        dateJoined = DateTime.tryParse(info['dateJoined'] ?? ''),
        dateOfBirth = DateTime.tryParse(info['dateOfBirth'] ?? ''),
        email = info['email'],
        fullname = info['fullname'],
        isBlocked = info['isBlocked'],
        isFavorite = info['isFavorite'],
        isMuted = info['isMuted'],
        isPinned = info['isPinned'],
        phone = info['phone'],
        pinned = info['pinned'],
        pins = info['pins'],
        portfolio = info['portfolio'],
        posts = info['posts'],
        profilePic = info['profilePic'];

  toJson(BuildContext context) {}

  pin(BuildContext context, {RequestMethod mode = RequestMethod.post}) {}

  block(BuildContext context, {RequestMethod mode = RequestMethod.post}) {}

  mute(BuildContext context, {RequestMethod mode = RequestMethod.post}) {}

  // report(BuildContext context, Report report) {}

  subcribeForPostNotifications(BuildContext context) {}

  addToFavorite(BuildContext context) {}

  shareToUser() {}

  getPosts() {}

  getReposts() {}

  getPostSaves(BuildContext context) {}

  getLikes(BuildContext context) {}

  getBlocks(BuildContext context) {}

  getInterests(BuildContext context) {}

  getPins() {}

  getPinned() {}

  // message(Message message) {}

  String? get getProfileUrl {
    // return profileUrl?.url;
  }

  bool get profileIsComplete {
    List info = [
      id,
      username,
      fullname,
      category,
      portfolio,
      profilePic,
      bio,
      posts,
      pins,
      pinned,
      isPinned
    ];
    return !info.any((element) => element == null);
  }

  getProfile() {}

  /// Use to edit the class
  User update(BuildContext context, User newUser) {
    // ensure userprovider.id == id

    // username = newUser.username ?? username;
    // bio = newUser.bio ?? bio;
    // category = newUser.category ?? category;
    // dateOfBirth = newUser.dateOfBirth ?? dateOfBirth;
    // email = newUser.email ?? email;
    // fullname = newUser.fullname ?? fullname;
    // interests = newUser.interests ?? interests;
    // linkedAccounts = newUser.linkedAccounts ?? linkedAccounts;
    // location = newUser.location ?? location;
    // phone = newUser.phone ?? phone;
    // portfolio = newUser.portfolio ?? portfolio;
    // profilePic = newUser.profilePic ?? profilePic;
    return this;
  }

  /// Use to edit profile in the server.
  /// Use update to change details.
  ///
  /// Note: editProfile uses the current class values.
  Future<User> editProfile(BuildContext context) async {
    await Future.delayed(Duration(seconds: 4));
    return this;
  }

  delete(BuildContext context) {}
}

enum RequestMethod { post, delete }
