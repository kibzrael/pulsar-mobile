class Interest {
  String name;
  String? pCategory;
  String category;
  String? coverPhoto;

  Interest? parent;

  Interest({
    required this.name,
    required this.category,
    this.pCategory,
    this.coverPhoto,
    this.parent,
  });
}
