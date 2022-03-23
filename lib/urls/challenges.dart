class ChallengesUrl {
  ChallengesUrl._();

  static String myGalaxy = 'galaxy';

  static String pinned = 'pinned_challenge';

  static String top = 'challenges_chart';

  static String highlight = 'highlight_challenge';

  static String discover(String tag) => 'discover_challenges?tag=$tag';
}
