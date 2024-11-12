import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController taskController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference tasksRef = FirebaseFirestore.instance.collection('tasks');

  String getUserId() {
    final user = _auth.currentUser;
    return user != null ? user.uid : '';
  }

  Future<void> addTask(String taskName) async {
    await tasksRef.doc(getUserId()).collection('userTasks').add({
      'name': taskName,
      'completed': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTaskCompletion(String taskId, bool completed) async {
    await tasksRef.doc(getUserId()).collection('userTasks').doc(taskId).update({'completed': completed});
  }

  Future<void> deleteTask(String taskId) async {
    await tasksRef.doc(getUserId()).collection('userTasks').doc(taskId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Manager")),
      body: Column(
        children: [
          TextField(
            controller: taskController,
            decoration: InputDecoration(labelText: "New Task"),
          ),
          ElevatedButton(
            onPressed: () {
              if (taskController.text.isNotEmpty) {
                addTask(taskController.text);
                taskController.clear();
              }
            },
            child: Text("Add Task"),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: tasksRef.doc(getUserId()).collection('userTasks').orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final tasks = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final taskData = task.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(taskData['name']),
                      leading: Checkbox(
                        value: taskData['completed'],
                        onChanged: (value) => updateTaskCompletion(task.id, value!),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteTask(task.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}