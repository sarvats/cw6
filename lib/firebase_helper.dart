import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static final CollectionReference tasksRef = FirebaseFirestore.instance.collection('tasks');

  static Future<void> addTask(String taskName) async {
    await tasksRef.add({'name': taskName, 'completed': false});
  }

  static Stream<QuerySnapshot> tasksStream() {
    return tasksRef.snapshots();
  }

  static Future<void> updateTaskCompletion(String id, bool completed) async {
    await tasksRef.doc(id).update({'completed': completed});
  }

  static Future<void> deleteTask(String id) async {
    await tasksRef.doc(id).delete();
  }
}
