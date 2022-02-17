import 'package:json_annotation/json_annotation.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';

part 'challenge.g.dart';

@JsonSerializable(explicitToJson: true)
class Challenge {
  int id;
  String name;
  Interest? category;
  String description;
  Photo coverPhoto;
  DateTime? timeCreated;

  Challenge(this.id,
      {required this.name,
      required this.description,
      this.category,
      required this.coverPhoto,
      this.timeCreated});

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
  Map<String, dynamic> toJson() => _$ChallengeToJson(this);
}
