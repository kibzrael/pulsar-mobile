import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/classes/user.dart';

class InteractionsSync extends ChangeNotifier {
  List<User> followedUsers = [];
  List<User> unfollowedUsers = [];

  List<Post> likedPosts = [];
  List<Post> unlikedPosts = [];

  List<Post> repostedPosts = [];
  List<Post> unrepostedPosts = [];

  List<Challenge> pinnedChallenges = [];
  List<Challenge> unpinnedChallenges = [];

  bool isFollowing(User user) {
    return (user.isFollowing ||
            followedUsers.indexWhere((element) => element.id == user.id) >=
                0) &&
        unfollowedUsers.indexWhere((element) => element.id == user.id) < 0;
  }

  bool isLiked(Post post) {
    return (post.isLiked ||
            likedPosts.indexWhere((element) => element.id == post.id) >= 0) &&
        unlikedPosts.indexWhere((element) => element.id == post.id) < 0;
  }

  bool isReposted(Post post) {
    return (post.isReposted ||
            repostedPosts.indexWhere((element) => element.id == post.id) >=
                0) &&
        unrepostedPosts.indexWhere((element) => element.id == post.id) < 0;
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

  like(Post post) {
    likedPosts.add(post);
    unlikedPosts.removeWhere((element) => element.id == post.id);
    notifyListeners();
  }

  unlike(Post post) {
    unlikedPosts.add(post);
    likedPosts.removeWhere((element) => element.id == post.id);
    notifyListeners();
  }

  repost(Post post) {
    repostedPosts.add(post);
    unrepostedPosts.removeWhere((element) => element.id == post.id);
    notifyListeners();
  }

  unrepost(Post post) {
    unrepostedPosts.add(post);
    repostedPosts.removeWhere((element) => element.id == post.id);
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
