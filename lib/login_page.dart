import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dashboard_page.dart';
import 'signup_page.dart'; // 👈 make sure this file exists with class SignUpPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool loading = false;

  Future<void> _login() async {
    final username = usernameCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    if (username.isEmpty || password.isEmpty) {
      GFToast.showToast(
        "Please enter username and password",
        context,
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => loading = true);

    try {
      // 1. Login with Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "$username@app.com",
        password: password,
      );

      // 2. Get username from Firestore (typed)
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .get();

      final data = userDoc.data();
      String fetchedUsername = data?["username"] as String? ?? username;

      setState(() => loading = false);

      GFToast.showToast(
        "Login Successful",
        context,
        backgroundColor: Colors.green,
      );

      // 3. Go to Dashboard
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardPage(username: fetchedUsername),
        ),
      );
    } on FirebaseAuthException catch (_) {
      setState(() => loading = false);

      GFToast.showToast(
        "Invalid Credentials",
        context,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      setState(() => loading = false);

      GFToast.showToast(
        "Unexpected Error: $e",
        context,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _forgotPassword() async {
    final username = usernameCtrl.text.trim();

    if (username.isEmpty) {
      GFToast.showToast(
        "Enter your username first",
        context,
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: "$username@app.com",
      );

      GFToast.showToast(
        "Password reset email sent",
        context,
        backgroundColor: Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      String msg = "Could not send reset email";
      if (e.code == 'user-not-found') {
        msg = "No account found for this username";
      } else if (e.message != null) {
        msg = e.message!;
      }

      GFToast.showToast(
        msg,
        context,
        backgroundColor: Colors.red,
      );
    } catch (e) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text("Login"),
        backgroundColor: GFColors.PRIMARY,
      ),
      body: SingleChildScrollView( // 👈 so content doesn’t get cut off
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              GFTextField(
                controller: usernameCtrl,
                decoration: const InputDecoration(
                  labelText: "Username",
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

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _forgotPassword,
                  child: const Text("Forgot Password?"),
                ),
              ),

              const SizedBox(height: 16),

              // Login button
              GFButton(
                onPressed: loading ? null : _login,
                text: loading ? "Logging in..." : "Login",
                fullWidthButton: true,
                size: GFSize.LARGE,
              ),

              const SizedBox(height: 16),

              // Go to Sign Up
              GFButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignUpPage(),
                    ),
                  );
                },
                text: "Create an Account",
                color: GFColors.WARNING,
                fullWidthButton: true,
                size: GFSize.LARGE,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
