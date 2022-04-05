class ChallengesUrl {
  ChallengesUrl._();

  static String myGalaxy = 'galaxy';

  static String pinned(int index) => 'pinned_challenge?offset=$index';

  static String top = 'challenges_chart';

  static String highlight = 'highlight_challenge';

  static String discover(String tag, int index) =>
      'discover_challenges?tag=$tag&offset=$index';

  static String search(String keyword, int index) =>
      'challenges/search?keyword=$keyword&offset=$index';
}
