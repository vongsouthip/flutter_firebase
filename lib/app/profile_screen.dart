import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc =
        await _firestore.collection("users").doc(user.uid).get();

    if (userDoc.exists) {
      print("User Data: ${userDoc.data()}");
      setState(() {
        nameController.text = userDoc["name"];
        surnameController.text = userDoc["surname"];
        dobController.text = userDoc["dob"];
        imageUrlController.text = userDoc["profileImage"] ?? "";
      });
      print("DOB Loaded: ${dobController.text}");
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        dobController.text = formattedDate;
      });
    } else {
      print("Date is not selected");
    }
  }

  Future<void> _updateProfile() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      await _firestore.collection("users").doc(user.uid).update({
        "name": nameController.text.trim(),
        "surname": surnameController.text.trim(),
        "dob": dobController.text.trim(),
        "profileImage": imageUrlController.text.trim(),
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("update success")));
      // Navigator.pop(context);
    } catch (e) {
      print("Update Failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error occurred: $e")));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          imageUrlController.text.isNotEmpty
                              ? NetworkImage(imageUrlController.text)
                              : AssetImage("assets/default_avatar.png")
                                  as ImageProvider,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Name"),
                    ),
                    TextField(
                      controller: surnameController,
                      decoration: InputDecoration(labelText: "Surname"),
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: dobController,
                      decoration: InputDecoration(
                        labelText: "Date of Birth",
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                      ),
                      readOnly: true,
                      onTap: () => selectDate(context),
                    ),
                    TextField(
                      controller: imageUrlController,
                      decoration: InputDecoration(
                        labelText: "Profile Image URL",
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      child: Text("Save Data"),
                    ),
                  ],
                ),
              ),
    );
  }
}
