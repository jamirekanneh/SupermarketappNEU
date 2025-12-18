import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("GFCard + GetWidget Components"),
          backgroundColor: GFColors.PRIMARY,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 🟦 First GetWidget Component — GFCard
              GFCard(
                boxFit: BoxFit.cover,
                image: Image.network(
                  'https://picsum.photos/400/200', // You can use Image.asset('assets/image.png') too
                  fit: BoxFit.cover,
                ),
                title: GFListTile(
                  avatar: GFAvatar(
                    backgroundImage:
                        NetworkImage('https://picsum.photos/100'), // avatar image
                  ),
                  titleText: 'Card Title',
                  subTitleText: 'Card Sub Title',
                ),
                content: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Some quick example text to build on the card.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                buttonBar: GFButtonBar(
                  children: <Widget>[
                    GFButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Buy clicked!')),
                        );
                      },
                      text: 'Buy',
                      color: GFColors.SUCCESS,
                    ),
                    GFButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cancel clicked!')),
                        );
                      },
                      text: 'Cancel',
                      color: GFColors.DANGER,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20), // Space before next widget
              // 🟪 Placeholder for adding more GetWidget components
              GFButton(
                onPressed: () {},
                text: "Next Component Example",
                color: GFColors.INFO,
              ),

              const SizedBox(height: 20),

              GFToggle(
                onChanged: (val) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Toggle switched: $val')),
                  );
                },
                value: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
