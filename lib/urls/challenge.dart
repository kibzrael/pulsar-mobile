import 'package:pulsar/classes/challenge.dart';

class ChallengeUrls {
  ChallengeUrls._();

  static String createChallenge = 'challenge';

  static String challengeItem(Challenge challenge) =>
      'challenges/${challenge.id}';

  static String pins(Challenge challenge) => 'challenges/${challenge.id}/pins';

  static String posts(Challenge challenge, int index) =>
      'challenges/${challenge.id}/posts?index=$index';

  static String stats(Challenge challenge) =>
      'challenges/${challenge.id}/stats';
}
