import 'package:flutter/material.dart';

class StudentIDPage extends StatelessWidget {
  const StudentIDPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/profile.jpg"), // Put a pic in assets later
              ),
              const SizedBox(height: 12),

              const Text(
                "STUDENT ID CARD",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const Divider(height: 20),

              buildRow("Name", "Eric Njuguna"),
              buildRow("Reg No", "CIS/21/00123"),
              buildRow("Course", "Computer Information Systems"),
              buildRow("Year", "3rd Year"),
              buildRow("Campus", "Cyprus"),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Download Card"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
