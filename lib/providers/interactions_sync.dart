import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/user.dart';

class InteractionsSync extends ChangeNotifier {
  List<User> followedUsers = [];
  List<User> unfollowedUsers = [];

  List<Challenge> pinnedChallenges = [];
  List<Challenge> unpinnedChallenges = [];

  bool isFollowing(User user) {
    return (user.isFollowing ||
            followedUsers.indexWhere((element) => element.id == user.id) >=
                0) &&
        unfollowedUsers.indexWhere((element) => element.id == user.id) < 0;
  }

  bool isPinned(Challenge challenge) {
    return (challenge.isPinned ||
            pinnedChallenges
                    .indexWhere((element) => element.id == challenge.id) >=
                0) &&
        unpinnedChallenges.indexWhere((element) => element.id == challenge.id) <
            0;
  }

  follow(User user) {
    followedUsers.add(user);
    unfollowedUsers.removeWhere((element) => element.id == user.id);
    notifyListeners();
  }

  unfollow(User user) {
    unfollowedUsers.add(user);
    followedUsers.removeWhere((element) => element.id == user.id);
    notifyListeners();
  }

  pin(Challenge challenge) {
    pinnedChallenges.add(challenge);
    unpinnedChallenges.removeWhere((element) => element.id == challenge.id);
    notifyListeners();
  }

  unpin(Challenge challenge) {
    unpinnedChallenges.add(challenge);
    pinnedChallenges.removeWhere((element) => element.id == challenge.id);
    notifyListeners();
  }
}
