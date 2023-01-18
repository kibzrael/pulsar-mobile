import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/activity.dart';
import 'package:pulsar/providers/user_provider.dart';

class ActivityProvider extends ChangeNotifier {
  late UserProvider userProvider;
  late CollectionReference colRef;

  List<InteractionActivity> realtimeUpdates = [];

  ActivityProvider(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    String userId = userProvider.user.id.toString();
    colRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('activities');
    listenForUpdates();
  }

  Future<List<Map<String, dynamic>>> fetchUpdates(int index) async {
    List<Map<String, dynamic>> results = [];
    Query query = colRef.limit(20);
    if (index > 0) {
      query = colRef.where(FieldPath.documentId,
          whereNotIn: [...realtimeUpdates.map((e) => e.id)]);
    }
    QuerySnapshot snapshot = await query.get();
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data.putIfAbsent('id', () => doc.id);
      data['time'] = data['time'].toDate().toIso8601String();
      results.add(data);
    }
    return results;
  }

  listenForUpdates() {}
}
