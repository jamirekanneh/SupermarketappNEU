import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'profile_page.dart';

class DashboardPage extends StatelessWidget {
  final String username; // Received from login page

  const DashboardPage({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text("Welcome $username"),
        backgroundColor: GFColors.PRIMARY,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // A SAMPLE CARD WITH USER INFO
          GFCard(
            title: GFListTile(
              avatar: const GFAvatar(
                backgroundImage: AssetImage('assets/images/myimage.jpg'),
              ),
              titleText: 'Logged in as:',
              subTitleText: username,
            ),
            content: const Text("You are now authenticated! "),
            buttonBar: GFButtonBar(
              children: [
                GFButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfilePage(user: username),
                      ),
                    );
                  },
                  text: "View Profile",
                  color: GFColors.INFO,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
