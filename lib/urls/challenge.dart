import 'package:pulsar/classes/challenge.dart';

class ChallengeUrls {
  ChallengeUrls._();

  static String createChallenge = 'challenges/';

  static String challengeItem(Challenge challenge) =>
      'challenges/${challenge.id}/';

  static String pins(Challenge challenge, {int? index}) =>
      'challenges/${challenge.id}/pins${index == null ? '' : '?offset=$index'}';

  static String posts(Challenge challenge, int index, int offset) =>
      'challenges/${challenge.id}/posts?index=$index';

  static String stats(Challenge challenge) =>
      'challenges/${challenge.id}/stats';
}
