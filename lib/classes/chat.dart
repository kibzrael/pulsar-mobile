import 'package:pulsar/classes/user.dart';

class Chat {
  List<User> members;

  bool isSpam;

  bool get isGroup => members.length > 2;
  String? name;
  String? category;
  DateTime? dateFormed;
  String? description;

  User? receipient(User user) {
    if (isGroup) {
      return null;
    } else {
      return members.firstWhere((element) => element.id != user.id);
    }
  }

  Chat(this.members,
      {this.isSpam = false,
      this.category,
      this.name,
      this.dateFormed,
      this.description});
}
