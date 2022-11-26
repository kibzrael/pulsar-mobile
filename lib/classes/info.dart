class Info {
  List<InfoSection> sections;

  Info(this.sections);
}

class InfoSection {
  String title;
  String description;

  InfoSection({required this.title, required this.description});
}
