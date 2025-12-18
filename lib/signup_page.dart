import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dashboard_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  bool loading = false;

  Future<void> _signUp() async {
    final username = usernameCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    final confirm = confirmCtrl.text.trim();

    if (username.isEmpty || password.isEmpty || confirm.isEmpty) {
      GFToast.showToast(
        "Please fill in all fields",
        context,
        backgroundColor: Colors.red,
      );
      return;
    }

    if (password != confirm) {
      GFToast.showToast(
        "Passwords do not match",
        context,
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => loading = true);

    try {
      // 1. Create user with Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "$username@app.com",
        password: password,
      );

      // 2. Save user in Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "username": username,
        "createdAt": FieldValue.serverTimestamp(),
      });

      setState(() => loading = false);

      GFToast.showToast(
        "Account created",
        context,
        backgroundColor: Colors.green,
      );

      // 3. Go straight to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardPage(username: username),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => loading = false);

      String msg = "Signup failed";

      if (e.code == 'email-already-in-use') {
        msg = "This username is already taken";
      } else if (e.code == 'weak-password') {
        msg = "Password is too weak";
      } else if (e.message != null) {
        msg = "Signup failed: ${e.message}";
      }

      GFToast.showToast(
        msg,
        context,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      setState(() => loading = false);

      GFToast.showToast(
        "Unexpected error: $e",
        context,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text("Sign Up"),
        backgroundColor: GFColors.PRIMARY,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GFTextField(
              controller: usernameCtrl,
              decoration: const InputDecoration(
                labelText: "Create Username",
              ),
            ),
            const SizedBox(height: 16),
            GFTextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),
            const SizedBox(height: 16),
            GFTextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
              ),
            ),
            const SizedBox(height: 24),
            GFButton(
              onPressed: loading ? null : _signUp,
              text: loading ? "Creating..." : "Sign Up",
              fullWidthButton: true,
              size: GFSize.LARGE,
            ),
          ],
        ),
      ),
    );
  }
}
