import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text("Midterm App Bar Sample"),
        backgroundColor: GFColors.PRIMARY,
      ),
      body: const Center(
        child: Text("Hello!"),

        
      ),
    );
  }
}
