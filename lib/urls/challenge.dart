import 'package:pulsar/classes/challenge.dart';

class ChallengeUrls {
  ChallengeUrls._();

  static String challengeItem(Challenge challenge) =>
      'challenges/${challenge.id}';

  static String pins(Challenge challenge) => 'challenges/${challenge.id}/pins';

  static String posts(Challenge challenge) =>
      'challenges/${challenge.id}/posts';

  static String stats(Challenge challenge) =>
      'challenges/${challenge.id}/stats';
}
