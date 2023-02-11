import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:pulsar/classes/activity.dart';
import 'package:pulsar/providers/interactions_sync.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/user.dart';

class ActivityProvider extends ChangeNotifier {
  late UserProvider userProvider;
  late InteractionsSync interactionsSync;
  late CollectionReference colRef;

  List<InteractionActivity> realtimeUpdates = [];
  List<InteractionActivity> updates = [];

  int readCount = 0;
  int get unread {
    List<InteractionActivity> data = [...realtimeUpdates, ...updates];
    // Remove any duplicates
    Set ids = {};
    data.retainWhere((e) => ids.add(e.id));
    data.sort((a, b) => b.time.compareTo(a.time));
    int total = data.where((e) => !e.read).length - readCount;
    return total < 0 ? 0 : total;
  }

  ActivityProvider(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    interactionsSync = Provider.of<InteractionsSync>(context);
    String userId = userProvider.user.id.toString();
    colRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('activities');
    listenForUpdates();
  }

  Future<List<Map<String, dynamic>>> fetchUpdates(int index) async {
    List<Map<String, dynamic>> results = [];
    String url = getUrl(UserUrls.activity(index));
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Authorization': userProvider.token ?? '',
      });
      results = [...json.decode(response.body)['activity']];

      updates = [
        ...updates,
        ...results.map((e) => InteractionActivity.fromJson(e))
      ];
      // Remove any duplicates
      Set ids = {};
      updates.retainWhere((e) => ids.add(e.id));
      updates.sort((a, b) => b.time.compareTo(a.time));
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
    // Query query = colRef.limit(20);
    // if (index > 0) {
    //   query = colRef.where(FieldPath.documentId,
    //       whereNotIn: [...realtimeUpdates.map((e) => e.id)]);
    // }
    // QuerySnapshot snapshot = await query.get();
    // for (QueryDocumentSnapshot doc in snapshot.docs) {
    //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //   data.putIfAbsent('id', () => doc.id);
    //   data['time'] = data['time'].toDate().toIso8601String();
    //   results.add(data);
    // }
    return results;
  }

  listenForUpdates() async {
    Query query = colRef.where('read', isEqualTo: false).limit(20);
    query.snapshots().listen((snapshot) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data.putIfAbsent('id', () => doc.id);
        realtimeUpdates.add(InteractionActivity.fromJson(data));
      }
      // Remove any duplicates
      Set ids = {};
      realtimeUpdates.retainWhere((e) => ids.add(e.id));
      realtimeUpdates.sort((a, b) => b.time.compareTo(a.time));
      notifyListeners();
      debugPrint("Realtime Activity");
    });
  }

  markAsRead(List<InteractionActivity> activity) async {
    try {
      readCount += unread;
      notifyListeners();
      String url = getUrl(UserUrls.readActivity());
      await http.get(Uri.parse(url), headers: {
        'Authorization': userProvider.token ?? '',
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
