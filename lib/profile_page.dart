import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
class ProfilePage extends StatelessWidget {
 final String user;
 const ProfilePage({super.key, required this.user});
 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: GFAppBar(
 title: const Text("Profile Page"),
 backgroundColor: GFColors.PRIMARY,
 ),
 body: Column(
 children: [
 const SizedBox(height: 20),
 // PROFILE CARD
 GFCard(
 title: GFListTile(
 avatar: const GFAvatar(
 backgroundImage: AssetImage("assets/images/myimage.jpg"),
 ),
 titleText: "Username",
 subTitleText: user,
 ),
 content: const Text(" Welcome to your profile page."),
 ),
 const SizedBox(height: 20),
 // LOGOUT: FRONTEND CLEARS PAGE & GOES BACK
 GFButton(
 onPressed: () {
 Navigator.popUntil(context, (route) => route.isFirst);
 GFToast.showToast("Logged Out ", context,
 backgroundColor: Colors.red);
 },
 text: "Logout",
 color: GFColors.DANGER,
 fullWidthButton: true,
 ),
 ],
 ),
 );
 }
}