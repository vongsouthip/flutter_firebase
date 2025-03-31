import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/app/login_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // collection users create collection in firestore
  final users = FirebaseFirestore.instance.collection('users');

  // อ่านข้อมูล
  Stream<QuerySnapshot> getUsers() {
    return users.snapshots();
  }

  // ลบข้อมูล
  Future<void> deleteUser(String docId) {
    return users.doc(docId).delete();
  }

  Future<void> _signOut(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(child: Text("${data['age']}")),
                title: Text(data['name']),
                subtitle: Text("${data['email']}"),
                trailing: IconButton(
                  onPressed: () => deleteUser(docs[index].id),
                  icon: Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
