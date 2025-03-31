import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/app/login_screen.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  bool isLoading = false;
  DateTime? selectedDate;
  

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text.trim() !=
          confirmPasswordController.text.trim()) {
        showError("password not match");
        return;
      }
      setState(() {
        isLoading = true;
      });
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

        String uid = userCredential.user!.uid;

        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          "name": _nameController.text.trim(),
          "dob": dobController.text.trim() ,
          "email": emailController.text.trim(),
          "created_at": FieldValue.serverTimestamp(),
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      } on FirebaseAuthException catch (e) {
        showError(e.message);
      } catch (e) {
        showError('เกิดข้อผิดพลาดบางอย่าง');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void showError(String? message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message ?? "Error")));
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(pickedDate); // อัปเดตช่องป้อนข้อมูล
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 45.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter Name",
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: Icon(Icons.person, color: Colors.white),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกชื่อ";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: dobController,
                    decoration: InputDecoration(
                      labelText: "วันเกิด",
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                    ),
                    readOnly: true,
                    onTap: () => selectDate(context),
                    validator:
                        (value) => value!.isEmpty ? "กรุณาเลือกวันเกิด" : null,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter Email",
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: Icon(Icons.email, color: Colors.white),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกอีเมล";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: Icon(Icons.password, color: Colors.white),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Confirm Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: Icon(Icons.password, color: Colors.white),
                    ),
                    validator: (value) {
                      value!.isEmpty ? "กรุณายืนยันรหัสผ่าน" : null;
                    },
                  ),
                  SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: _register,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 170,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
