class Video {
  String source;
  String thumbnail;

  Video(this.source, {required this.thumbnail});

  Video.fromJson(Map info)
      : assert(info['source'] != null),
        this.source = info['source'],
        this.thumbnail = info['thumbnail'];

  toJson() {
    return {'source': this.source, 'thumbnail': this.thumbnail};
  }
}
