import 'package:flutter/material.dart';
    void main() => runApp(MyApp());
    
    class MyApp extends StatelessWidget {
  const MyApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Welcome to Project',
          home: Scaffold(
            appBar: AppBar(
              title: Text('Welcome to Project'),
            ),
            body: Center(
              child: Text('Hello world'),
            ),
          ),
        );
      }
    }