import 'package:pulsar/classes/user.dart';

class Chat {
  List<User> members;

  bool isSpam;

  bool get isGroup => members.length > 2;

  DateTime? dateFormed;

  User? receipient(User user) {
    if (isGroup) {
      return members.first;
    } else {
      return members.firstWhere((element) => element.id != user.id);
    }
  }

  Chat(this.members, {this.isSpam = false, this.dateFormed});
}
